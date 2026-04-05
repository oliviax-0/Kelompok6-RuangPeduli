from rest_framework import serializers
from .models import KebutuhanItem


class KebutuhanItemSerializer(serializers.ModelSerializer):
    class Meta:
        model = KebutuhanItem
        fields = ['id', 'nama', 'satuan', 'jumlah', 'created_at']
        read_only_fields = ['id', 'created_at']
