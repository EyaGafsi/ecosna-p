import graphene
from graphene_django.types import DjangoObjectType
from graphql import GraphQLError
from scans.models import Scan

class ScanType(DjangoObjectType):
    class Meta:
        model = Scan
        fields = ("id", "user", "image", "result", "category", "is_recyclable", "created_at")

class Query(graphene.ObjectType):
    all_scans = graphene.List(ScanType)

    def resolve_all_scans(self, info):
        user = info.context.user
        if user.is_anonymous:
            raise GraphQLError("Authentication required")
        return Scan.objects.filter(user=user)

class CreateScan(graphene.Mutation):
    class Arguments:
        image = graphene.String(required=True)  
        result = graphene.String(required=False)
        category = graphene.String(required=False)
        is_recyclable = graphene.Boolean(required=False)

    scan = graphene.Field(ScanType)

    def mutate(self, info, image, result=None, category=None, is_recyclable=None):
        user = info.context.user
        if user.is_anonymous:
            raise GraphQLError("Authentication required")

        scan = Scan.objects.create(
            user=user,
            image=image,
            result=result,
            category=category,
            is_recyclable=is_recyclable
        )
        return CreateScan(scan=scan)

class Mutation(graphene.ObjectType):
    create_scan = CreateScan.Field()

schema = graphene.Schema(query=Query, mutation=Mutation)