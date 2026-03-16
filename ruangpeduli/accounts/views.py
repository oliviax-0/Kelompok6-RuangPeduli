from django.shortcuts import render
from rest_framework import viewsets
from .models import Society
from .serializers import SocietySerializer
from rest_framework import generics

class SocietyViewSet(viewsets.ModelViewSet):
    queryset = Society.objects.all()
    serializer_class = SocietySerializer

class SocietyRegisterView(generics.CreateAPIView):
    queryset = Society.objects.all()
    serializer_class = SocietySerializer

class SocietyUpdateView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Society.objects.all()
    serializer_class = SocietySerializer