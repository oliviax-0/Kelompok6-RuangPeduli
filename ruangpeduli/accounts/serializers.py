from rest_framework import serializers
from accounts.models import PendingRegistration, User
from profiles.models import SocietyProfile, OrphanageProfile
import http

class RegisterWithProfileSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)
    nama_pengguna = serializers.CharField(required=False, allow_blank=True)
    alamat = serializers.CharField(required=False, allow_blank=True)
    nama_panti = serializers.CharField(required=False, allow_blank=True)
    alamat_panti = serializers.CharField(required=False, allow_blank=True)
    nomor_panti = serializers.CharField(required=False, allow_blank=True)

    class Meta:
        model = User
        fields = [
            'id','email', 'password', 'role',
            'nama_pengguna', 'alamat','username',
            'nama_panti', 'alamat_panti', 'nomor_panti','username',
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
            errors['role'] = 'Role tidak valid.'
        if errors:
            raise serializers.ValidationError(errors)
        return attrs

    def create(self, validated_data):
        password = validated_data.pop('password')
        role = validated_data.get('role')

        nama_pengguna = validated_data.pop('nama_pengguna', None)
        alamat = validated_data.pop('alamat', None)
        nama_panti = validated_data.pop('nama_panti', None)
        alamat_panti = validated_data.pop('alamat_panti', None)
        nomor_panti = validated_data.pop('nomor_panti', None)

        user = User(**validated_data)
        user.set_password(password)
        user.save()

        if role == 'masyarakat':
            SocietyProfile.objects.create(
                username=user.username,
                nama_pengguna=nama_pengguna,
                alamat=alamat,
            )
        elif role == 'panti':
            OrphanageProfile.objects.create(
                username=user.username,
                nama_panti=nama_panti,
                alamat_panti=alamat_panti,
                nomor_panti=nomor_panti,
            )
        return user

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

    def create(self, validated_data):
        # Hapus create_with_otp, langsung create biasa
        pending = PendingRegistration.objects.create(**validated_data)
        return pending

    def to_representation(self, instance):
        return {
            'pending_id': instance.id,
            'email': instance.email,
        }