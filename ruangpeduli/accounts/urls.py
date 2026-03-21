from django.urls import path
from .views import RegisterStartView, VerifyOtpView

urlpatterns = [
    path('pending/', RegisterStartView.as_view(), name='register-start'),
    path('verify/', VerifyOtpView.as_view(), name='register-verify'),
]