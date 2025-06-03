from django.urls import path
from .views import FeedListCreateView, FeedDetailView

urlpatterns = [
    path('', FeedListCreateView.as_view(), name='feed-list'),
    path('<int:pk>/', FeedDetailView.as_view(), name='feed-detail'),
]
