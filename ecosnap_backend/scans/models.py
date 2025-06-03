from django.db import models
from django.contrib.auth import get_user_model

class Scan(models.Model):
    user = models.ForeignKey(get_user_model(), on_delete=models.CASCADE)
    image = models.ImageField(upload_to='uploads/')
    result = models.TextField(blank=True, null=True)  
    category = models.CharField(max_length=50, null=True, blank=True)  
    is_recyclable = models.BooleanField(null=True, blank=True) 
    created_at = models.DateTimeField(auto_now_add=True)
class Device(models.Model):
    user = models.ForeignKey(get_user_model(), on_delete=models.CASCADE)
    fcm_token = models.CharField(max_length=255)
    created_at = models.DateTimeField(auto_now_add=True)