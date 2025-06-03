import graphene
from feeds.models import Feed
from graphene_file_upload.scalars import Upload
from .types import FeedType  # Make sure FeedType is defined in types.py

class CreateFeed(graphene.Mutation):
    class Arguments:
        title = graphene.String(required=True)
        description = graphene.String(required=True)
        image = Upload(required=False)

    feed = graphene.Field(lambda: FeedType)

    def mutate(self, info, title, description, image=None):
        user = info.context.user
        if user.is_anonymous:
            raise Exception("Authentication required")
        feed = Feed.objects.create(user=user, title=title, description=description, image=image)
        return CreateFeed(feed=feed)
