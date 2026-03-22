from rest_framework import viewsets, status
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import AllowAny
from django.shortcuts import get_object_or_404
from .models import SocietyProfile, OrphanageProfile, PantiMedia
from .serializers import SocietyProfileSerializer, OrphanageProfileSerializer, PantiMediaSerializer


class SocietyProfileViewSet(viewsets.ModelViewSet):
    queryset = SocietyProfile.objects.all()
    serializer_class = SocietyProfileSerializer


class OrphanageProfileViewSet(viewsets.ModelViewSet):
    queryset = OrphanageProfile.objects.all()
    serializer_class = OrphanageProfileSerializer
    permission_classes = [AllowAny]


class PantiMediaView(APIView):
    """
    GET    /api/profiles/panti/<panti_id>/media/              → list media
    POST   /api/profiles/panti/<panti_id>/media/              → add media
      Multipart: { media_type, file?, video_url?, order? }
    DELETE /api/profiles/panti/<panti_id>/media/<media_id>/   → delete media
    """
    permission_classes = [AllowAny]

    def get(self, request, panti_id):
        panti = get_object_or_404(OrphanageProfile, pk=panti_id)
        serializer = PantiMediaSerializer(
            panti.media.all(), many=True, context={'request': request}
        )
        return Response(serializer.data)

    def post(self, request, panti_id):
        panti = get_object_or_404(OrphanageProfile, pk=panti_id)
        serializer = PantiMediaSerializer(
            data=request.data, context={'request': request}
        )
        if serializer.is_valid():
            serializer.save(panti=panti)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, panti_id, media_id):
        panti = get_object_or_404(OrphanageProfile, pk=panti_id)
        media = get_object_or_404(PantiMedia, pk=media_id, panti=panti)
        media.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)