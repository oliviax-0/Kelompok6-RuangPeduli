from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.permissions import AllowAny
from django.shortcuts import get_object_or_404
from accounts.models import User
from profiles.models import OrphanageProfile
from .models import Berita, BeritaImage, BeritaVote, Video
from .serializers import BeritaSerializer, BeritaImageSerializer, VideoSerializer


# ─── Berita ───────────────────────────────────────────────────────────────────

class BeritaListView(APIView):
    """
    GET  /api/content/berita/           → list published beritas (all pantis)
    GET  /api/content/berita/?panti=<id> → filter by panti
    POST /api/content/berita/           → create (panti user only)
      Body: { user_id, panti_id, title, content, thumbnail?, is_published? }
    """
    permission_classes = [AllowAny]

    def get(self, request):
        qs = Berita.objects.filter(is_published=True).select_related('author', 'panti')
        panti_id = request.query_params.get('panti')
        if panti_id:
            qs = qs.filter(panti_id=panti_id)
        serializer = BeritaSerializer(qs, many=True, context={'request': request})
        return Response(serializer.data)

    def post(self, request):
        user_id = request.data.get('user_id')
        if not user_id:
            return Response({'error': 'user_id wajib diisi'}, status=status.HTTP_400_BAD_REQUEST)

        try:
            user = User.objects.get(id=user_id, role='panti')
        except User.DoesNotExist:
            return Response({'error': 'User tidak ditemukan atau bukan panti'}, status=status.HTTP_403_FORBIDDEN)

        panti = get_object_or_404(OrphanageProfile, user=user)

        serializer = BeritaSerializer(data={
            **request.data,
            'author': user.id,
            'panti': panti.id,
        }, context={'request': request})

        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class BeritaDetailView(APIView):
    """
    GET    /api/content/berita/<id>/  → detail
    PUT    /api/content/berita/<id>/  → update (owner panti only)
      Body: { user_id, ...fields }
    DELETE /api/content/berita/<id>/  → delete (owner panti only)
      Body: { user_id }
    """
    permission_classes = [AllowAny]

    def get(self, request, pk):
        berita = get_object_or_404(Berita, pk=pk)
        serializer = BeritaSerializer(berita, context={'request': request})
        return Response(serializer.data)

    def put(self, request, pk):
        berita = get_object_or_404(Berita, pk=pk)
        user_id = request.data.get('user_id')
        if not user_id or berita.author_id != int(user_id):
            return Response({'error': 'Tidak diizinkan'}, status=status.HTTP_403_FORBIDDEN)

        serializer = BeritaSerializer(berita, data=request.data, partial=True, context={'request': request})
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, pk):
        berita = get_object_or_404(Berita, pk=pk)
        user_id = request.data.get('user_id')
        if not user_id or berita.author_id != int(user_id):
            return Response({'error': 'Tidak diizinkan'}, status=status.HTTP_403_FORBIDDEN)
        berita.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)


class BeritaVoteView(APIView):
    """
    POST /api/content/berita/<id>/vote/
    Body: { user_id, vote_type: 'up'|'down' }
    - If same vote_type → remove vote (toggle off)
    - If different vote_type → switch vote
    """
    permission_classes = [AllowAny]

    def post(self, request, pk):
        berita = get_object_or_404(Berita, pk=pk)
        user_id = request.data.get('user_id')
        vote_type = request.data.get('vote_type')

        if not user_id or vote_type not in ('up', 'down'):
            return Response({'error': 'user_id dan vote_type (up/down) wajib diisi'}, status=status.HTTP_400_BAD_REQUEST)

        try:
            user = User.objects.get(id=user_id)
        except User.DoesNotExist:
            return Response({'error': 'User tidak ditemukan'}, status=status.HTTP_404_NOT_FOUND)

        existing = BeritaVote.objects.filter(berita=berita, user=user).first()

        if existing:
            if existing.vote_type == vote_type:
                existing.delete()
                action = 'removed'
            else:
                existing.vote_type = vote_type
                existing.save()
                action = 'switched'
        else:
            BeritaVote.objects.create(berita=berita, user=user, vote_type=vote_type)
            action = 'added'

        return Response({
            'action': action,
            'upvote_count': berita.upvote_count,
            'downvote_count': berita.downvote_count,
        })


