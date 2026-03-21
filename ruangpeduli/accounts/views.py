from rest_framework import generics, permissions, status
from rest_framework.response import Response
from rest_framework.views import APIView
from django.utils import timezone
from django.core.mail import send_mail
import random
import string

from accounts.models import User, PendingRegistration
from .serializers import RegisterStartSerializer, RegisterWithProfileSerializer

class RegisterWithProfileView(generics.CreateAPIView):
    queryset = User.objects.all()
    serializer_class = RegisterWithProfileSerializer
    permission_classes = [permissions.AllowAny]

class RegisterStartView(generics.CreateAPIView):
    """
    Terima data register, simpan sementara di PendingRegistration, generate & kirim OTP.
    """
    queryset = PendingRegistration.objects.all()
    serializer_class = RegisterStartSerializer
    permission_classes = [permissions.AllowAny]

    def perform_create(self, serializer):
        pending = serializer.save()
        
        # Generate OTP 5 digit
        otp = ''.join(random.choices(string.digits, k=5))
        pending.otp_code = otp
        pending.expires_at = timezone.now() + timezone.timedelta(minutes=10)
        pending.save()
        
        # Kirim OTP ke email (atau print untuk testing)
        try:
            send_mail(
                'Kode OTP Ruang Peduli',
                f'Kode OTP Anda: {otp}\nBerlaku selama 10 menit.',
                'noreply@ruangpeduli.com',
                [pending.email],
                fail_silently=False,
            )
            print(f"✓ Email terkirim ke {pending.email}")
        except Exception as e:
            print(f"⚠️ Email gagal: {e}")
            print(f"📌 OTP untuk testing: {otp}")

class VerifyOtpView(APIView):
    permission_classes = [permissions.AllowAny]

    def post(self, request, *args, **kwargs):
        pending_id = request.data.get('pending_id')
        otp = request.data.get('otp')
        
        try:
            pending = PendingRegistration.objects.get(id=pending_id)
        except PendingRegistration.DoesNotExist:
            return Response(
                {'error': 'Pending registration not found'},
                status=status.HTTP_404_NOT_FOUND
            )
        
        # Cek OTP valid
        if pending.otp_code != otp:
            return Response(
                {'error': 'OTP salah'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        # Cek OTP expired
        if timezone.now() > pending.expires_at:
            return Response(
                {'error': 'OTP sudah expired'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        # OTP valid, buat user baru
        user = User.objects.create_user(
            username=pending.username,
            email=pending.email,
            password=pending.password,
            role=pending.role,
        )
        
        # Simpan profile data sesuai role
        if pending.role == 'masyarakat':
            from profiles.models import SocietyProfile
            SocietyProfile.objects.create(
                user=user,
                nama_pengguna=pending.nama_pengguna,
                alamat=pending.alamat,
            )
        elif pending.role == 'panti':
            from profiles.models import OrphanageProfile
            OrphanageProfile.objects.create(
                user=user,
                nama_panti=pending.nama_panti,
                alamat_panti=pending.alamat_panti,
                nomor_panti=pending.nomor_panti,
            )
        
        # Hapus pending registration
        pending.delete()
        
        return Response(
            {
                'success': True,
                'message': 'Registrasi berhasil',
                'user_id': user.id,
                'username': user.username
            },
            status=status.HTTP_201_CREATED
        )