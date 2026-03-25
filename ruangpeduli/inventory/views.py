from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.permissions import AllowAny
from django.shortcuts import get_object_or_404
from accounts.models import User
from profiles.models import OrphanageProfile
from .models import InventoryCategory, InventoryItem
from .serializers import (
    InventoryCategorySerializer,
    InventoryCategoryLightSerializer,
    InventoryItemSerializer,
)


# ─── Categories ───────────────────────────────────────────────────────────────

class CategoryListView(APIView):
    """
    GET  /api/inventory/categories/            → list all categories (all pantis) — public
    GET  /api/inventory/categories/?panti=<id> → filter by panti
    POST /api/inventory/categories/            → create category (panti only)
      Body: { user_id, name }
    """
    permission_classes = [AllowAny]

    def get(self, request):
        qs = InventoryCategory.objects.select_related('panti')
        panti_id = request.query_params.get('panti')
        if panti_id:
            qs = qs.filter(panti_id=panti_id)
        serializer = InventoryCategoryLightSerializer(qs, many=True)
        return Response(serializer.data)

    def post(self, request):
        user_id = request.data.get('user_id')
        name    = request.data.get('name', '').strip()
        if not user_id or not name:
            return Response({'error': 'user_id dan name wajib diisi'}, status=status.HTTP_400_BAD_REQUEST)

        try:
            user = User.objects.get(id=user_id, role='panti')
        except User.DoesNotExist:
            return Response({'error': 'User tidak ditemukan atau bukan panti'}, status=status.HTTP_403_FORBIDDEN)

        panti = get_object_or_404(OrphanageProfile, user=user)
        if InventoryCategory.objects.filter(panti=panti, name__iexact=name).exists():
            return Response({'error': 'Kategori dengan nama ini sudah ada'}, status=status.HTTP_400_BAD_REQUEST)

        category = InventoryCategory.objects.create(panti=panti, name=name)
        return Response(InventoryCategoryLightSerializer(category).data, status=status.HTTP_201_CREATED)


class CategoryDetailView(APIView):
    """
    GET    /api/inventory/categories/<id>/  → detail with full item list — public
    PUT    /api/inventory/categories/<id>/  → rename category (panti owner only)
      Body: { user_id, name }
    DELETE /api/inventory/categories/<id>/  → delete category + all its items
      Body: { user_id }
    """
    permission_classes = [AllowAny]

    def get(self, request, pk):
        category = get_object_or_404(InventoryCategory, pk=pk)
        serializer = InventoryCategorySerializer(category)
        return Response(serializer.data)

    def _check_owner(self, request, category):
        user_id = request.data.get('user_id')
        if not user_id:
            return None, Response({'error': 'user_id wajib diisi'}, status=status.HTTP_400_BAD_REQUEST)
        try:
            user = User.objects.get(id=user_id, role='panti')
        except User.DoesNotExist:
            return None, Response({'error': 'User tidak ditemukan atau bukan panti'}, status=status.HTTP_403_FORBIDDEN)
        if category.panti.user_id != user.id:
            return None, Response({'error': 'Tidak diizinkan'}, status=status.HTTP_403_FORBIDDEN)
        return user, None

    def put(self, request, pk):
        category = get_object_or_404(InventoryCategory, pk=pk)
        _, err = self._check_owner(request, category)
        if err:
            return err
        name = request.data.get('name', '').strip()
        if not name:
            return Response({'error': 'name wajib diisi'}, status=status.HTTP_400_BAD_REQUEST)
        category.name = name
        category.save()
        return Response(InventoryCategoryLightSerializer(category).data)

    def delete(self, request, pk):
        category = get_object_or_404(InventoryCategory, pk=pk)
        _, err = self._check_owner(request, category)
        if err:
            return err
        category.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)


# ─── Items ────────────────────────────────────────────────────────────────────

class ItemListView(APIView):
    """
    GET  /api/inventory/categories/<cat_id>/items/                     → all items — public
    GET  /api/inventory/categories/<cat_id>/items/?status=out_of_stock → filter by status
    POST /api/inventory/categories/<cat_id>/items/                     → add item (panti owner only)
      Body: { user_id, name, quantity, unit?, description? }
    """
    permission_classes = [AllowAny]

    def get(self, request, cat_id):
        category = get_object_or_404(InventoryCategory, pk=cat_id)
        qs = category.items.all()
        status_filter = request.query_params.get('status')
        if status_filter == 'available':
            qs = qs.filter(quantity__gt=0)
        elif status_filter == 'out_of_stock':
            qs = qs.filter(quantity=0)
        return Response(InventoryItemSerializer(qs, many=True).data)

    def post(self, request, cat_id):
        category = get_object_or_404(InventoryCategory, pk=cat_id)
        user_id  = request.data.get('user_id')
        if not user_id:
            return Response({'error': 'user_id wajib diisi'}, status=status.HTTP_400_BAD_REQUEST)
        try:
            user = User.objects.get(id=user_id, role='panti')
        except User.DoesNotExist:
            return Response({'error': 'User tidak ditemukan atau bukan panti'}, status=status.HTTP_403_FORBIDDEN)
        if category.panti.user_id != user.id:
            return Response({'error': 'Tidak diizinkan'}, status=status.HTTP_403_FORBIDDEN)

        serializer = InventoryItemSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save(category=category)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class ItemDetailView(APIView):
    """
    GET    /api/inventory/items/<id>/  → item detail — public
    PUT    /api/inventory/items/<id>/  → update (panti owner only)
      Body: { user_id, name?, quantity?, unit?, description? }
    DELETE /api/inventory/items/<id>/  → delete (panti owner only)
      Body: { user_id }
    """
    permission_classes = [AllowAny]

    def _get_item_and_check(self, request, pk):
        item    = get_object_or_404(InventoryItem, pk=pk)
        user_id = request.data.get('user_id')
        if not user_id:
            return item, None, Response({'error': 'user_id wajib diisi'}, status=status.HTTP_400_BAD_REQUEST)
        try:
            user = User.objects.get(id=user_id, role='panti')
        except User.DoesNotExist:
            return item, None, Response({'error': 'User tidak ditemukan atau bukan panti'}, status=status.HTTP_403_FORBIDDEN)
        if item.category.panti.user_id != user.id:
            return item, None, Response({'error': 'Tidak diizinkan'}, status=status.HTTP_403_FORBIDDEN)
        return item, user, None

    def get(self, request, pk):
        item = get_object_or_404(InventoryItem, pk=pk)
        return Response(InventoryItemSerializer(item).data)

    def put(self, request, pk):
        item, _, err = self._get_item_and_check(request, pk)
        if err:
            return err
        serializer = InventoryItemSerializer(item, data=request.data, partial=True)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, pk):
        item, _, err = self._get_item_and_check(request, pk)
        if err:
            return err
        item.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)
