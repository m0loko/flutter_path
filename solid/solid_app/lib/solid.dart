// =============================================================================
// SOLID PRINCIPLES IN DART / FLUTTER
// =============================================================================

/*
  S - Single Responsibility Principle (Принцип единственной ответственности)
  -----------------------------------------------------------------------------
  ОПРЕДЕЛЕНИЕ:
  У класса должна быть только одна причина для изменения.
  Каждый класс должен иметь только одну зону ответственности.

  ПОЧЕМУ ЭТО ВАЖНО:
  1. Читаемость: Маленький класс легче понять.
  2. Тестируемость: Легче написать Unit-тест на одну функцию, чем на "God Object".
  3. Избежание конфликтов: Если два разработчика меняют разные аспекты (UI и Логику),
     они не будут мешать друг другу в одном файле.

  В КОНТЕКСТЕ FLUTTER:
  - Widget: Отвечает только за отображение UI.
  - Bloc/Provider: Отвечает только за управление состоянием (State Management).
  - Repository: Отвечает только за получение данных.
  - Model: Отвечает только за структуру данных (JSON parsing).

  РЕАЛЬНЫЙ КЕЙС:
  Частая ошибка во Flutter — "God Widget" или "God BLoC".
  Например, виджет экрана логина, который сам валидирует почту, сам стучится в API,
  сам парсит JSON и сам сохраняет токен в SharedPreferences.

  ПОЧЕМУ ЭТО ПЛОХО:
  Если изменится структура JSON от бэкенда, мы рискуем сломать верстку.
  Тестировать такой виджет невозможно без поднятия всего приложения.
*/

/* BAD:
- Смешанная ответственность: Виджет отвечает за отображение UI, обработку ввода, валидацию, сетевые запросы, парсинг JSON и локальное хранение.
- Сложность тестирования: Тестировать этот виджет сложно, так как для этого потребуется мокировать сетевые запросы, SharedPreferences 
и контекст Flutter.
- Сложность поддержки: Любое изменение в API, логике валидации или UI потребует изменения этого класса, что увеличивает риск внесения ошибок. */

/* GOOD:
- DTO (Data Transfer Object): AuthDto отвечает только за представление данных аутентификации.
- Repository: AuthRepository отвечает за получение данных (из сети, базы данных или локального хранилища) и их сохранение.
- UseCase: LoginUseCase содержит бизнес-логику (валидация, вызов репозитория).
- ViewModel/BLoC: LoginViewModel управляет состоянием UI и взаимодействует с LoginUseCase.
- Widget: LoginScreenGood отвечает только за отображение UI и передачу данных в LoginViewModel. */

// =============================================================================
// =============================================================================

/*
  O - Open/Closed Principle (Принцип открытости/закрытости)
  -----------------------------------------------------------------------------
  ОПРЕДЕЛЕНИЕ:
  Программные сущности (классы, модули, функции) должны быть:
  - ОТКРЫТЫ для расширения (мы можем добавлять новое поведение).
  - ЗАКРЫТЫ для изменения (мы не трогаем работающий старый код).

  КАК ДОСТИЧЬ В DART:
  1. Наследование и полиморфизм (переопределение методов).
  2. Использование абстрактных классов / интерфейсов.
  3. Extension Methods (Расширения) — позволяют добавить методы к чужому классу без наследования.

  АНТИ-ПАТТЕРН:
  Использование длинных конструкций `switch` или `if-else`, проверяющих тип объекта.
  Если появится новый тип, придется искать все `switch` в проекте и править их.

  РЕАЛЬНЫЙ КЕЙС:
  Система оплаты.
  Сначала у нас была только оплата картой. Потом бизнес попросил добавить Apple Pay.
  Потом Google Pay. Потом Крипту.

  Если мы используем `switch` или `if-else` в методе оплаты, нам придется каждый раз
  лезть в работающий код checkout-модуля, рискуя сломать оплату картой при добавлении крипты.
*/

// --- BAD EXAMPLE ---
class PaymentServiceBad {
  void processPayment(String type, double amount) {
    if (type == 'credit_card') {
      print('Processing Card: $amount');
    } else if (type == 'apple_pay') {
      print('Processing Apple Pay: $amount');
    } else {
      throw Exception('Unknown method');
    }
  }
}
// --- GOOD EXAMPLE (Strategy Pattern) ---

// Абстракция способа оплаты
abstract interface class PaymentStrategy {
  Future<void> pay(double amount);
}

// Конкретные реализации (мы можем добавлять новые файлы, не трогая старые)
class CreditCardPayment implements PaymentStrategy {
  @override
  Future<void> pay(double amount) async =>
      print('Paying $amount via Visa/MasterCard');
}

class ApplePayPayment implements PaymentStrategy {
  @override
  Future<void> pay(double amount) async =>
      print('Paying $amount via Apple Pay');
}

class CryptoPayment implements PaymentStrategy {
  @override
  Future<void> pay(double amount) async => print('Paying $amount via BTC');
}

