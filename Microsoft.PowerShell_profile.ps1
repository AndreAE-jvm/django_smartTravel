Set-Location "C:\IT\Python\django_project\smartTravel"

Set-Alias c Clear-Host

function django { python manage.py @args }
function djr { python manage.py runserver @args }
function djm { python manage.py migrate @args }
function djmm { python manage.py makemigrations @args }
function djsu { python manage.py createsuperuser }
function dev { python manage.py runserver 127.0.0.1:8000 @args }

function djm-all {
    Write-Host "====== Django Migrations ======" -ForegroundColor Yellow
    Write-Host "Step 1: makemigrations" -ForegroundColor Green
    python manage.py makemigrations @args
    Write-Host "`nStep 2: migrate" -ForegroundColor Green
    python manage.py migrate @args
    Write-Host "`nMigration process completed!" -ForegroundColor Yellow
}

Set-Alias mm djm-all

function djtest {
    python manage.py test
}

function nd {
    param(
        [string]$name = $(Read-Host "Project name")
    )
    
    Write-Host "Создание Django проекта: $name" -ForegroundColor Cyan
    django-admin startproject $name
    cd $name
    Write-Host "✅ Проект создан. Запустите:" -ForegroundColor Green
    Write-Host "djr" -ForegroundColor Cyan
	"или"
    Write-Host "dev" -ForegroundColor Cyan
}

function nda {
    param(
        [string]$name = $(Read-Host "App name")
    )
    
    Write-Host "Создание Django приложения: $name" -ForegroundColor Cyan
    python manage.py startapp $name
    Write-Host "✅ Приложение '$name' создано" -ForegroundColor Green
    Write-Host "Добавьте '$name' в INSTALLED_APPS в settings.py" -ForegroundColor Yellow
}

# Работа с фикстурами
function djdump {
    python -Xutf8 manage.py dumpdata events --indent=2 -o events/fixtures/events.json
    Write-Host "✅ Экспорт завершен" -ForegroundColor Green
}

function djload {
    python manage.py loaddata events/fixtures/events.json
    Write-Host "✅ Импорт завершен" -ForegroundColor Green
}


# Очистка всех данных из базы данных (без удаления самой БД)
function djflush {
    Write-Host "🧹 Очистка ВСЕХ данных из базы данных..." -ForegroundColor Yellow
    Write-Host "ℹ️  Удалит все записи из всех таблиц, но сохранит структуру БД" -ForegroundColor Gray
    
    $confirm = Read-Host "Продолжить? Все данные будут удалены! (y/n)"
    if ($confirm -eq 'y') {
        python manage.py flush --noinput
        Write-Host "✅ Все данные очищены, структура БД сохранена" -ForegroundColor Green
        Write-Host "📝 Таблицы пусты, но готовы к использованию" -ForegroundColor Cyan
    } else {
        Write-Host "❌ Отменено" -ForegroundColor Red
    }
}

function djclear-events {
    Write-Host "🗑️  Удаление всех событий и категорий..." -ForegroundColor Yellow
    
    python manage.py shell -c "
from events.models import Event, EventCategory

try:
    # Получаем количество до удаления
    count_events = Event.objects.count()
    count_categories = EventCategory.objects.count()
    
    # Удаляем все записи
    Event.objects.all().delete()
    EventCategory.objects.all().delete()
    
    print(f'✅ Удалено: {count_events} событий, {count_categories} категорий')
    
except Exception as e:
    print(f'❌ Ошибка: {e}')
    print('Проверьте:')
    print('1. Существует ли приложение events')
    print('2. Существуют ли модели Event и EventCategory')
    print('3. Находитесь ли вы в директории проекта Django')
"
}

function djrecreate-db {
    # Удаляем старую БД (если есть)
    if (Test-Path "db.sqlite3") {
        Remove-Item "db.sqlite3" -Force
        Write-Host "🗑️  Старая БД удалена" -ForegroundColor Green
    } else {
        Write-Host "ℹ️  Файл БД не найден, создаем новую" -ForegroundColor Yellow
    }
    
    # ОБЯЗАТЕЛЬНО создаем новую БД через миграции
    Write-Host "📦 Создание новой БД (migrate)..." -ForegroundColor Cyan
    python manage.py migrate
    
    Write-Host "✅ Новая БД создана!" -ForegroundColor Green
    Write-Host "   📁 Файл: db.sqlite3" -ForegroundColor White
    Write-Host "   🗃️  Таблицы созданы" -ForegroundColor White
    Write-Host "   🚀 Готово к работе!" -ForegroundColor White
}

function djmigrate-reset {
    Write-Host "🔄 Сброс миграций для events..." -ForegroundColor Yellow
    
    # Удаляем файлы миграций
    Remove-Item "events/migrations/0*.py" -ErrorAction SilentlyContinue
    
    # Создаем и применяем миграции
    python manage.py makemigrations events
    python manage.py migrate events
    
    Write-Host "✅ Миграции events сброшены" -ForegroundColor Green
}

