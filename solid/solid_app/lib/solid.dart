// =============================================================================
// SOLID PRINCIPLES IN DART / FLUTTER
// =============================================================================

/*
  S - Single Responsibility Principle (Принцип единственной ответственности)
  -----------------------------------------------------------------------------
  ОПРЕДЕЛЕНИЕ:
  У класса должна быть только одна причина для изменения.
  Класс должен отвечать только за одну часть функциональности программы.

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

/*  1    -----------------------------------------  1*/
// --- BAD EXAMPLE (Смешана UI, Логика и Данные) ---
class LoginScreenBad {
  void onLoginPressed(String email, String password) async {
    // 1. Валидация (UI logic)
    if (!email.contains('@')) {
      print('Show snackbar: Invalid email');
      return;
    }

    // 2. HTTP клиент (Infrastructure)
    // var response = await http.post('.../login', body: {...});

    // 3. Парсинг (Data parsing)
    // var token = jsonDecode(response.body)['token'];

    // 4. Кеширование (Local Storage)
    // SharedPreferences.getInstance().then((prefs) => prefs.setString('token', token));

    print('Navigate to Home');
  }
}
// --- GOOD EXAMPLE (Clean Architecture) ---

// 1. DTO (Data Transfer Object) - отвечает только за парсинг
class AuthDto {
  final String token;
  AuthDto(this.token);
  factory AuthDto.fromJson(Map<String, dynamic> json) => AuthDto(json['token']);
}

// 2. Repository - отвечает за данные (откуда брать и куда сохранять)
abstract interface class IAuthRepository {
  Future<void> login(String email, String password);
}

// 3. UseCase (Domain) - чистая бизнес-логика (валидация + вызов репозитория)
class LoginUseCase {
  final IAuthRepository repository;
  LoginUseCase(this.repository);

  Future<void> execute(String email, String password) async {
    if (!email.contains('@')) throw Exception('Invalid Email');
    await repository.login(email, password);
  }
}

// 4. BLoC/ViewModel - управление состоянием UI
// Он ничего не знает про HTTP или JSON, он просто вызывает UseCase.

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

  ПРОСТЫМИ СЛОВАМИ:
  Наследник не должен ломать ожидания, которые задал родитель.

  ЧАСТЫЕ НАРУШЕНИЯ:
  1. Бросание исключений в методе, который у родителя безопасен (UnimplementedError).
  2. Усиление предусловий (родитель принимает любой int, а наследник только > 0).
  3. Ослабление постусловий (родитель гарантирует возврат объекта, а наследник может вернуть null).

  РЕАЛЬНЫЙ КЕЙС:
  Ошибки в проектировании UI компонентов или источников данных.
  Представьте, что у нас есть абстрактный `Storage`, который умеет читать и писать.
  Но мы решили сделать `ReadOnlyStorage` (например, конфиг с сервера), который наследуется от `Storage`.

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
  Так как в Dart есть `implements`, если вы реализуете "жирный" интерфейс,
  вам придется переопределять кучу ненужных методов, ставя там "заглушки".

  РЕАЛЬНЫЙ КЕЙС:
  Аутентификация.
  У нас есть "жирный" интерфейс `AuthService`, где есть `login`, `logout`, `resetPassword`, `verifyPhoneNumber`.
  
  Мы добавляем "Гостевой вход" (Anonymous Auth) или вход через Google.
  У Гугла нет метода "Сбросить пароль" (это делается на стороне Гугла).
  У Гостя нет "Подтверждения телефона".
  
  Результат: куча пустых методов или UnimplementedError.
*/
// --- BAD EXAMPLE ---
abstract interface class FullAuthService {
  Future<void> signInWithEmail();
  Future<void> signInWithGoogle();
  Future<void> resetPassword(); // Не нужно для Google
  Future<void> verifyPhone(); // Не нужно для Email
}

// --- GOOD EXAMPLE (Mixins or Composition) ---

// Базовые интерфейсы (Role Interfaces)
abstract interface class SignInEmail {
  Future<void> signInEmail(String email, String pass);
}

abstract interface class SignInGoogle {
  Future<void> signInGoogle();
}

abstract interface class PasswordManager {
  Future<void> resetPassword(String email);
}

// Реализация для обычной почты
class EmailAuthProvider implements SignInEmail, PasswordManager {
  @override
  Future<void> signInEmail(String email, String pass) async =>
      print('Email login');

  @override
  Future<void> resetPassword(String email) async => print('Reset pass sent');
}

// Реализация для Гугла (ему не нужно реализовывать сброс пароля)
class GoogleAuthProvider implements SignInGoogle {
  @override
  Future<void> signInGoogle() async => print('Google Login');
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

void main() {
  // В Prod используем Dio
  final bloc = UserBlocGood(DioService());

  // В тестах используем Mock (DIP позволяет это сделать легко)
  final testBloc = UserBlocGood(MockApiService());
  testBloc.loadUser();
}






/* 
        Итоговая шпаргалка для "Senior-ответа" (дополни этот список):
S (SRP): Не "одна ответственность", а "борьба с God-Objects и разделение слоев (UI, BLoC, Repo)".
O (OCP): Не "if/else", а "полиморфизм и стратегии". Добавляем фичи (ApplePay, Crypto), создавая новые файлы, а не меняя старые.
L (LSP): Не "наследник вместо родителя", а "соблюдение контракта". Если метод кидает UnimplementedError или ломает логику родителя — архитектура кривая.
I (ISP): "Нет жирным интерфейсам". В Dart это критично при implements, чтобы не писать заглушки.
D (DIP): "Зависимость от абстракций ради тестируемости и легкой подмены реализации (Mock vs Real)". 
*/
