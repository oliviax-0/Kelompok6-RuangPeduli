from rest_framework import serializers
from .models import InventoryCategory, InventoryItem


class InventoryItemSerializer(serializers.ModelSerializer):
    status = serializers.ReadOnlyField()

    class Meta:
        model  = InventoryItem
        fields = ['id', 'name', 'quantity', 'unit', 'description', 'status']


class InventoryCategorySerializer(serializers.ModelSerializer):
    items       = InventoryItemSerializer(many=True, read_only=True)
    item_count  = serializers.SerializerMethodField()
    panti_id    = serializers.IntegerField(source='panti.id', read_only=True)
    panti_name  = serializers.CharField(source='panti.nama_panti', read_only=True)

    class Meta:
        model  = InventoryCategory
        fields = ['id', 'panti_id', 'panti_name', 'name', 'item_count', 'items']

    def get_item_count(self, obj):
        return obj.items.count()


class InventoryCategoryLightSerializer(serializers.ModelSerializer):
    """Lightweight version without items list — for listing all categories."""
    item_count       = serializers.SerializerMethodField()
    available_count  = serializers.SerializerMethodField()
    panti_id         = serializers.IntegerField(source='panti.id', read_only=True)
    panti_name       = serializers.CharField(source='panti.nama_panti', read_only=True)

    class Meta:
        model  = InventoryCategory
        fields = ['id', 'panti_id', 'panti_name', 'name', 'item_count', 'available_count']

    def get_item_count(self, obj):
        return obj.items.count()

    def get_available_count(self, obj):
        return obj.items.filter(quantity__gt=0).count()
