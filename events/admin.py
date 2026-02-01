from django.contrib import admin

# Register your models here.

from events.models import Event, EventCategory

admin.site.register(Event)
admin.site.register(EventCategory)
