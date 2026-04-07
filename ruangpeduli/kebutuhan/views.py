from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.permissions import AllowAny
from django.shortcuts import get_object_or_404
from accounts.models import User
from profiles.models import OrphanageProfile
from .models import KebutuhanItem
from .serializers import KebutuhanItemSerializer, KebutuhanItemWithPantiSerializer


class KebutuhanAllView(APIView):
    """
    GET /api/kebutuhan/all/ → list all kebutuhan across every panti (public)
    Returns each item with panti_id and panti_name included.
    """
    permission_classes = [AllowAny]

    def get(self, request):
        qs = KebutuhanItem.objects.select_related('panti').order_by('panti__nama_panti', '-created_at')
        return Response(KebutuhanItemWithPantiSerializer(qs, many=True).data)


class KebutuhanListView(APIView):
    """
    GET  /api/kebutuhan/?panti=<id>  → list all kebutuhan for a panti
    POST /api/kebutuhan/             → add item
      Body: { user_id, nama, satuan, jumlah }
    """
    permission_classes = [AllowAny]

    def get(self, request):
        panti_id = request.query_params.get('panti')
        if not panti_id:
            return Response({'error': 'panti query param wajib diisi'}, status=status.HTTP_400_BAD_REQUEST)
        qs = KebutuhanItem.objects.filter(panti_id=panti_id)
        return Response(KebutuhanItemSerializer(qs, many=True).data)

    def post(self, request):
        user_id = request.data.get('user_id')
        nama    = request.data.get('nama', '').strip()
        satuan  = request.data.get('satuan', '').strip()
        jumlah  = request.data.get('jumlah')

        if not all([user_id, nama, satuan, jumlah]):
            return Response({'error': 'user_id, nama, satuan, jumlah wajib diisi'}, status=status.HTTP_400_BAD_REQUEST)

        try:
            user = User.objects.get(id=user_id, role='panti')
        except User.DoesNotExist:
            return Response({'error': 'User tidak ditemukan atau bukan panti'}, status=status.HTTP_403_FORBIDDEN)

        panti = get_object_or_404(OrphanageProfile, user=user)

        try:
            jumlah = int(jumlah)
            if jumlah <= 0:
                raise ValueError
        except (ValueError, TypeError):
            return Response({'error': 'jumlah harus bilangan bulat positif'}, status=status.HTTP_400_BAD_REQUEST)

        item = KebutuhanItem.objects.create(panti=panti, nama=nama, satuan=satuan, jumlah=jumlah)
        return Response(KebutuhanItemSerializer(item).data, status=status.HTTP_201_CREATED)


class KebutuhanDetailView(APIView):
    """
    DELETE /api/kebutuhan/<id>/  → delete item (panti owner only)
      Body: { user_id }
    """
    permission_classes = [AllowAny]

    def delete(self, request, pk):
        item = get_object_or_404(KebutuhanItem, pk=pk)
        user_id = request.data.get('user_id')
        if not user_id:
            return Response({'error': 'user_id wajib diisi'}, status=status.HTTP_400_BAD_REQUEST)
        try:
            user = User.objects.get(id=user_id, role='panti')
        except User.DoesNotExist:
            return Response({'error': 'User tidak ditemukan atau bukan panti'}, status=status.HTTP_403_FORBIDDEN)
        if item.panti.user_id != user.id:
            return Response({'error': 'Tidak diizinkan'}, status=status.HTTP_403_FORBIDDEN)
        item.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)
