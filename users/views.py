from django.contrib import auth, messages
from django.shortcuts import render, HttpResponseRedirect
from users.forms import UserLoginForm, UserRegisterForm, UserProfileForm
from django.urls import reverse
from django.contrib.auth.decorators import login_required # неавторизованные пользователи не могут зайти (перенаправление на войти)



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
                auth.login(request, user)
                return HttpResponseRedirect(reverse('index'))
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


@login_required(login_url='/users/login/')
def profile(request):
    if request.method == 'POST':
        form = UserProfileForm(request.POST, instance=request.user, files=request.FILES)
        if form.is_valid():
            form.save()
            messages.success(request, 'Данные успешно обновлены!')
            return HttpResponseRedirect(reverse('users:profile'))
        else:
            messages.error(request, 'Пожалуйста, исправьте ошибки в форме')
    else:
        form = UserProfileForm(instance=request.user)

    # Получаем корзину пользователя (нужно создать модель Cart)
    # from cart.models import Cart
    # cart_items = Cart.objects.filter(user=request.user)
    # cart_total = sum(item.total for item in cart_items)

    # Получаем заказы пользователя (нужно создать модель Order)
    # from events.models import Order
    # orders = Order.objects.filter(user=request.user).order_by('-created_at')
    # orders_count = orders.count()

    # Временные заглушки
    cart_items = []
    cart_total = 0
    orders = []
    orders_count = 0

    context = {
        'form': form,
        'title': 'Мой профиль',
        'cart_items': cart_items,
        'cart_total': cart_total,
        'orders': orders,
        'orders_count': orders_count,
    }
    return render(request, 'users/profile.html', context)