// Сервис оплаты ничего не знает о типах. Он ЗАКРЫТ для изменения логики вызова,
// но ОТКРЫТ для добавления новых стратегий.
class PaymentServiceGood {
  Future<void> checkout(PaymentStrategy paymentMethod, double amount) async {
    // Логирование, аналитика и т.д.
    print('Starting transaction...');
    await paymentMethod.pay(amount);
    print('Transaction finished.');
  }
}

// =============================================================================

/*
  L - Liskov Substitution Principle (Принцип подстановки Барбары Лисков)
  -----------------------------------------------------------------------------
  ОПРЕДЕЛЕНИЕ:
  Объекты родительского класса должны быть заменяемы объектами его подклассов
  без нарушения корректности программы.

  ЧАСТЫЕ НАРУШЕНИЯ:
  1. Бросание исключений в методе, который у родителя безопасен (UnimplementedError).
  2. Усиление предусловий (родитель принимает любой int, а наследник только > 0).
  3. Ослабление постусловий (родитель гарантирует возврат объекта, а наследник может вернуть null).

  РЕАЛЬНЫЙ КЕЙС:
  Ошибки в проектировании UI компонентов или источников данных.
  Представьте, что у нас есть абстрактный `Storage`, который умеет читать и писать.
  Но мы решили сделать `ReadOnlyStorage` (например, конфигурацию с сервера), который наследуется от `Storage`.

  Если мы передадим `ReadOnlyStorage` туда, где ожидается обычный `Storage` и попытаемся записать,
  приложение упадет. Это нарушение контракта.
*/

// --- BAD EXAMPLE ---
abstract class LocalStorage {
  void save(String key, String value);
  String? read(String key);
}

class SharedPreferencesStorage extends LocalStorage {
  @override
  void save(String key, String value) => print('Saved to SP');
  @override
  String? read(String key) => 'value';
}

// Нарушение LSP: ConfigStorage не может выполнить контракт родителя (save).
class ServerConfigStorage extends LocalStorage {
  @override
  String? read(String key) => 'server_value';

  @override
  void save(String key, String value) {
    // БУМ! Нарушение принципа подстановки.
    // Код, который ожидал LocalStorage, упадет здесь.
    throw Exception('Cannot save to read-only storage!');
  }
}

// --- GOOD EXAMPLE ---
// Разделяем иерархию на уровне абстракций
abstract interface class ReadableStorage {
  String? read(String key);
}

abstract interface class WritableStorage implements ReadableStorage {
  void save(String key, String value);
}

class ServerConfig implements ReadableStorage {
  @override
  String? read(String key) => 'config';
}

class Database implements WritableStorage {
  @override
  String? read(String key) => 'data';
  @override
  void save(String key, String value) => print('Saved');
}

// =============================================================================

/*
  I - Interface Segregation Principle (Принцип разделения интерфейса)
  -----------------------------------------------------------------------------
  ОПРЕДЕЛЕНИЕ:
  Клиенты не должны зависеть от методов, которые они не используют.
  Лучше много маленьких специализированных интерфейсов, чем один "жирный" (God Interface).

  В DART:
  В Dart, благодаря ключевому слову implements, нарушение этого принципа может привести к тому,
  что класс будет вынужден реализовывать методы, которые ему не нужны. Это может привести 
  к "заглушкам" (пустым или нереализованным методам)

  РЕАЛЬНЫЙ КЕЙС:
  Аутентификация.
  Представим себе ситуацию с аутентификацией. Если у нас есть "толстый" интерфейс AuthService, 
  включающий методы login, logout, resetPassword, verifyPhoneNumber, и мы хотим добавить "Гостевой вход"
  (Anonymous Auth) или вход через Google, то возникнут проблемы. У Google аутентификации нет метода "Сбросить пароль"
  (это делается на стороне Google), а у Гостевого входа нет "Подтверждения телефона".
  Результат: множество пустых методов или UnimplementedError, что является признаком плохого дизайна.

  Ключевые моменты, которые стоит подчеркнуть:
Разбиение на интерфейсы: Акцент на разделении большой функциональности на отдельные интерфейсы.
Выборочная реализация: Классы реализуют только необходимые им интерфейсы.
Избежание ненужных методов: Подчеркивается, что это предотвращает реализацию ненужных методов и "заглушек".
Гибкость и модульность: Указывается на то, что такой подход делает систему более гибкой и простой в поддержке.
*/
// --- BAD EXAMPLE ---
abstract interface class FullAuthService {
  Future<void> login(String username, String password);
  Future<void> logout();
  Future<void> resetPassword(String email); // Не нужно для Google
  Future<void> verifyPhoneNumber(String phoneNumber); // Не нужно для Email
}

// --- GOOD EXAMPLE (Mixins or Composition) ---
// Базовые интерфейсы (Role Interfaces)
abstract interface class Authenticator {
  Future<void> authenticate();
  Future<void> logout();
}

abstract interface class EmailSignIn {
  Future<void> loginWithEmail(String email, String password);
}

abstract interface class GoogleSignIn {
  Future<void> signInWithGoogle();
}

abstract interface class PasswordReset {
  Future<void> resetPassword(String email);
}

