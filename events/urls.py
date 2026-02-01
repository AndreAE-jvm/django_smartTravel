from django.urls import path
from events.views import events

app_name = 'events'


urlpatterns = [
    path('', events, name='index'),
]

# python -Xutf8 manage.py dumpdata events --indent=2 -o events.json   Bacap

#python manage.py loaddata events/fixtures/events.json
