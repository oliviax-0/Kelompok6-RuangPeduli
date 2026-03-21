from django.contrib import admin
from django.urls import path, include
from profiles.views import SocietyProfileViewSet, OrphanageProfileViewSet

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/', include('accounts.urls')),
    path('api/profiles/', include('profiles.urls')),
]