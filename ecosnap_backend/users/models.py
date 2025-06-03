from django.contrib.auth.models import AbstractUser
from django.db import models
from django.core.validators import MinValueValidator, MaxValueValidator
from django.utils import timezone
from django.core.validators import RegexValidator

class AppUser(AbstractUser):
    email = models.EmailField(unique=True)
    eco_score = models.PositiveIntegerField(
        default=0,
        validators=[
            MinValueValidator(0),
            MaxValueValidator(1000)
        ]
    )

    REQUIRED_FIELDS = ['email']
    USERNAME_FIELD = 'username' 

    def __str__(self):
        return f"{self.username} ({self.email})"


class DeviceSession(models.Model):
    user = models.ForeignKey(AppUser, on_delete=models.CASCADE, related_name='device_sessions')
    device_info = models.CharField(max_length=255)
    
    token = models.CharField(
        max_length=255,
        unique=True,
        validators=[
            RegexValidator(
                regex=r'^[A-Za-z0-9\-_\.]+$',
                message='Token must be alphanumeric with dashes/underscores/dots'
            )
        ]
    )

    created_at = models.DateTimeField(auto_now_add=True)
    expiry_date = models.DateTimeField()

    class Meta:
        indexes = [
            models.Index(fields=['token']),  # Optimisé avec PostgreSQL
        ]

    def is_valid(self):
        return self.expiry_date > timezone.now()

    def __str__(self):
        return f"{self.user.username} — {self.device_info}"
