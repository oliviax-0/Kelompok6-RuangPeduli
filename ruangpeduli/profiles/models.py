from django.db import models
from accounts.models import User


class SocietyProfile(models.Model):
    """Profile untuk role masyarakat"""
    user = models.OneToOneField(
        User,
        on_delete=models.CASCADE,
        related_name='society_profile'
    )
    nama_pengguna = models.CharField(max_length=255)
    alamat = models.TextField()

    def __str__(self):
        return f"{self.nama_pengguna} ({self.user.email})"


class OrphanageProfile(models.Model):
    """Profile untuk role panti"""
    user = models.OneToOneField(
        User,
        on_delete=models.CASCADE,
        related_name='orphanage_profile'
    )
    nama_panti = models.CharField(max_length=255)
    alamat_panti = models.TextField()
    nomor_panti = models.CharField(max_length=20)

    def __str__(self):
        return f"{self.nama_panti} ({self.user.email})"