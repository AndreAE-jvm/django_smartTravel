from django.contrib import auth, messages
from django.shortcuts import render, HttpResponseRedirect
from users.forms import UserLoginForm, UserRegisterForm
from django.urls import reverse




def login(request):
    if request.method == 'POST':
        form = UserLoginForm(data=request.POST)
        if form.is_valid():
            # username = request.POST['username']
            # password = request.POST['password']
            username = form.cleaned_data['username']  # Берем из очищенных данных
            password = form.cleaned_data['password']
            user = auth.authenticate(username=username, password=password)
            if user and user.is_active:
                auth.login(request,user)
                return  HttpResponseRedirect(reverse('index'))
    else:
        form = UserLoginForm()

    context = {'form': form}
    return render(request, 'users/login.html', context)

def register(request):
    if request.method == 'POST':
        form = UserRegisterForm(data=request.POST)
        if form.is_valid():
            form.save()
            messages.success(request, 'Регистрация прошла успешно! Теперь Вы можете войти.')
            return HttpResponseRedirect(reverse('users:login'))
        else:
            print(form.errors)
    else:
        form = UserRegisterForm()

    context = {
        'form': form
    }

    return render(request, 'users/register.html', context)

def logout(request):
    auth.logout(request)
    messages.success(request, 'Вы успешно вышли из системы. Возвращайтесь снова!')
    return HttpResponseRedirect(reverse('index'))


def profile(request):
    """Страница профиля пользователя"""
    context = {
        'title': 'Мой профиль',
        'user': request.user,
    }
    return render(request, 'users/profile.html', context)