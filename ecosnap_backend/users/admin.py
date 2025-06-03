from django.contrib import admin
from .models import AppUser, DeviceSession

admin.site.register(AppUser)
admin.site.register(DeviceSession)