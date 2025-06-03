from django.db import models
from users.models import AppUser

class Feed(models.Model):
    user = models.ForeignKey(AppUser, on_delete=models.CASCADE, related_name="feeds")
    title = models.CharField(max_length=255)
    description = models.TextField()
    image = models.ImageField(upload_to='feed_images/', blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    likes = models.ManyToManyField(AppUser, related_name='liked_feeds', blank=True)

    def __str__(self):
        return self.title