abstract interface class PhoneVerification {
  Future<void> verifyPhoneNumber(String phoneNumber);
}

// Реализации: используем композицию вместо наследования интерфейсов

class EmailAuthService implements Authenticator, EmailSignIn, PasswordReset {
  @override
  Future<void> authenticate() async {
    print('Email authentication started');
    await loginWithEmail('test@example.com', 'password');
    print('Email authentication completed');
  }

  @override
  Future<void> logout() async {
    print('Email logout');
  }

  @override
  Future<void> loginWithEmail(String email, String password) async {
    print('Signing in with email: $email');
    // Тут логика входа с email
  }

  @override
  Future<void> resetPassword(String email) async {
    print('Resetting password for email: $email');
    // Тут логика сброса пароля
  }
}

class GoogleAuthService implements Authenticator, GoogleSignIn {
  @override
  Future<void> authenticate() async {
    print('Google authentication started');
    await signInWithGoogle();
    print('Google authentication completed');
  }

  @override
  Future<void> logout() async {
    print('Google logout');
  }

  @override
  Future<void> signInWithGoogle() async {
    print('Signing in with Google');
    // Тут логика входа с Google
  }
}

// Пример использования
void main() async {
  final emailAuth = EmailAuthService();
  await emailAuth.authenticate();
  await emailAuth.resetPassword('test@example.com');
  await emailAuth.logout();

  final googleAuth = GoogleAuthService();
  await googleAuth.authenticate();
  await googleAuth.logout();
}

// =============================================================================

/*
  D - Dependency Inversion Principle (Принцип инверсии зависимостей)
  -----------------------------------------------------------------------------
  ОПРЕДЕЛЕНИЕ:
  1. Модули верхнего уровня (бизнес-логика) не должны зависеть от модулей нижнего уровня (база данных, сеть).
     Оба должны зависеть от абстракций.
  2. Абстракции не должны зависеть от деталей. Детали должны зависеть от абстракций.

  ЗАЧЕМ:
  Чтобы мы могли легко поменять базу данных с SQL на Firebase, не переписывая весь код приложения.
  Чтобы мы могли тестировать логику, подменяя реальную сеть на тестовые данные (Mock).

  КАК РЕАЛИЗОВАТЬ:
  Использовать Dependency Injection (внедрение зависимостей) через конструктор.

  РЕАЛЬНЫЙ КЕЙС:
  Это фундамент Clean Architecture и тестирования.
  
  Представь, что твой `UserProfileBloc` напрямую создает экземпляр `Dio` (HTTP клиент).
  1. Ты не можешь протестировать Bloc без интернета.
  2. Если ты захочешь сменить Dio на GraphQL client, тебе придется переписывать Bloc.
  
  Модули высокого уровня (BLoC) не должны зависеть от деталей (Dio).
  Они должны зависеть от абстракций (Repository Interface).
*/

// --- BAD EXAMPLE ---
class UserBlocBad {
  // Жесткая зависимость от конкретной библиотеки
  final dio = DioClient();

  void loadUser() {
    dio.get('/user'); // Если Dio изменит API, мы должны править Bloc
  }
}

class DioClient {
  void get(String path) => print('GET $path via DIO');
}

// --- GOOD EXAMPLE ---

// 1. Абстракция (Контракт)
abstract interface class IApiClient {
  Future<dynamic> fetch(String path);
}

// 2. Реализация деталей (Infrastructure)
class DioService implements IApiClient {
  @override
  Future<dynamic> fetch(String path) async => print('Dio fetching $path');
}

class GraphQlService implements IApiClient {
  @override
  Future<dynamic> fetch(String path) async => print('GraphQL query to $path');
}

class MockApiService implements IApiClient {
  @override
  Future<dynamic> fetch(String path) async => {'name': 'Test User'};
}

// 3. Модуль верхнего уровня (Logic)
class UserBlocGood {
  // Зависимость от абстракции
  final IApiClient apiClient;

  // Dependency Injection через конструктор
  UserBlocGood(this.apiClient);

  void loadUser() async {
    final data = await apiClient.fetch('/user');
    print('User loaded: $data');
  }
}

void mainn() {
  // В Prod используем Dio
  final bloc = UserBlocGood(DioService());

  // В тестах используем Mock (DIP позволяет это сделать легко)
  final testBloc = UserBlocGood(MockApiService());
  testBloc.loadUser();
}

/* 
        Итоговая шпаргалка для "Senior-ответа" :
S (SRP): Не "одна ответственность", а "борьба с God-Objects и разделение слоев (UI, BLoC, Repo)".
O (OCP): Не "if/else", а "полиморфизм и стратегии". Добавляем фичи (ApplePay, Crypto), создавая новые файлы, а не меняя старые.
L (LSP): Не "наследник вместо родителя", а "соблюдение контракта". Если метод кидает UnimplementedError или ломает логику родителя — архитектура кривая.
I (ISP): "Нет жирным интерфейсам". В Dart это критично при implements, чтобы не писать заглушки.
D (DIP): "Зависимость от абстракций ради тестируемости и легкой подмены реализации (Mock vs Real)". 
*/
