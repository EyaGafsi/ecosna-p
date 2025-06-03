from graphene_django.views import GraphQLView
from rest_framework_simplejwt.authentication import JWTAuthentication
from django.utils.decorators import method_decorator
from django.views.decorators.csrf import csrf_exempt

class CustomGraphQLView(GraphQLView):
    @method_decorator(csrf_exempt)
    def dispatch(self, request, *args, **kwargs):
        user = JWTAuthentication().authenticate(request)
        if user is not None:
            request.user = user[0]
        return super().dispatch(request, *args, **kwargs)
