from rest_framework.routers import DefaultRouter
from .views import SocietyProfileViewSet, OrphanageProfileViewSet

router = DefaultRouter()
router.register(r'masyarakat', SocietyProfileViewSet, basename='societyprofile')
router.register(r'panti', OrphanageProfileViewSet, basename='orphanageprofile')

urlpatterns = router.urls