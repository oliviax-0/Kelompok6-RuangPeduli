from rest_framework import viewsets
from .models import SocietyProfile, OrphanageProfile
from .serializers import SocietyProfileSerializer, OrphanageProfileSerializer

class SocietyProfileViewSet(viewsets.ModelViewSet):
    queryset = SocietyProfile.objects.all()
    serializer_class = SocietyProfileSerializer

class OrphanageProfileViewSet(viewsets.ModelViewSet):
    queryset = OrphanageProfile.objects.all()
    serializer_class = OrphanageProfileSerializer