# ─── Video ────────────────────────────────────────────────────────────────────

class VideoListView(APIView):
    """
    GET  /api/content/video/            → list published videos (all pantis)
    GET  /api/content/video/?panti=<id> → filter by panti
    POST /api/content/video/            → create (panti user only)
      Body: { user_id, panti_id, title, video_url, description?, thumbnail?, is_published? }
    """
    permission_classes = [AllowAny]

    def get(self, request):
        qs = Video.objects.filter(is_published=True).select_related('author', 'panti')
        panti_id = request.query_params.get('panti')
        if panti_id:
            qs = qs.filter(panti_id=panti_id)
        serializer = VideoSerializer(qs, many=True, context={'request': request})
        return Response(serializer.data)

    def post(self, request):
        user_id = request.data.get('user_id')
        if not user_id:
            return Response({'error': 'user_id wajib diisi'}, status=status.HTTP_400_BAD_REQUEST)

        try:
            user = User.objects.get(id=user_id, role='panti')
        except User.DoesNotExist:
            return Response({'error': 'User tidak ditemukan atau bukan panti'}, status=status.HTTP_403_FORBIDDEN)

        panti = get_object_or_404(OrphanageProfile, user=user)

        serializer = VideoSerializer(data={
            **request.data,
            'author': user.id,
            'panti': panti.id,
        }, context={'request': request})

        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class VideoDetailView(APIView):
    """
    GET    /api/content/video/<id>/
    PUT    /api/content/video/<id>/  → update (owner only)
    DELETE /api/content/video/<id>/  → delete (owner only)
    """
    permission_classes = [AllowAny]

    def get(self, request, pk):
        video = get_object_or_404(Video, pk=pk)
        serializer = VideoSerializer(video, context={'request': request})
        return Response(serializer.data)

    def put(self, request, pk):
        video = get_object_or_404(Video, pk=pk)
        user_id = request.data.get('user_id')
        if not user_id or video.author_id != int(user_id):
            return Response({'error': 'Tidak diizinkan'}, status=status.HTTP_403_FORBIDDEN)

        serializer = VideoSerializer(video, data=request.data, partial=True, context={'request': request})
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, pk):
        video = get_object_or_404(Video, pk=pk)
        user_id = request.data.get('user_id')
        if not user_id or video.author_id != int(user_id):
            return Response({'error': 'Tidak diizinkan'}, status=status.HTTP_403_FORBIDDEN)
        video.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)


# ─── BeritaImage ──────────────────────────────────────────────────────────────

class BeritaImageUploadView(APIView):
    """
    POST /api/content/berita/<id>/images/
    Multipart form: { user_id, image, caption?, order? }
    Adds an image to a berita post (owner only).

    DELETE /api/content/berita/<id>/images/<image_id>/
    Body: { user_id }
    """
    permission_classes = [AllowAny]

    def post(self, request, pk):
        berita = get_object_or_404(Berita, pk=pk)
        user_id = request.data.get('user_id')
        if not user_id or berita.author_id != int(user_id):
            return Response({'error': 'Tidak diizinkan'}, status=status.HTTP_403_FORBIDDEN)

        serializer = BeritaImageSerializer(data={
            'berita': berita.id,
            'image': request.data.get('image'),
            'caption': request.data.get('caption', ''),
            'order': request.data.get('order', 0),
        })
        if serializer.is_valid():
            serializer.save(berita=berita)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, pk, image_id):
        berita = get_object_or_404(Berita, pk=pk)
        user_id = request.data.get('user_id')
        if not user_id or berita.author_id != int(user_id):
            return Response({'error': 'Tidak diizinkan'}, status=status.HTTP_403_FORBIDDEN)

        image = get_object_or_404(BeritaImage, pk=image_id, berita=berita)
        image.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)
