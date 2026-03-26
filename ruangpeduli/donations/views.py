from datetime import date

from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework.permissions import AllowAny

from accounts.models import User
from .models import Donasi
from .serializers import DonasiSerializer


class DonasiListCreateView(APIView):
    permission_classes = [AllowAny]

    def get(self, request):
        user_id = request.query_params.get('user_id')
        if not user_id:
            return Response({'error': 'user_id wajib diisi'}, status=status.HTTP_400_BAD_REQUEST)
        donasi = Donasi.objects.filter(user_id=user_id).order_by('-tanggal')
        serializer = DonasiSerializer(donasi, many=True, context={'request': request})
        return Response(serializer.data)

    def post(self, request):
        user_id = request.data.get('user_id')
        panti_id = request.data.get('panti_id')
        nama_panti = request.data.get('nama_panti', '')
        jumlah = request.data.get('jumlah')
        metode = request.data.get('metode_pembayaran', '')
        no_ref = request.data.get('no_referensi', '')

        if not user_id or jumlah is None:
            return Response({'error': 'user_id dan jumlah wajib diisi'}, status=status.HTTP_400_BAD_REQUEST)

        try:
            user = User.objects.get(id=user_id)
        except User.DoesNotExist:
            return Response({'error': 'User tidak ditemukan'}, status=status.HTTP_404_NOT_FOUND)

        panti = None
        if panti_id:
            try:
                from profiles.models import OrphanageProfile
                panti = OrphanageProfile.objects.get(id=panti_id)
                if not nama_panti:
                    nama_panti = panti.nama_panti
            except Exception:
                pass

        jumlah_int = int(jumlah)

        donasi = Donasi.objects.create(
            user=user,
            panti=panti,
            nama_panti=nama_panti,
            jumlah=jumlah_int,
            metode_pembayaran=metode,
            no_referensi=no_ref,
        )

        # Automatically update terkumpul on the panti by creating a Pemasukan record
        if panti is not None:
            try:
                from finance.models import JenisPemasukan, Pemasukan
                jenis, _ = JenisPemasukan.objects.get_or_create(
                    panti=panti,
                    nama='Donasi Masyarakat',
                )
                Pemasukan.objects.create(
                    panti=panti,
                    jenis_pemasukan=jenis,
                    jumlah=jumlah_int,
                    tanggal=date.today(),
                )
            except Exception:
                pass  # Don't fail the donation if pemasukan creation fails

        return Response(
            DonasiSerializer(donasi, context={'request': request}).data,
            status=status.HTTP_201_CREATED,
        )
