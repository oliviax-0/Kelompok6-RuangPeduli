from django.urls import path
from .views import KebutuhanListView, KebutuhanDetailView

urlpatterns = [
    path('',       KebutuhanListView.as_view()),
    path('<int:pk>/', KebutuhanDetailView.as_view()),
]
