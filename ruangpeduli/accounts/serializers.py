from rest_framework import serializers
from django.contrib.auth.hashers import make_password
from accounts.models import PendingRegistration, User

class RegisterStartSerializer(serializers.ModelSerializer):
    class Meta:
        model = PendingRegistration
        fields = [
            'id',
            'username',
            'email',
            'password',
            'role',
            'nama_pengguna',
            'alamat',
            'nama_panti',
            'alamat_panti',
            'nomor_panti',
        ]

    def validate(self, attrs):
        role = attrs.get('role')
        errors = {}

        if role == 'masyarakat':
            if not attrs.get('nama_pengguna'):
                errors['nama_pengguna'] = 'Wajib diisi untuk masyarakat.'
            if not attrs.get('alamat'):
                errors['alamat'] = 'Wajib diisi untuk masyarakat.'
        elif role == 'panti':
            if not attrs.get('nama_panti'):
                errors['nama_panti'] = 'Wajib diisi untuk panti.'
            if not attrs.get('alamat_panti'):
                errors['alamat_panti'] = 'Wajib diisi untuk panti.'
            if not attrs.get('nomor_panti'):
                errors['nomor_panti'] = 'Wajib diisi untuk panti.'
        else:
            errors['role'] = 'Role tidak valid. Pilih masyarakat atau panti.'

        if errors:
            raise serializers.ValidationError(errors)

        return attrs

    def create(self, validated_data):
        # Hash password sebelum disimpan ke PendingRegistration
        validated_data['password'] = make_password(validated_data['password'])
        pending = PendingRegistration.objects.create(**validated_data)
        return pending

    def to_representation(self, instance):
        # Return pending_id dan email untuk dipakai Flutter
        return {
            'pending_id': str(instance.id),
            'email': instance.email,
        }