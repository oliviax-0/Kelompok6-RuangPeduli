from django.db import models
from profiles.models import OrphanageProfile


class InventoryCategory(models.Model):
    """A category of inventory items belonging to a panti (e.g. Makanan, Pakaian)."""
    panti = models.ForeignKey(OrphanageProfile, on_delete=models.CASCADE, related_name='inventory_categories')
    name  = models.CharField(max_length=100)

    class Meta:
        ordering = ['name']
        unique_together = [('panti', 'name')]

    def __str__(self):
        return f'{self.panti.nama_panti} — {self.name}'


class InventoryItem(models.Model):
    """A single product inside a category, with its stock quantity."""
    category    = models.ForeignKey(InventoryCategory, on_delete=models.CASCADE, related_name='items')
    name        = models.CharField(max_length=200)
    quantity    = models.PositiveIntegerField(default=0)
    unit        = models.CharField(max_length=50, default='pcs')   # e.g. kg, pcs, lusin, dus
    description = models.TextField(blank=True, default='')

    class Meta:
        ordering = ['name']

    def __str__(self):
        return f'{self.name} ({self.quantity} {self.unit})'

    @property
    def status(self):
        return 'available' if self.quantity > 0 else 'out_of_stock'


class StokLaporan(models.Model):
    """History log of every stok masuk / stok keluar transaction."""
    MASUK  = 'masuk'
    KELUAR = 'keluar'
    TIPE_CHOICES = [(MASUK, 'Masuk'), (KELUAR, 'Keluar')]

    item       = models.ForeignKey(InventoryItem, on_delete=models.CASCADE, related_name='laporan')
    amount     = models.PositiveIntegerField()
    tipe       = models.CharField(max_length=10, choices=TIPE_CHOICES)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ['-created_at']

    def __str__(self):
        return f'{self.item.name} {self.tipe} {self.amount} {self.item.unit}'
