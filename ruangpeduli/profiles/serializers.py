from rest_framework import serializers
from .models import SocietyProfile, OrphanageProfile, PantiMedia


class SocietyProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = SocietyProfile
        fields = '__all__'


class PantiMediaSerializer(serializers.ModelSerializer):
    class Meta:
        model = PantiMedia
        fields = ['id', 'media_type', 'file', 'video_url', 'order', 'created_at']
        read_only_fields = ['created_at']


class OrphanageProfileSerializer(serializers.ModelSerializer):
    username = serializers.CharField(source='user.username', required=False)
    email = serializers.EmailField(source='user.email', required=False)
    password = serializers.CharField(write_only=True, required=False, allow_blank=True)

    class Meta:
        model = OrphanageProfile
        fields = [
            'id', 'username', 'email', 'nama_panti', 'alamat_panti',
            'nomor_panti', 'profile_picture', 'description', 'password',
        ]
        extra_kwargs = {
            'nama_panti': {'required': False},
            'alamat_panti': {'required': False},
            'nomor_panti': {'required': False},
            'profile_picture': {'required': False},
        }

    def update(self, instance, validated_data):
        user_data = validated_data.pop('user', {})
        password = validated_data.pop('password', None)

        for attr, value in validated_data.items():
            setattr(instance, attr, value)
        instance.save()

        user = instance.user
        if 'username' in user_data:
            user.username = user_data['username']
        if 'email' in user_data:
            user.email = user_data['email']
        if password:
            user.set_password(password)
        user.save()

        return instance
