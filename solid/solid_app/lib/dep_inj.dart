// =============================================================================
// DEPENDENCY INJECTION & IoC IN DART/FLUTTER
// =============================================================================

/*
  1. INVERSION OF CONTROL (IoC) - Инверсия управления
  -----------------------------------------------------------------------------
  ОПРЕДЕЛЕНИЕ:
  Это общий ПРИНЦИП проектирования.
  Традиционное программирование: "Мой код вызывает библиотеку".
  IoC: "Фреймворк/Библиотека вызывает мой код". (Don't call us, we'll call you).

  КТО РЕАЛИЗУЕТ IoC:
  1. Dependency Injection (DI) - инверсия создания зависимостей.
  2. Фреймворки (Flutter) - инверсия потока управления.
     Мы не вызываем main() -> build(). Flutter сам решает, когда вызвать build().

  SENIOR POINT:
  IoC — это "Родительский концепт". DI — это лишь один из способов реализации IoC.
*/

// --- Пример IoC во Flutter (Control Flow) ---
import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  // IoC: Мы не вызываем build(). Flutter Framework вызывает его,
  // когда посчитает нужным (при перерисовке, маунте и т.д.).
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

// =============================================================================

/*
  2. DEPENDENCY INJECTION (DI) - Внедрение зависимостей
  -----------------------------------------------------------------------------
  ОПРЕДЕЛЕНИЕ:
  Паттерн, при котором объекты получают свои зависимости извне,
  а не создают их сами внутри себя.

  ВИДЫ DI:
  1. Constructor Injection (Самый популярный во Flutter).
  2. Method Injection (Передача в метод).
  3. Property/Setter Injection (Редко используется во Flutter из-за immutability).

  ГЛАВНАЯ ЦЕЛЬ:
  Разделить "Конструирование" (Creation) и "Использование" (Usage).
*/

// --- WITHOUT DI (TIGHT COUPLING) ---
class CarBad {
  late Engine _engine;

  CarBad() {
    // ПЛОХО: Машина сама решает, какой двигатель создать.
    // Мы не можем подсунуть сюда тестовый двигатель или электрический.
    _engine = V8Engine();
  }

  void drive() => _engine.start();
}

// --- WITH DI (LOOSE COUPLING) ---
class CarGood {
  final Engine _engine;

  // ХОРОШО: Машине всё равно, какой это двигатель, лишь бы он был Engine.
  // Зависимость "внедряется" через конструктор.
  CarGood(this._engine);

  void drive() => _engine.start();
}

abstract class Engine {
  void start();
}

class V8Engine implements Engine {
  @override
  void start() => print('Vroom V8');
}

class MockEngine implements Engine {
  @override
  void start() => print('Silent test start');
}

// =============================================================================

/*
  3. FACTORY METHOD vs FACTORY CLASS
  -----------------------------------------------------------------------------
  ОПРЕДЕЛЕНИЕ:
  Порождающий паттерн. Метод или класс, отвечающий за создание объектов.

  ОТЛИЧИЕ ОТ DI:
  Фабрика — это про то "КАК создать".
  DI — это про то "КАК доставить" созданное внутрь объекта.

  Часто Фабрики используются ВНУТРИ DI контейнеров для настройки создания.
*/

// Простая фабрика
class EngineFactory {
  static Engine createEngine(String type) {
    if (type == 'sport') return V8Engine();
    return MockEngine();
  }
}

void useFactory() {
  // Мы всё еще запрашиваем создание явно, но логика выбора скрыта
  final engine = EngineFactory.createEngine('sport');
  final car = CarGood(engine);
}

// =============================================================================

/*
  4. SERVICE LOCATOR (Локатор служб)
  -----------------------------------------------------------------------------
  ОПРЕДЕЛЕНИЕ:
  Паттерн, где есть центральный реестр (Registry), и объекты САМИ просят
  у него зависимости. "Эй, Локатор, дай мне сервис API".
  
  Пример во Flutter: package `get_it`.

  ОТЛИЧИЕ ОТ DI:
  - DI (Push): Зависимости "вталкиваются" в класс (через конструктор). Класс пассивен.
  - Service Locator (Pull): Класс сам "вытягивает" зависимости. Класс активен.

  ПОЧЕМУ ЭТО СЧИТАЕТСЯ АНТИ-ПАТТЕРНОМ (иногда):
  1. Скрытые зависимости. Глядя на конструктор `UserViewModel()`, вы не знаете,
     что внутри он лезет в глобальный `GetIt` за `Database`.
  2. Сложнее тестировать (нужно не забыть настроить глобальный локатор перед тестом).
*/

// --- SERVICE LOCATOR EXAMPLE ---

// Глобальный реестр (упрощенно)
class ServiceLocator {
  static final Map<Type, dynamic> _services = {};

  static void register<T>(T service) => _services[T] = service;
  static T get<T>() => _services[T] as T;
}

class UserViewModelWithLocator {
  // Конструктор пустой - зависимости не видны!
  UserViewModelWithLocator() {
    // PULL approach: "Я сам достану то, что мне нужно"
    final api = ServiceLocator.get<ApiClient>();
    api.fetch();
  }
}

// =============================================================================

/*
  5. IoC CONTAINER (DI CONTAINER)
  -----------------------------------------------------------------------------
  ОПРЕДЕЛЕНИЕ:
  Фреймворк или библиотека, которая автоматизирует процесс DI.
  Вы регистрируете типы, а контейнер сам смотрит на конструкторы классов,
  понимает, что им нужно, создает это и внедряет (Auto-wiring).

  Примеры: 
  - Java: Spring, Dagger.
  - Flutter: `injectable` (надстройка над GetIt), `Riverpod` (функциональный DI).

  КАК ЭТО РАБОТАЕТ (Псевдокод):
  1. Вы говорите: "Я хочу Car".
  2. Контейнер видит: Ага, конструктор Car(Engine).
  3. Контейнер ищет, как создать Engine.
  4. Создает Engine -> Создает Car(engine) -> Отдает вам Car.
*/

// Пример с Injectable (Code generation approach)

/*
@injectable
class UserRepository { ... }

@injectable
class UserBloc {
  final UserRepository repo;
  // Контейнер сам найдет repo и положит сюда
  UserBloc(this.repo); 
}
*/

class ApiClient {
  void fetch() {}
}

void main() {
  // 1. Manual DI (Pure Dependency Injection)
  // Мы (разработчики) выступаем в роли DI контейнера, собирая матрешку вручную.
  // Это лучший способ для небольших приложений (Pure DI).
  final api = ApiClient();
  final car = CarGood(V8Engine());

  // 2. Service Locator (GetIt style)
  ServiceLocator.register<ApiClient>(ApiClient());
  final vm = UserViewModelWithLocator(); // Внутри скрытый вызов локатора
}
