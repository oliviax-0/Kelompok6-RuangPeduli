import os
import json
import requests as req_lib
from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.permissions import AllowAny
from django.shortcuts import get_object_or_404
from accounts.models import User
from profiles.models import OrphanageProfile
from .models import InventoryCategory, InventoryItem, StokLaporan
from .serializers import (
    InventoryCategorySerializer,
    InventoryCategoryLightSerializer,
    InventoryItemSerializer,
    StokLaporanSerializer,
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


# ─── Laporan (Stok History) ────────────────────────────────────────────────────

class LaporanView(APIView):
    """
    GET  /api/inventory/laporan/?panti=<id>  → list all laporan for a panti
    POST /api/inventory/laporan/             → record a stok masuk or keluar entry
      Body: { user_id, item_id, amount, type }   (type: 'masuk' | 'keluar')
    """
    permission_classes = [AllowAny]

    def get(self, request):
        panti_id = request.query_params.get('panti')
        if not panti_id:
            return Response({'error': 'panti query param wajib diisi'}, status=status.HTTP_400_BAD_REQUEST)
        qs = StokLaporan.objects.select_related('item__category').filter(
            item__category__panti_id=panti_id
        )
        return Response(StokLaporanSerializer(qs, many=True).data)

    def post(self, request):
        user_id = request.data.get('user_id')
        item_id = request.data.get('item_id')
        amount  = request.data.get('amount')
        tipe    = request.data.get('type')

        if not all([user_id, item_id, amount, tipe]):
            return Response(
                {'error': 'user_id, item_id, amount, dan type wajib diisi'},
                status=status.HTTP_400_BAD_REQUEST,
            )
        if tipe not in (StokLaporan.MASUK, StokLaporan.KELUAR):
            return Response({'error': "type harus 'masuk' atau 'keluar'"}, status=status.HTTP_400_BAD_REQUEST)

        try:
            user = User.objects.get(id=user_id, role='panti')
        except User.DoesNotExist:
            return Response({'error': 'User tidak ditemukan atau bukan panti'}, status=status.HTTP_403_FORBIDDEN)

        item = get_object_or_404(InventoryItem, pk=item_id)
        if item.category.panti.user_id != user.id:
            return Response({'error': 'Tidak diizinkan'}, status=status.HTTP_403_FORBIDDEN)

        try:
            amount = int(amount)
            if amount <= 0:
                raise ValueError
        except (ValueError, TypeError):
            return Response({'error': 'amount harus bilangan bulat positif'}, status=status.HTTP_400_BAD_REQUEST)

        laporan = StokLaporan.objects.create(item=item, amount=amount, tipe=tipe)
        return Response(StokLaporanSerializer(laporan).data, status=status.HTTP_201_CREATED)


# ─── AI PHRR Prediction ────────────────────────────────────────────────────────

class PredictPhrrView(APIView):
    """
    POST /api/inventory/predict-phrr/
    Body: { panti_id, product_name, unit }
    Returns: { daily_usage: float, reasoning: str }
    Uses Claude API to predict daily usage based on product type + resident count.
    """
    permission_classes = [AllowAny]

    def post(self, request):
        panti_id     = request.data.get('panti_id')
        product_name = request.data.get('product_name', '').strip()
        unit         = request.data.get('unit', 'pcs').strip()

        if not panti_id or not product_name:
            return Response({'error': 'panti_id dan product_name wajib diisi'}, status=status.HTTP_400_BAD_REQUEST)

        panti = get_object_or_404(OrphanageProfile, pk=panti_id)
        penghuni_count = panti.penghuni.count()

        api_key = os.environ.get('ANTHROPIC_API_KEY', '')
        if not api_key:
            return Response({'error': 'ANTHROPIC_API_KEY belum dikonfigurasi'}, status=status.HTTP_503_SERVICE_UNAVAILABLE)

        prompt = (
            f"Kamu adalah sistem AI untuk manajemen inventaris panti asuhan di Indonesia.\n"
            f"Berikan prediksi pemakaian harian rata-rata (PHRR) untuk produk berikut:\n\n"
            f"Produk: {product_name}\n"
            f"Satuan: {unit}\n"
            f"Jumlah penghuni panti: {penghuni_count} orang\n\n"
            f"Pertimbangkan:\n"
            f"- Jenis produk (makanan pokok lebih cepat habis dari bumbu dapur)\n"
            f"- Jumlah penghuni ({penghuni_count} orang) sebagai faktor pengali utama\n"
            f"- Kebiasaan konsumsi di panti asuhan Indonesia\n\n"
            f"Balas HANYA dalam format JSON berikut, tanpa teks lain:\n"
            f'{{ "daily_usage": <angka desimal>, "reasoning": "<alasan singkat 1 kalimat>" }}'
        )

        try:
            resp = req_lib.post(
                'https://api.anthropic.com/v1/messages',
                headers={
                    'x-api-key': api_key,
                    'anthropic-version': '2023-06-01',
                    'content-type': 'application/json',
                },
                json={
                    'model': 'claude-haiku-4-5-20251001',
                    'max_tokens': 128,
                    'messages': [{'role': 'user', 'content': prompt}],
                },
                timeout=20,
            )
            resp.raise_for_status()
            text = resp.json()['content'][0]['text'].strip()
            # Strip markdown code fences if present
            if text.startswith('```'):
                text = text.split('```')[1]
                if text.startswith('json'):
                    text = text[4:]
            result = json.loads(text)
            daily_usage = float(result.get('daily_usage', 0))
            reasoning   = result.get('reasoning', '')
            return Response({'daily_usage': daily_usage, 'reasoning': reasoning, 'unit': unit})
        except Exception as e:
            return Response({'error': f'Gagal memanggil AI: {e}'}, status=status.HTTP_502_BAD_GATEWAY)


# ─── Low Stock Notifications ───────────────────────────────────────────────────

class LowStockView(APIView):
    """
    GET /api/inventory/low-stock/?panti_id=<id>
    Returns items that need_restock (qty=0 OR days_until_empty <= lead_time_days).
    Each item includes days_until_empty so the UI can show urgency.
    """
    permission_classes = [AllowAny]

    def get(self, request):
        panti_id = request.query_params.get('panti_id')
        if not panti_id:
            return Response({'error': 'panti_id wajib diisi'}, status=status.HTTP_400_BAD_REQUEST)

        items = InventoryItem.objects.filter(
            category__panti_id=panti_id
        ).select_related('category')

        result = []
        for item in items:
            if item.needs_restock:
                d = item.days_until_empty
                result.append({
                    'id': item.id,
                    'name': item.name,
                    'quantity': item.quantity,
                    'unit': item.unit,
                    'daily_usage': item.daily_usage,
                    'lead_time_days': item.lead_time_days,
                    'days_until_empty': round(d, 1) if d is not None else None,
                    'category_id': item.category.id,
                    'category_name': item.category.name,
                    'is_out_of_stock': item.quantity == 0,
                })

        result.sort(key=lambda x: (x['days_until_empty'] is None, x['days_until_empty'] or 0))
        return Response(result)
