from rest_framework import generics, permissions
from .models import Feed
from .serializers import FeedSerializer

class FeedListCreateView(generics.ListCreateAPIView):
    queryset = Feed.objects.all().order_by('-created_at')
    serializer_class = FeedSerializer
    permission_classes = [permissions.IsAuthenticated]

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)

class FeedDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Feed.objects.all()
    serializer_class = FeedSerializer
    permission_classes = [permissions.IsAuthenticated]
