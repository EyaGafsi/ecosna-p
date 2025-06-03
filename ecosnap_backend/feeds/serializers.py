from rest_framework import serializers
from .models import Feed

class FeedSerializer(serializers.ModelSerializer):
    user = serializers.StringRelatedField(read_only=True)
    likes_count = serializers.SerializerMethodField()

    class Meta:
        model = Feed
        fields = ['id', 'user', 'title', 'description', 'image', 'created_at', 'likes_count']

    def get_likes_count(self, obj):
        return obj.likes.count()
