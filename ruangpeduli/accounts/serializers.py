from rest_framework import serializers
from .models import Society
from django.contrib.auth.hashers import make_password

class SocietySerializer(serializers.ModelSerializer):

    class Meta:
        model = Society
        fields = [
            "id",
            "username",
            "email",
            "sandi",
            "alamat",
            "nama_pengguna"
        ]
        extra_kwargs = {
            "sandi": {"write_only": True}
        }

    def create(self, validated_data):
        validated_data["sandi"] = make_password(validated_data["sandi"])
        return super().create(validated_data)