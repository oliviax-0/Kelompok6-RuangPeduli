from django.urls import path
from .views import RegisterStartView, VerifyOtpView, ResendOtpView, LoginView

urlpatterns = [
    path('pending/',    RegisterStartView.as_view(), name='register-start'),
    path('verify/',     VerifyOtpView.as_view(),     name='register-verify'),
    path('resend-otp/', ResendOtpView.as_view(),     name='resend-otp'),
    path('login/',      LoginView.as_view(),          name='login'),
]