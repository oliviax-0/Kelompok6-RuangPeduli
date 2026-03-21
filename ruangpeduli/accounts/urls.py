from django.urls import path
from .views import (
    RegisterStartView, VerifyOtpView, ResendOtpView, LoginView,
    ForgotPasswordRequestView, ForgotPasswordResetView,
    GoogleAuthView, GoogleRegisterView,
)

urlpatterns = [
    path('pending/',          RegisterStartView.as_view(),        name='register-start'),
    path('verify/',           VerifyOtpView.as_view(),            name='register-verify'),
    path('resend-otp/',       ResendOtpView.as_view(),            name='resend-otp'),
    path('login/',            LoginView.as_view(),                name='login'),
    path('forgot-password/',  ForgotPasswordRequestView.as_view(), name='forgot-password'),
    path('reset-password/',   ForgotPasswordResetView.as_view(),  name='reset-password'),
    path('google-auth/',      GoogleAuthView.as_view(),           name='google-auth'),
    path('google-register/',  GoogleRegisterView.as_view(),       name='google-register'),
]