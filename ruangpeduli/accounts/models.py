from django.db import models

class Society(models.Model):

    username = models.CharField(max_length=150, unique=True)
    email = models.EmailField(unique=True)
    sandi = models.CharField(max_length=128)
    alamat = models.TextField(blank=True, null=True)
    nama_pengguna = models.CharField(max_length=255, blank=True, null=True)

    def __str__(self):
        return self.email
    

