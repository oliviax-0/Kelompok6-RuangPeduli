from rest_framework import serializers
from .models import SocietyProfile, OrphanageProfile

class SocietyProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = SocietyProfile
        fields = '__all__'


class OrphanageProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = OrphanageProfile
        fields = '__all__'
