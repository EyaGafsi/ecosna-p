import graphene
from .types import FeedType
from feeds.models import Feed

class FeedQuery(graphene.ObjectType):
    all_feeds = graphene.List(FeedType)

    def resolve_all_feeds(self, info):
        return Feed.objects.all().order_by('-created_at')
