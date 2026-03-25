from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.permissions import AllowAny
from django.shortcuts import get_object_or_404
from django.db.models import Q
from accounts.models import User
from profiles.models import OrphanageProfile
from .models import Penghuni, Pekerja
from .serializers import PenghuniSerializer, PekerjaSerializer


def _get_panti_user(user_id):
    """Return (user, panti, error_response). error_response is None on success."""
    try:
        user = User.objects.get(id=user_id, role='panti')
    except User.DoesNotExist:
        return None, None, Response({'error': 'User tidak ditemukan atau bukan panti'}, status=status.HTTP_403_FORBIDDEN)
    panti = get_object_or_404(OrphanageProfile, user=user)
    return user, panti, None


# ─── Penghuni ─────────────────────────────────────────────────────────────────

class PenghuniListView(APIView):
    """
    GET  /api/residents/penghuni/?user_id=<id>          → list penghuni milik panti
    GET  /api/residents/penghuni/?user_id=<id>&search=x → search by nama
    POST /api/residents/penghuni/                       → add penghuni (panti only)
      Body: { user_id, nama, tahun_lahir, jenis_kelamin }
    """
    permission_classes = [AllowAny]

    def get(self, request):
        user_id = request.query_params.get('user_id')
        if not user_id:
            return Response({'error': 'user_id wajib diisi'}, status=status.HTTP_400_BAD_REQUEST)
        _, panti, err = _get_panti_user(user_id)
        if err:
            return err
        qs = Penghuni.objects.filter(panti=panti)
        search = request.query_params.get('search', '').strip()
        if search:
            qs = qs.filter(nama__icontains=search)
        return Response(PenghuniSerializer(qs, many=True).data)

    def post(self, request):
        user_id = request.data.get('user_id')
        if not user_id:
            return Response({'error': 'user_id wajib diisi'}, status=status.HTTP_400_BAD_REQUEST)
        _, panti, err = _get_panti_user(user_id)
        if err:
            return err
        serializer = PenghuniSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save(panti=panti)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class PenghuniDetailView(APIView):
    """
    GET    /api/residents/penghuni/<id>/?user_id=<id>  → detail (panti owner only)
    PUT    /api/residents/penghuni/<id>/               → update (panti owner only)
    DELETE /api/residents/penghuni/<id>/               → delete (panti owner only)
      Body/param: { user_id, ...fields }
    """
    permission_classes = [AllowAny]

    def _check_owner(self, penghuni, user_id):
        if not user_id:
            return Response({'error': 'user_id wajib diisi'}, status=status.HTTP_400_BAD_REQUEST)
        _, panti, err = _get_panti_user(user_id)
        if err:
            return err
        if penghuni.panti_id != panti.id:
            return Response({'error': 'Tidak diizinkan'}, status=status.HTTP_403_FORBIDDEN)
        return None

    def get(self, request, pk):
        penghuni = get_object_or_404(Penghuni, pk=pk)
        err = self._check_owner(penghuni, request.query_params.get('user_id'))
        if err:
            return err
        return Response(PenghuniSerializer(penghuni).data)

    def put(self, request, pk):
        penghuni = get_object_or_404(Penghuni, pk=pk)
        err = self._check_owner(penghuni, request.data.get('user_id'))
        if err:
            return err
        serializer = PenghuniSerializer(penghuni, data=request.data, partial=True)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, pk):
        penghuni = get_object_or_404(Penghuni, pk=pk)
        err = self._check_owner(penghuni, request.data.get('user_id'))
        if err:
            return err
        penghuni.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)


# ─── Pekerja ──────────────────────────────────────────────────────────────────

class PekerjaListView(APIView):
    """
    GET  /api/residents/pekerja/?user_id=<id>          → list pekerja milik panti
    GET  /api/residents/pekerja/?user_id=<id>&search=x → search by nama/divisi/posisi
    POST /api/residents/pekerja/                       → add pekerja (panti only)
      Body: { user_id, nama, divisi, posisi }
    """
    permission_classes = [AllowAny]

    def get(self, request):
        user_id = request.query_params.get('user_id')
        if not user_id:
            return Response({'error': 'user_id wajib diisi'}, status=status.HTTP_400_BAD_REQUEST)
        _, panti, err = _get_panti_user(user_id)
        if err:
            return err
        qs = Pekerja.objects.filter(panti=panti)
        search = request.query_params.get('search', '').strip()
        if search:
            qs = qs.filter(
                Q(nama__icontains=search) |
                Q(divisi__icontains=search) |
                Q(posisi__icontains=search)
            )
        return Response(PekerjaSerializer(qs, many=True).data)

    def post(self, request):
        user_id = request.data.get('user_id')
        if not user_id:
            return Response({'error': 'user_id wajib diisi'}, status=status.HTTP_400_BAD_REQUEST)
        _, panti, err = _get_panti_user(user_id)
        if err:
            return err
        serializer = PekerjaSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save(panti=panti)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class PekerjaDetailView(APIView):
    """
    GET    /api/residents/pekerja/<id>/?user_id=<id>  → detail (panti owner only)
    PUT    /api/residents/pekerja/<id>/               → update (panti owner only)
    DELETE /api/residents/pekerja/<id>/               → delete (panti owner only)
      Body/param: { user_id, ...fields }
    """
    permission_classes = [AllowAny]

    def _check_owner(self, pekerja, user_id):
        if not user_id:
            return Response({'error': 'user_id wajib diisi'}, status=status.HTTP_400_BAD_REQUEST)
        _, panti, err = _get_panti_user(user_id)
        if err:
            return err
        if pekerja.panti_id != panti.id:
            return Response({'error': 'Tidak diizinkan'}, status=status.HTTP_403_FORBIDDEN)
        return None

    def get(self, request, pk):
        pekerja = get_object_or_404(Pekerja, pk=pk)
        err = self._check_owner(pekerja, request.query_params.get('user_id'))
        if err:
            return err
        return Response(PekerjaSerializer(pekerja).data)

    def put(self, request, pk):
        pekerja = get_object_or_404(Pekerja, pk=pk)
        err = self._check_owner(pekerja, request.data.get('user_id'))
        if err:
            return err
        serializer = PekerjaSerializer(pekerja, data=request.data, partial=True)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, pk):
        pekerja = get_object_or_404(Pekerja, pk=pk)
        err = self._check_owner(pekerja, request.data.get('user_id'))
        if err:
            return err
        pekerja.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)
