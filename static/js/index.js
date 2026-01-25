// Основные функции Smart Travel

// Функция для приветствия по времени суток
function updateTimeGreeting() {
    const hour = new Date().getHours();
    const greetingEl = document.getElementById('timeGreeting');
    if (!greetingEl) return;

    let greeting;
    let icon;

    if (hour < 6) {
        greeting = "Доброй ночи в Smart Travel!";
        icon = "🌙";
    } else if (hour < 12) {
        greeting = "Доброе утро в Smart Travel!";
        icon = "☀️";
    } else if (hour < 18) {
        greeting = "Добрый день в Smart Travel!";
        icon = "👋";
    } else {
        greeting = "Добрый вечер в Smart Travel!";
        icon = "🌆";
    }

    greetingEl.textContent = `${greeting} ${icon}`;
}

// Открытие каталога
function openCatalog() {
    alert("Каталог экскурсий в разработке");
    // В будущем: window.location.href = "catalog.html";
}

// Подписка на рассылку
function subscribeNewsletter() {
    const emailInput = document.getElementById('newsletterEmail');
    const email = emailInput.value.trim();

    if (email && email.includes('@')) {
        alert(`Спасибо за подписку! Проверьте ${email}`);
        emailInput.value = '';
        emailInput.classList.add('is-valid');
        setTimeout(() => emailInput.classList.remove('is-valid'), 2000);
    } else {
        emailInput.classList.add('is-invalid');
        setTimeout(() => emailInput.classList.remove('is-invalid'), 2000);
    }
}

// Показать модальное окно бонуса
function showBonusModal() {
    const modal = new bootstrap.Modal(document.getElementById('bonusModal'));
    modal.show();
}

// Получить бонус
function claimBonus() {
    alert("Бонус отправлен на ваш email!");
    const modal = bootstrap.Modal.getInstance(document.getElementById('bonusModal'));
    modal.hide();
}

// Плавная прокрутка
function initSmoothScroll() {
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function(e) {
            e.preventDefault();
            const targetId = this.getAttribute('href');
            if (targetId === '#') return;

            const target = document.querySelector(targetId);
            if (target) {
                const navbarHeight = document.querySelector('.navbar').offsetHeight;
                window.scrollTo({
                    top: target.offsetTop - navbarHeight - 20,
                    behavior: 'smooth'
                });
            }
        });
    });
}

// Инициализация при загрузке
document.addEventListener('DOMContentLoaded', function() {
    updateTimeGreeting();
    initSmoothScroll();

    // Обновлять приветствие каждые 10 минут
    setInterval(updateTimeGreeting, 600000);

    // Изменение навигации при скролле
    const navbar = document.querySelector('.navbar');
    window.addEventListener('scroll', () => {
        if (window.scrollY > 50) {
            navbar.classList.add('bg-white', 'shadow-sm');
        } else {
            navbar.classList.remove('bg-white', 'shadow-sm');
        }
    });
});

// Экспорт функций
window.openCatalog = openCatalog;
window.subscribeNewsletter = subscribeNewsletter;
window.showBonusModal = showBonusModal;
window.claimBonus = claimBonus;