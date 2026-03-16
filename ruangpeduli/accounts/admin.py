from django.contrib import admin
from .models import Society



@admin.register(Society)
class SocietyAdmin(admin.ModelAdmin):
	list_display = ("id", "username", "email", "sandi", "alamat", "nama_pengguna")
