from django.shortcuts import render

def index(request):
    return render(request, 'events/index.html')

def events(request):
    return render(request, 'events/events.html')



