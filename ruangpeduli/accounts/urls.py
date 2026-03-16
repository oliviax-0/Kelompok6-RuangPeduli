from django.urls import path
from .views import SocietyRegisterView, SocietyUpdateView, SocietyViewSet

urlpatterns = [
    # Root of /api/society/ → list & create societies
    path('', SocietyViewSet.as_view({'get': 'list', 'post': 'create'}), name='society-list'),
    path('<int:pk>/', SocietyViewSet.as_view({
        'get': 'retrieve',
        'put': 'update',
        'patch': 'partial_update',
        'delete': 'destroy',
    }), name='society-detail'),

    path('register/', SocietyRegisterView.as_view(), name='society-register'),
    path('', SocietyViewSet.as_view({'get': 'list'}), name='society-list'),
    path('/<int:pk>/', SocietyViewSet.as_view({'get': 'retrieve'}), name='society-detail'),
    path('/<int:pk>/', SocietyUpdateView.as_view(), name='society-update'),
    path('/<int:pk>/', SocietyViewSet.as_view({'delete': 'destroy'}), name='society-delete'),
]