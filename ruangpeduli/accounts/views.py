from rest_framework import generics, permissions, status
from rest_framework.response import Response
from rest_framework.views import APIView
from django.utils import timezone
from datetime import timedelta
from django.conf import settings
from django.core.mail import send_mail
import random
import string
import resend
from django.db import transaction, IntegrityError
from accounts.models import User, PendingRegistration
from .serializers import RegisterStartSerializer

OTP_HTML = """
    <div style="font-family: Arial, sans-serif; max-width: 420px;
                margin: auto; padding: 24px;">
        <h2 style="color: #F43D5E; margin-bottom: 4px;">RuangPeduli</h2>
        <p style="color: #555; margin-bottom: 24px;">
            Halo! Berikut kode OTP untuk verifikasi akun kamu:
        </p>
        <div style="font-size: 38px; font-weight: bold;
                    letter-spacing: 10px; color: #F43D5E;
                    text-align: center; padding: 20px 0;
                    background: #FFF0F2;
                    border-radius: 10px; margin-bottom: 20px;">
            {otp}
        </div>
        <p style="color: #888; font-size: 13px; line-height: 1.6;">
            Kode ini berlaku selama <b>10 menit</b>.<br>
            Jangan bagikan kode ini kepada siapapun.
        </p>
        <hr style="border: none; border-top: 1px solid #eee; margin: 20px 0;">
        <p style="color: #bbb; font-size: 11px;">
            Jika kamu tidak merasa mendaftar di RuangPeduli, abaikan email ini.
        </p>
    </div>
"""


def _send_via_resend(email: str, otp: str) -> bool:
    resend.api_key = settings.RESEND_API_KEY
    try:
        resend.Emails.send({
            "from": settings.DEFAULT_FROM_EMAIL,
            "to": [email],
            "subject": "Kode OTP RuangPeduli",
            "html": OTP_HTML.format(otp=otp),
        })
        print(f"✅ Email terkirim via Resend ke {email}")
        return True
    except Exception as e:
        print(f"⚠️ Resend error: {e}")
        return False


def _send_via_gmail(email: str, otp: str) -> bool:
    try:
        send_mail(
            subject="Kode OTP RuangPeduli",
            message=f"Kode OTP kamu: {otp}\nBerlaku selama 10 menit.",
            from_email=f"RuangPeduli <{settings.EMAIL_HOST_USER}>",
            recipient_list=[email],
            fail_silently=False,
            html_message=OTP_HTML.format(otp=otp),
        )
        print(f"✅ Email terkirim via Gmail SMTP ke {email}")
        return True
    except Exception as e:
        print(f"⚠️ Gmail SMTP error: {e}")
        return False


def _send_otp_email(email: str, otp: str) -> bool:
    """
    Coba Resend dulu, kalau gagal fallback ke Gmail SMTP.
    Return True kalau salah satu berhasil.
    """
    if _send_via_resend(email, otp):
        return True
    print("⚠️ Resend gagal, mencoba Gmail SMTP sebagai fallback...")
    return _send_via_gmail(email, otp)

class RegisterStartView(generics.CreateAPIView):
    queryset = PendingRegistration.objects.all()
    serializer_class = RegisterStartSerializer
    permission_classes = [permissions.AllowAny]

    def create(self, request, *args, **kwargs):
        email = request.data.get('email')
        username = request.data.get('username')

        # ✅ Cek email sudah terdaftar di User
        if User.objects.filter(email=email).exists():
            return Response(
                {'error': 'Email sudah terdaftar, silakan login'},
                status=status.HTTP_400_BAD_REQUEST
            )

        # ✅ Cek username sudah dipakai
        if User.objects.filter(username=username).exists():
            return Response(
                {'error': 'Username sudah digunakan'},
                status=status.HTTP_400_BAD_REQUEST
            )

        # Lanjut proses normal
        return super().create(request, *args, **kwargs)

    def perform_create(self, serializer):
        # Hapus pending lama dengan email yang sama
        PendingRegistration.objects.filter(
            email=serializer.validated_data['email']
        ).delete()

        pending = serializer.save()

        otp = ''.join(random.choices(string.digits, k=5))
        pending.otp_code = otp
        pending.expires_at = timezone.now() + timedelta(minutes=10)
        pending.save()

        print(f"{'='*40}")
        print(f"📧 Email  : {pending.email}")
        print(f"🔑 OTP    : {otp}")
        print(f"⏰ Expires: {pending.expires_at}")
        print(f"🆔 ID     : {pending.id}")
        print(f"{'='*40}")

        sent = _send_otp_email(pending.email, otp)
        if sent:
            print(f"✅ Email OTP berhasil dikirim ke {pending.email}")
        else:
            print(f"⚠️ Email gagal, gunakan OTP dari log: {otp}")

