from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static
from profiles.views import SocietyProfileViewSet, OrphanageProfileViewSet

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/', include('accounts.urls')),
    path('api/profiles/', include('profiles.urls')),
    path('api/content/',  include('content.urls')),
] + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)