## Редактировать и синхронизировать
function es {
    notepad $PROFILE
    Copy-Item $PROFILE "C:\IT\Python\django_project\smartTravel\Microsoft.PowerShell_profile.ps1" -Force
    . $PROFILE
    Write-Host "✅ Синхронизировано" -ForegroundColor Green
}

# Редактировать и отправить на GitHub
function ep {
    notepad $PROFILE
    Copy-Item $PROFILE "C:\IT\Python\django_project\smartTravel\Microsoft.PowerShell_profile.ps1" -Force
    . $PROFILE
    
    cd C:\IT\Python\django_project\smartTravel
    
    # только файл профиля
    git add Microsoft.PowerShell_profile.ps1
    
    git commit -m "Update profile $(Get-Date -Format 'HH:mm')"
    git push
    
    Write-Host "✅ Отправлено на GitHub!" -ForegroundColor Green
}


function djh {
    Write-Host "📋 DJANGO КОМАНДЫ:" -ForegroundColor Yellow
    
    # Сервер
    Write-Host "`n🌐 Сервер:" -ForegroundColor Cyan
    Write-Host "  djr    - Запустить сервер" -ForegroundColor Green
    Write-Host "  dev    - Сервер на 127.0.0.1:8000" -ForegroundColor Green
    Write-Host "  django - Любая manage.py команда" -ForegroundColor Green
    
    # База данных
    Write-Host "`n🗃️  База данных:" -ForegroundColor Cyan
    Write-Host "  djmm   - Создать миграции" -ForegroundColor Green
    Write-Host "  djm    - Применить миграции" -ForegroundColor Green
    Write-Host "  mm     - Создать + применить" -ForegroundColor Green    
    Write-Host "  djsu   - Суперпользователь" -ForegroundColor Green
    Write-Host "  djrecreate-db - Удалить и создать новую БД (Радикальное решение, миграции нужно применять, админка удаляется)" -ForegroundColor DarkRed
    Write-Host "  djflush - Очистить все данные (без удаления БД, предпочтительно делать эту команду, миграции не нужно применять, админка удаляется)" -ForegroundColor DarkRed
    Write-Host "  djclear-events - Удалить только события и категории, админка остается" -ForegroundColor DarkRed    
    Write-Host "  djmigrate-reset - Сбросить миграции для events" -ForegroundColor DarkRed
    
    # Данные
    Write-Host "`n💾 Данные:" -ForegroundColor Cyan
    Write-Host "  djdump - Экспорт в JSON" -ForegroundColor Green
    Write-Host "  djload - Импорт из JSON" -ForegroundColor Green
    
    # Проект
    Write-Host "`n📁 Проект:" -ForegroundColor Cyan
    Write-Host "  nd     - Новый проект" -ForegroundColor Green
    Write-Host "  nda    - Новое приложение" -ForegroundColor Green
    
    Write-Host ""  # Пустая строка    
    # Управление профилем
    Write-Host "====== Profile Management ======" -ForegroundColor Yellow
    
    # 1. Информация о командах
    Write-Host "notepad `$PROFILE  - Open profile in notepad" -ForegroundColor Cyan
    Write-Host ". `$PROFILE        - Reload profile" -ForegroundColor Cyan
    Write-Host "es                 - Редактировать и синхронизировать, из локального в профиль проекта" -ForegroundColor Cyan
    Write-Host "ep                 - Редактировать и отправить на GitHub" -ForegroundColor Cyan
    Write-Host "djh                - Show this help" -ForegroundColor Cyan
    Write-Host "Tab key            - Auto-completion" -ForegroundColor Cyan
    Write-Host "  c                - Clear terminal" -ForegroundColor Cyan
    Write-Host "pip install django - # Установите Django (последняя версия)" -ForegroundColor Cyan
    Write-Host "pip install django==5.2 - # Или установите конкретную версию" -ForegroundColor Cyan
    Write-Host "python -m django --version - # Проверьте, что Django установлен" -ForegroundColor Cyan


    Write-Host ""  # Пустая строка
    
    # 2. Примеры использования
    Write-Host ""
    Write-Host "═══════════ Примеры использования ═══════════" -ForegroundColor DarkGreen  
   
   
    
    Write-Host "  🔵 nd myproject" -ForegroundColor Cyan -NoNewline
    Write-Host '      → создать новый проект "myproject"' -ForegroundColor Green
    
    Write-Host "  🔵 nda users" -ForegroundColor Cyan -NoNewline
    Write-Host '         → создать новое приложение "users"' -ForegroundColor Green

    Write-Host "  🔵 djdump" -ForegroundColor Cyan -NoNewline
    Write-Host '           → экспортировать все данные events в JSON' -ForegroundColor Green
    
    Write-Host "  🔵 djload" -ForegroundColor Cyan -NoNewline
    Write-Host '           → загрузить данные из фикстур' -ForegroundColor Green
    
  }  

Write-Host "✅ Django команды загружены! Используйте: djh" -ForegroundColor Green