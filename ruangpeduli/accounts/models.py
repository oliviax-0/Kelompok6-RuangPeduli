from django.contrib.auth.models import AbstractUser
from django.db import models
import uuid

class User(AbstractUser):
    ROLE_CHOICES = [
        ('masyarakat', 'Masyarakat'),
        ('panti', 'Panti Sosial'),
    ]
    
    role = models.CharField(max_length=20, choices=ROLE_CHOICES)

class PendingRegistration(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    username = models.CharField(max_length=150)
    email = models.EmailField()
    password = models.CharField(max_length=255, default='')  # <-- tambah default=''
    role = models.CharField(max_length=20)
    
    # Masyarakat
    nama_pengguna = models.CharField(max_length=255, null=True, blank=True)
    alamat = models.TextField(null=True, blank=True)
    
    # Panti
    nama_panti = models.CharField(max_length=255, null=True, blank=True)
    alamat_panti = models.TextField(null=True, blank=True)
    nomor_panti = models.CharField(max_length=20, null=True, blank=True)
    
    # OTP
    otp_code = models.CharField(max_length=5, null=True, blank=True)
    expires_at = models.DateTimeField(null=True, blank=True)
    
    created_at = models.DateTimeField(auto_now_add=True)
    
    def __str__(self):
        return f"{self.email} - {self.role}"