class VerifyOtpView(APIView):
    permission_classes = [permissions.AllowAny]

    def post(self, request, *args, **kwargs):
        pending_id = request.data.get('pending_id')
        otp = request.data.get('otp')

        if not pending_id or not otp:
            return Response(
                {'error': 'pending_id dan otp wajib diisi'},
                status=status.HTTP_400_BAD_REQUEST
            )

        try:
            pending = PendingRegistration.objects.get(id=pending_id)
        except PendingRegistration.DoesNotExist:
            return Response(
                {'error': 'Sesi registrasi tidak ditemukan, silakan daftar ulang'},
                status=status.HTTP_404_NOT_FOUND
            )

        # ❌ OTP expired → hapus pending
        if pending.expires_at is None or timezone.now() > pending.expires_at:
            pending.delete()  # ← HAPUS
            return Response(
                {'error': 'OTP sudah expired, silakan daftar ulang'},
                status=status.HTTP_400_BAD_REQUEST
            )

        # ❌ OTP salah → hapus pending
        if pending.otp_code != otp:
            pending.delete()  # ← HAPUS
            return Response(
                {'error': 'OTP salah, silakan daftar ulang'},
                status=status.HTTP_400_BAD_REQUEST
            )

        # ✅ OTP benar → buat user
        try:
            with transaction.atomic():
                user = User.objects.create(
                    username=pending.username,
                    email=pending.email,
                    password=pending.password,
                    role=pending.role,
                )

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

                pending.delete()  # ← hapus pending setelah berhasil
                print(f"✅ User {user.username} berhasil dibuat!")

        except IntegrityError:
            pending.delete()  # ← hapus pending kalau duplikat
            return Response(
                {'error': 'Username atau email sudah digunakan, silakan daftar ulang'},
                status=status.HTTP_400_BAD_REQUEST
            )
        except Exception as e:
            pending.delete()  # ← hapus pending kalau error lain
            return Response(
                {'error': f'Terjadi kesalahan: {str(e)}'},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )

        return Response(
            {
                'success': True,
                'message': 'Registrasi berhasil! Silakan login.',
                'user_id': user.id,
                'username': user.username,
            },
            status=status.HTTP_201_CREATED
        )
    
class ResendOtpView(APIView):
    """
    POST /api/resend-otp/
    Kirim ulang OTP ke email yang sama.
    """
    permission_classes = [permissions.AllowAny]

    def post(self, request, *args, **kwargs):
        email = request.data.get('email')

        if not email:
            return Response(
                {'error': 'Email wajib diisi'},
                status=status.HTTP_400_BAD_REQUEST
            )

        try:
            pending = PendingRegistration.objects.get(email=email)
        except PendingRegistration.DoesNotExist:
            return Response(
                {'error': 'Email tidak ditemukan'},
                status=status.HTTP_404_NOT_FOUND
            )

        # Generate OTP baru
        otp = ''.join(random.choices(string.digits, k=5))
        pending.otp_code = otp
        pending.expires_at = timezone.now() + timedelta(minutes=10)
        pending.save()

        print(f"🔄 Resend OTP ke {email}: {otp}")

        sent = _send_otp_email(email, otp)
        if not sent:
            return Response(
                {'error': 'Gagal mengirim email, coba lagi'},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )

        return Response(
            {'message': 'OTP baru telah dikirim ke email kamu'},
            status=status.HTTP_200_OK
        )