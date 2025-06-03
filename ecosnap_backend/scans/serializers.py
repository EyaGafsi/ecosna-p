from rest_framework import serializers
from .models import Scan, Device

class ScanSerializer(serializers.ModelSerializer):
    class Meta:
        model = Scan
        fields = ['id', 'image', 'result', 'category', 'is_recyclable', 'created_at']
        read_only_fields = ['result', 'created_at', 'category', 'is_recyclable']
class DeviceSerializer(serializers.ModelSerializer):
    class Meta:
        model = Device
        fields = ['fcm_token']