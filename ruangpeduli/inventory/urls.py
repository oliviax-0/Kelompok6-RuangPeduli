from django.urls import path
from .views import CategoryListView, CategoryDetailView, ItemListView, ItemDetailView

urlpatterns = [
    path('categories/',                          CategoryListView.as_view()),
    path('categories/<int:pk>/',                 CategoryDetailView.as_view()),
    path('categories/<int:cat_id>/items/',       ItemListView.as_view()),
    path('items/<int:pk>/',                      ItemDetailView.as_view()),
]
