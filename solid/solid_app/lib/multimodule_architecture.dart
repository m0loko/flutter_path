import 'package:flutter/material.dart';

// =============================================================================
// MULTI-MODULE ARCHITECTURE IN FLUTTER (MONOREPO)
// =============================================================================

/*
  1. ЗАЧЕМ НУЖНА МНОГОМОДУЛЬНОСТЬ? (WHY IS IT NECESSARY?)
  -----------------------------------------------------------------------------
  Проблема монолита (обычного проекта):
  1. Спагетти-код: Очень легко импортировать файл из папки `Login` в папку `Cart`,
     создавая неявные связи.
  2. Долгая сборка (Build Time): Особенно если используются кодогенераторы
     (Freezed, JSON Serializable). При изменении одной запятой `build_runner`
     может пересобирать всё.
  3. Конфликты слияния (Merge Conflicts): Когда 10 человек правят одни и те же файлы.
  4. Переиспользование: Нельзя просто взять кусок кода и вставить в другое приложение.

  РЕШЕНИЕ (Многомодульность):
  Разбиваем приложение на независимые Dart-пакеты (packages).

  ПРЕИМУЩЕСТВА:
  1. Strict Boundaries (Строгие границы): Нельзя использовать класс из другого модуля,
     пока не добавишь его явно в `pubspec.yaml`. Это дисциплинирует архитектуру.
  2. Faster CI/CD & Build: Если я поменял модуль "Профиль", мне нужно прогнать тесты
     только для него, а не для всего приложения.
  3. Ownership: Команда А отвечает за пакет `feature_login`, Команда Б за `feature_dashboard`.
  
  TOOLING:
  В Flutter стандартом для управления многомодульностью является утилита **Melos**.
*/

// =============================================================================
// 2. КАК ОРГАНИЗОВАТЬ (PROJECT STRUCTURE)
// =============================================================================

/*
  Типичная структура папок в корне проекта:
  
  /apps
    /my_app          <- "Тонкий" клиент. Собирает всё вместе.
  
  /packages
    /core            <- Горизонтальные модули (нужны всем)
      /ui_kit        (Кнопки, Цвета, Шрифты)
      /network       (Dio, Interceptors)
      /analytics     (Интерфейсы аналитики)
      /domain        (Базовые сущности, ошибки)
      
    /features        <- Вертикальные модули (Бизнес-фичи)
      /auth          (Login, Register, Forgot Password)
      /cart          (Корзина, Чекаут)
      /profile       (Просмотр профиля, Настройки)
*/

// =============================================================================
// 3. КОММУНИКАЦИЯ МЕЖДУ ФИЧАМИ (FEATURE COMMUNICATION)
// =============================================================================

/*
  ГЛАВНЫЙ ВОПРОС: Должны ли фичи знать друг о друге?
  ОТВЕТ: НЕТ! Прямая зависимость `feature_cart` -> `feature_product` ЗАПРЕЩЕНА.
  
  ПОЧЕМУ?
  1. Circular Dependency (Циклическая зависимость):
     Товар ссылается на Корзину ("Купить"), Корзина ссылается на Товар (список).
     Сборщик Dart упадет с ошибкой.
  2. Tight Coupling: Нельзя протестировать Корзину без Товаров.

  КАК РЕШАТЬ (Навигация и Данные):
  Использовать паттерн "Dependency Inversion" через Core модуль или API-пакеты.
*/

// --- CODE EXAMPLE: NAVIGATION BETWEEN MODULES ---

// ПРЕДСТАВИМ, ЧТО МЫ В МОДУЛЕ: packages/core/navigation
// Здесь лежат абстракции.

abstract interface class AppRouter {
  void navigateToHome();
  void navigateToProductDetails(String productId);
  void navigateToCart();
}

// -----------------------------------------------------------

// ПРЕДСТАВИМ, ЧТО МЫ В МОДУЛЕ: packages/features/home_feed
// Этот модуль НЕ знает про модуль ProductDetails. Он знает только про AppRouter.

class HomeFeedScreen {
  final AppRouter router; // Зависимость от интерфейса

  HomeFeedScreen(this.router);

  void onProductClicked(String id) {
    print('User clicked product $id');
    // Мы просим роутер перейти, не зная, какой виджет там откроется.
    router.navigateToProductDetails(id);
  }
}

// -----------------------------------------------------------

// ПРЕДСТАВИМ, ЧТО МЫ В МОДУЛЕ: apps/my_app (Application Layer)
// Это единственное место, которое знает про ВСЕ модули.
// Здесь мы связываем реализацию.


// Фейковые импорты для примера
class ProductDetailsScreen extends StatelessWidget { 
  final String id; 
  ProductDetailsScreen(this.id);
  @override Widget build(BuildContext context) => Placeholder(); 
}

// Реализация Роутера живет в главном приложении (или отдельном модуле навигации)
class RealAppRouter implements AppRouter {
  final GlobalKey<NavigatorState> navigatorKey;

  RealAppRouter(this.navigatorKey);

  @override
  void navigateToHome() {
    // navigatorKey.currentState?.pushNamed('/home');
  }

  @override
  void navigateToProductDetails(String productId) {
    // Внимание: Главное приложение знает про виджет ProductDetailsScreen,
    // потому что оно импортирует feature_product_details.
    navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (_) => ProductDetailsScreen(productId)),
    );
  }

  @override
  void navigateToCart() {
    // navigatorKey.currentState?.pushNamed('/cart');
  }
}

// =============================================================================
// 4. DEPENDENCY INJECTION IN MULTI-MODULE
// =============================================================================

/*
  Как передать зависимости?
  Обычно каждая фича имеет свой "Entry Point" или DI-модуль.
*/

// MODULE: packages/features/auth

class AuthModuleDI {
  // Метод, который главное приложение вызовет при старте, 
  // чтобы зарегистрировать зависимости модуля Auth.
  static void initDependencies(GetIt sl) {
    sl.registerLazySingleton(() => AuthRepository());
    sl.registerFactory(() => AuthBloc(sl()));
  }
}

// Фейковые классы для компиляции примера
class GetIt {
  void registerLazySingleton(Function f) {}
  void registerFactory(Function f) {}
  dynamic call() => null;
}
class AuthRepository {}
class AuthBloc { AuthBloc(dynamic x); }