from django.shortcuts import render

# from smartTravel.events.models import Event, EventCategory
from events.models import Event, EventCategory


def index(request):
    context = {
        'title': 'SmartTravel',
    }
    return render(request, 'events/index.html', context)





def events(request):
    context = {
        'title': 'Events | SmartTravel',
        'events': Event.objects.all(),
        'categories': EventCategory.objects.all(),
    }

    return render(request, "events/events.html", context)
