from django.shortcuts import render

# Create your views here.
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status, permissions
from django.contrib.auth import authenticate
from .serializers import RegisterSerializer, LoginSerializer, AppUserSerializer, DeviceSessionSerializer
from .models import AppUser, DeviceSession
from rest_framework_simplejwt.tokens import RefreshToken
from django.utils import timezone

class RegisterView(APIView):
    def post(self, request):
        serializer = RegisterSerializer(data=request.data)
        if serializer.is_valid():
            user = serializer.save()
            return Response(AppUserSerializer(user).data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class LoginView(APIView):
    def post(self, request):
        serializer = LoginSerializer(data=request.data)
        if serializer.is_valid():
            user = authenticate(
                username=serializer.validated_data['username'],
                password=serializer.validated_data['password']
            )
            if user:
                refresh = RefreshToken.for_user(user)
                session = DeviceSession.objects.create(
                    user=user,
                    device_info=request.headers.get('User-Agent', 'unknown'),
                    token=str(refresh.access_token),
                    expiry_date=timezone.now() + refresh.access_token.lifetime
                )
                return Response({
                    'access': str(refresh.access_token),
                    'refresh': str(refresh),
                    'user': AppUserSerializer(user).data
                })
        return Response({'error': 'Invalid credentials'}, status=status.HTTP_401_UNAUTHORIZED)

class ProfileView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request):
        return Response(AppUserSerializer(request.user).data)
