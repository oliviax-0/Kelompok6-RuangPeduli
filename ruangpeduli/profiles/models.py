from django.db import models
from accounts.models import User

class SocietyProfile(models.Model):
    username = models.OneToOneField(User, on_delete=models.CASCADE)
    nama_pengguna = models.CharField(max_length=255)
    alamat = models.TextField()

class OrphanageProfile(models.Model):
    username = models.OneToOneField(User, on_delete=models.CASCADE)
    nama_panti = models.CharField(max_length=255)
    alamat_panti = models.TextField()
    nomor_panti = models.CharField(max_length=20)