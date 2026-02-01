from django.db import models

# Create your models here.
class EventCategory(models.Model):
    name = models.CharField(max_length=256)
    description = models.TextField(blank=True)

    def __str__(self):
        return self.name

class Event(models.Model):
    name = models.CharField(max_length=256)
    image = models.ImageField(upload_to='events/')
    description = models.TextField(blank=True)
    short_description = models.TextField(max_length=64,blank=True)
    price = models.DecimalField(max_digits=8, decimal_places=2)
    max_participants = models.PositiveIntegerField(default=15) # Максимальное количество участников #
    category = models.ForeignKey(EventCategory, on_delete=models.PROTECT) #CASCADE = Удалил категорию → удалились ВСЕ её события (ОПАСНО!);
    # PROTECT = Не даст удалить категорию, пока есть её события (БЕЗОПАСНО!) #
    location = models.CharField(max_length=200, blank=True)
    start_datetime = models.DateTimeField(blank=True, null=True)
    end_datetime = models.DateTimeField(blank=True, null=True)

    @property
    def duration(self):
        if self.start_datetime and self.end_datetime:
            duration = self.end_datetime - self.start_datetime

            # Получаем дни, часы и минуты
            days = duration.days
            total_hours = duration.seconds // 3600
            minutes = (duration.seconds % 3600) // 60

            # Форматируем вывод
            parts = []
            if days > 0:
                if days == 1:
                    parts.append(f"{days} день")
                elif days in [2, 3, 4]:
                    parts.append(f"{days} дня")
                else:
                    parts.append(f"{days} дней")

            if total_hours > 0:
                parts.append(f"{total_hours} ч")

            if minutes > 0:
                parts.append(f"{minutes} мин")

            if parts:
                return " ".join(parts)
            else:
                return "Менее минуты"

        return "Не указано"

    def __str__(self):
        return f'{self.name} | {self.category.name}'



