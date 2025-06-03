import graphene
from graphene_django.types import DjangoObjectType
from feeds.models import Feed

class FeedType(DjangoObjectType):
    likes_count = graphene.Int()

    class Meta:
        model = Feed
        fields = ('id', 'title', 'description', 'image', 'created_at', 'user')

    def resolve_likes_count(self, info):
        return self.likes.count()
