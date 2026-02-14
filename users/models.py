from django.contrib.auth.models import AbstractUser
from django.db import models

class User(AbstractUser):
    image = models.ImageField(upload_to='users_images', blank=True)
    phone = models.CharField(max_length=20, blank=True, null=True)
