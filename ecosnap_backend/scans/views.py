from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.parsers import MultiPartParser
from rest_framework.permissions import IsAuthenticated
from .tasks import run_blip_caption
import os
from django.conf import settings
from django.core.files.storage import default_storage
from django.core.files.base import ContentFile
import uuid
from .models import Scan, Device
from .serializers import ScanSerializer, DeviceSerializer

class ScanView(APIView):
    parser_classes = [MultiPartParser]
    permission_classes = [IsAuthenticated]

    def post(self, request):
        if 'image' not in request.FILES:
            return Response({'error': 'Aucune image fournie.'}, status=400)

        image_file = request.FILES['image']

        scan = Scan.objects.create(user=request.user, image=image_file)

        from .tasks import process_scan
        task = process_scan.delay(scan.id)

        return Response({
            'message': 'Scan en cours de traitement.',
            'task_id': task.id,
            'scan_id': scan.id 
        })
    def get(self, request):
        print(type(request.user))  
        scans = Scan.objects.filter(user=request.user).order_by('-created_at')
        serializer = ScanSerializer(scans, many=True)
        return Response(serializer.data)
  

def save_image(uploaded_file):
    upload_dir = "uploads"
    os.makedirs(os.path.join(settings.MEDIA_ROOT, upload_dir), exist_ok=True)

    filename = f"{uuid.uuid4().hex}_{uploaded_file.name}"
    relative_path = os.path.join(upload_dir, filename)

    path = default_storage.save(relative_path, ContentFile(uploaded_file.read()))

    return os.path.join(settings.MEDIA_ROOT, path)

class MyScansView(APIView):
    permission_classes = [IsAuthenticated]
    def get(self, request, pk):
        try:
            scan = Scan.objects.get(pk=pk, user=request.user)
            serializer = ScanSerializer(scan)
            return Response(serializer.data)
        except Scan.DoesNotExist:
            return Response({'error': 'Scan non trouvé'}, status=404)
class RegisterDeviceView(APIView):
    permission_classes = [IsAuthenticated]
    def post(self, request):
        serializer = DeviceSerializer(data=request.data)
        if serializer.is_valid():
            Device.objects.update_or_create(
                user=request.user,
                defaults={'fcm_token': serializer.validated_data['fcm_token']}
            )
            return Response({'status': 'token saved'})
        return Response(serializer.errors, status=400)
    def get(self, request):
        devices = Device.objects.filter(user=request.user)
        serializer = DeviceSerializer(devices, many=True)
        return Response(serializer.data)