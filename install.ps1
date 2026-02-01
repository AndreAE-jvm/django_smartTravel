# Установщик для Django PowerShell профиля
Write-Host "🚀 Установка Django PowerShell Profile" -ForegroundColor Yellow

# 1. Скачиваем профиль
$url = "https://raw.githubusercontent.com/user/django_smartTravel/main/Microsoft.PowerShell_profile.ps1"
$content = Invoke-RestMethod -Uri $url

# 2. Сохраняем в профиль
Set-Content -Path $PROFILE -Value $content -Encoding UTF8

# 3. Перезагружаем
. $PROFILE

Write-Host "✅ Профиль установлен! Введите 'djh' для справки" -ForegroundColor Green
