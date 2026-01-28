import 'package:flutter/material.dart';
// =============================================================================
// OOP PRINCIPLES IN DART / FLUTTER (REAL WORLD GUIDE)
// =============================================================================

/*
  1. ENCAPSULATION (Инкапсуляция)
  -----------------------------------------------------------------------------
  ОПРЕДЕЛЕНИЕ:
  Сокрытие внутреннего состояния объекта и защита его от прямого изменения извне.
  Мы предоставляем публичные методы (API) для взаимодействия с данными.

  ОСОБЕННОСТИ DART:
  - В Dart НЕТ ключевых слов `private`, `protected`, `public`.
  - Приватность определяется нижним подчеркиванием `_` перед именем.
  - ВАЖНО: Приватность работает на уровне БИБЛИОТЕКИ (ФАЙЛА), а не класса.
    Если два класса в одном файле, они видят приватные поля друг друга.

  ЗАЧЕМ ЭТО НУЖНО (SENIOR POINT):
  Не просто "скрыть данные", а защитить ИНВАРИАНТЫ (правила).
  Например, баланс не может быть отрицательным, возраст не может быть > 150.
  Сеттеры позволяют валидировать входные данные.
*/

// --- BAD EXAMPLE ---
class BankAccountBad {
  // Поле публичное. Любой может написать account.balance = -1000000;
  // И сломать логику приложения.
  double balance;

  BankAccountBad(this.balance);
}

// --- GOOD EXAMPLE ---
class BankAccountGood {
  // 1. Скрываем поле (Library private)
  double _balance;

  BankAccountGood(double initialBalance) : _balance = initialBalance;

  // 2. Предоставляем геттер (только чтение)
  double get balance => _balance;

  // 3. Управляем изменением через методы с валидацией
  void deposit(double amount) {
    if (amount <= 0) throw Exception('Сумма должна быть положительной');
    _balance += amount;
  }

  void withdraw(double amount) {
    if (amount > _balance) throw Exception('Недостаточно средств');
    _balance -= amount;
  }
}

// =============================================================================

/*
  2. INHERITANCE (Наследование)
  -----------------------------------------------------------------------------
  ОПРЕДЕЛЕНИЕ:
  Механизм, позволяющий создавать новые классы на основе существующих,
  перенимая их свойства и методы. (Отношение "IS-A" - "Является").

  ОСОБЕННОСТИ DART:
  - Одиночное наследование (`extends`). У класса может быть только один родитель.
  - Все классы неявно наследуются от `Object`.
  - Если нужно "множественное наследование", используются Mixins (`with`).

  FLUTTER КОНТЕКСТ:
  Мы постоянно наследуемся от `StatelessWidget` или `StatefulWidget`.
  Метод `build()` мы переопределяем, но вся логика обновления экрана (lifecycle)
  спрятана в родительских классах.

  SENIOR WARNING:
  "Favor Composition over Inheritance" (Предпочитайте композицию наследованию).
  Глубокие иерархии наследования (5-6 уровней) делают код жестким и хрупким.
*/

// --- BAD EXAMPLE (Deep Hierarchy) ---
class View {}

class Button extends View {}

class ColoredButton extends Button {}

class RoundColoredButton extends ColoredButton {} // Это ад для поддержки

// --- GOOD EXAMPLE ---
// Используем наследование для общей логики сущностей
abstract class BaseEntity {
  final String id;
  final DateTime createdAt;

  BaseEntity(this.id) : createdAt = DateTime.now();
}

class User extends BaseEntity {
  final String name;
  // User наследует id и createdAt
  User(String id, this.name) : super(id);
}

// Пример во Flutter (правильное использование):
// Мы создаем CustomButton, который ЯВЛЯЕТСЯ StatelessWidget.
// Но внутри мы используем КОМПОЗИЦИЮ (собираем кнопку из Container, Text, InkWell).

// =============================================================================

/*
  3. POLYMORPHISM (Полиморфизм)
  -----------------------------------------------------------------------------
  ОПРЕДЕЛЕНИЕ:
  Способность объектов с одинаковой спецификацией (интерфейсом) иметь
  различную реализацию. "Один интерфейс — много форм".

  ВИДЫ В DART:
  1. Переопределение методов (`@override`) - Runtime polymorphism.
  2. Параметрический полиморфизм (Generics `List<T>`).

  FLUTTER КОНТЕКСТ:
  Метод `build(BuildContext context)`. Фреймворк вызывает `build` у любого виджета.
  Ему не важно, это `Text` или `Row`, он знает, что у них есть метод `build`.
  Это и есть полиморфизм.
*/

// --- REAL WORLD EXAMPLE: Analytics ---

// Абстрактный контракт события
abstract interface class AnalyticsEvent {
  String get name;
  Map<String, dynamic> get parameters;
}

// Конкретная реализация 1: Клик по кнопке
class ButtonClickEvent implements AnalyticsEvent {
  final String buttonId;
  ButtonClickEvent(this.buttonId);

  @override
  String get name => 'button_click';

  @override
  Map<String, dynamic> get parameters => {'button_id': buttonId};
}

// Конкретная реализация 2: Просмотр экрана
class ScreenViewEvent implements AnalyticsEvent {
  final String screenName;
  ScreenViewEvent(this.screenName);

  @override
  String get name => 'screen_view';

  @override
  Map<String, dynamic> get parameters => {'screen_name': screenName};
}

// Сервис аналитики работает ПОЛИМОРФНО.
// Он принимает любой AnalyticsEvent, не зная заранее, что это будет.
class AnalyticsService {
  void logEvent(AnalyticsEvent event) {
    print('Sending event: ${event.name} with params: ${event.parameters}');
  }
}

void testPolymorphism() {
  final service = AnalyticsService();
  // Мы передаем разные объекты, но метод работает корректно
  service.logEvent(ButtonClickEvent('login_btn'));
  service.logEvent(ScreenViewEvent('Home'));
}

// =============================================================================

/*
  4. ABSTRACTION (Абстракция)
  -----------------------------------------------------------------------------
  ОПРЕДЕЛЕНИЕ:
  Выделение значимых характеристик объекта и игнорирование деталей реализации.
  Мы взаимодействуем с "идеей" объекта, а не с его "кишками".

  ОСОБЕННОСТИ DART 3:
  - `abstract class`: Нельзя создать экземпляр, можно иметь методы с телом.
  - `interface class`: Гарантирует, что никто не унаследует реализацию (только implements).
  - `sealed class`: Известен закрытый список наследников (для switch).

  FLUTTER КОНТЕКСТ:
  `BuildContext` — это абстракция.
  Мы используем его, чтобы найти тему `Theme.of(context)` или навигатор,
  но мы понятия не имеем, как `Element` внутри хранит ссылки на дерево виджетов.
  Нам дали абстракцию (ручку управления), и мы ей пользуемся.
*/

// --- EXAMPLE: Repository Pattern ---

// АБСТРАКЦИЯ
// UI коду не важно, откуда берутся данные (сеть, кэш, база).
// Ему важен только метод getProducts().
abstract interface class ProductRepository {
  Future<List<String>> getProducts();
}

// ДЕТАЛИ РЕАЛИЗАЦИИ 1 (Сеть)
class NetworkProductRepository implements ProductRepository {
  @override
  Future<List<String>> getProducts() async {
    // Сложная логика работы с API, парсинг JSON, обработка ошибок...
    return ['Product from API'];
  }
}

// ДЕТАЛИ РЕАЛИЗАЦИИ 2 (Кэш)
class LocalProductRepository implements ProductRepository {
  @override
  Future<List<String>> getProducts() async {
    // Чтение из SQLite
    return ['Product from DB'];
  }
}

// UI слой работает с АБСТРАКЦИЕЙ
class ProductViewModel {
  final ProductRepository _repository;

  ProductViewModel(this._repository);

  void load() {
    _repository.getProducts().then((list) => print(list));
  }
}








///2
// =============================================================================
// INHERITANCE TYPES & COMPOSITION IN DART/FLUTTER
// =============================================================================

/*
  1. СПОСОБЫ РАСШИРЕНИЯ КЛАССА (INHERITANCE TYPES)
  -----------------------------------------------------------------------------
  В Dart есть свои особенности, отличающие его от C++ или Java.

  1. Single Inheritance (Одиночное наследование):
     Классика. `class B extends A`.
     Dart разрешает наследоваться только от ОДНОГО класса.

  2. Multi-level Inheritance (Многоуровневое):
     `C extends B`, а `B extends A`.
     Цепочка наследования.

  3. Hierarchical Inheritance (Иерархическое):
     `B extends A` и `C extends A`.
     Один родитель, много детей.

  4. Multiple Inheritance (Множественное наследование):
     ВАЖНО: В Dart НЕТ классического множественного наследования (как в C++),
     где класс наследует поля и методы от двух родителей сразу (`class C extends A, B`).
     
     Вместо этого Dart использует:
     a) Implements (Интерфейсы) - наследование ТИПА (контракта), но не реализации.
     b) Mixins (`with`) - подмешивание реализации. Это способ переиспользовать код
        в классах, не связанных иерархией.
*/

// --- 1. Single & Multi-level ---
class Animal {
  void eat() => print('Animal eating');
}

class Mammal extends Animal { // Single
  void breathe() => print('Breathing air');
}

class Dog extends Mammal { // Multi-level (Dog -> Mammal -> Animal)
  void bark() => print('Woof');
}

// --- 2. Hierarchical ---
class Cat extends Mammal { // Cat и Dog оба наследуются от Mammal
  void meow() => print('Meow');
}

// --- 3. The Dart Way: MIXINS (Множественное наследование поведения) ---
// Миксин - это класс без конструктора, который можно "подмешать" к другим.

mixin Swimmer {
  void swim() => print('Swimming...');
}

mixin Flyer {
  void fly() => print('Flying...');
}

// Duck получает методы и от Animal, и от Swimmer, и от Flyer.
// Это аналог множественного наследования.
class Duck extends Animal with Swimmer, Flyer {
  void quack() => print('Quack');
}

// =============================================================================

/*
  2. ПРОБЛЕМЫ НАСЛЕДОВАНИЯ (INHERITANCE PROBLEMS)
  -----------------------------------------------------------------------------
  Почему Senior-разработчики стараются избегать глубокого наследования?

  1. Fragile Base Class (Хрупкий базовый класс):
     Изменение в родительском классе может сломать логику в дочерних классах,
     о которой родитель даже не подозревает.

  2. Tight Coupling (Жесткая связность):
     Дочерний класс знает детали реализации родителя. Вы не можете просто выкинуть
     родителя и заменить его чем-то другим.

  3. Gorilla / Banana Problem:
     "Вы хотели банан, но получили гориллу, которая держит банан, и целые джунгли в придачу".
     Наследуясь от жирного класса, вы тащите за собой кучу ненужных методов и полей (память + мусор в автодополнении).
*/

// --- BAD EXAMPLE: Fragile Base Class ---

class BaseList {
  final List<String> items = [];

  void add(String item) {
    items.add(item);
  }

  void addAll(List<String> newItems) {
    // В первой версии метода здесь был цикл: for (var i in newItems) add(i);
    // Во второй версии мы решили оптимизировать:
    items.addAll(newItems); 
  }
}

class CounterList extends BaseList {
  int count = 0;

  @override
  void add(String item) {
    count++;
    super.add(item);
  }

  @override
  void addAll(List<String> newItems) {
    count += newItems.length;
    super.addAll(newItems);
  }
}

void testProblem() {
  final list = CounterList();
  // Если BaseList.addAll использует внутри себя add(),
  // то CounterList.count увеличится ДВАЖДЫ (один раз в addAll, второй раз в add).
  // Это классическая ошибка наследования реализации.
  list.addAll(['A', 'B', 'C']); 
}

// =============================================================================

/*
  3. COMPOSITION VS INHERITANCE (Композиция против Наследования)
  -----------------------------------------------------------------------------
  Золотое правило: "Favor Composition over Inheritance".

  Inheritance (IS-A): "Является". Отношения жесткие, задаются при компиляции.
  Composition (HAS-A): "Содержит". Отношения гибкие, можно менять в рантайме.

  КАК ВЫБРАТЬ:
  - Если вам нужно переиспользовать КОД (поведение) -> Композиция.
  - Если вам нужна ПОЛИМОРФНАЯ заменяемость (LSP) -> Наследование интерфейсов.
  - Наследование реализации используйте только для "чистых" иерархий (Animal -> Dog).
*/

// --- BAD EXAMPLE (Inheritance во Flutter) ---
// Мы хотим создать кнопку с красным фоном.
// Наследование связывает нас по рукам и ногам.
/*
  class RedButton extends ElevatedButton {
    // Проблема: Мы наследуем сотни полей и методов ElevatedButton.
    // Если Flutter изменит конструктор ElevatedButton, наш код сломается.
    // Мы не можем легко превратить эту кнопку в OutlinedButton.
  }
*/

// --- GOOD EXAMPLE (Composition / Decorator во Flutter) ---
// Мы создаем виджет, который СОДЕРЖИТ (Has-a) кнопку.


class RedButtonWrapper extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;

  const RedButtonWrapper({required this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {
    // Композиция: Мы оборачиваем child в Container и GestureDetector (или ElevatedButton).
    // Мы контролируем только то, что хотим изменить.
    return Container(
      color: Colors.red,
      child: ElevatedButton(
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}

// Еще пример: Стратегия (Композиция поведения)
abstract interface class Logger {
  void log(String msg);
}

class ConsoleLogger implements Logger {
  @override
  void log(String msg) => print(msg);
}

class FileLogger implements Logger {
  @override
  void log(String msg) => print('Saving to file: $msg');
}

// Класс НЕ наследуется от Логгера, он его ИСПОЛЬЗУЕТ (Composition).
// Мы можем менять поведение на лету.
class UserService {
  final Logger logger; // Has-a

  UserService(this.logger);

  void saveUser() {
    logger.log('User saved');
  }
}

// =============================================================================

/*
  4. INTERFACE SEPARATION SIGNALS (Когда интерфейс нужно разделить?)
  -----------------------------------------------------------------------------
  Принцип ISP (Interface Segregation Principle).
  
  КАК ПОНЯТЬ, ЧТО ИНТЕРФЕЙС ПЛОХОЙ:
  1. Empty Method Body: Вы реализуете интерфейс, но оставляете методы пустыми `{}`.
  2. UnimplementedError: Вы кидаете исключение, потому что этот метод вам не нужен.
  3. Fat Interface: Интерфейс содержит методы для разных акторов (Админ и Юзер в одном интерфейсе).
  4. SRP Violation: Интерфейс меняется по разным причинам (изменилась логика PDF -> меняем интерфейс, изменилась логика Email -> меняем тот же интерфейс).
*/

// --- BAD INTERFACE ---
abstract interface class IWorker {
  void work();
  void eat();
}

class Human implements IWorker {
  @override
  void work() => print('Working');
  @override
  void eat() => print('Eating lunch');
}

class Robot implements IWorker {
  @override
  void work() => print('Beep boop working');

  @override
  void eat() {
    // СИГНАЛ БЕДЫ: Роботы не едят.
    // Нам приходится либо оставлять пустым, либо кидать ошибку.
    throw UnimplementedError('Robots do not eat'); 
  }
}

// --- GOOD SEPARATION ---
abstract interface class IWorkable {
  void work();
}

abstract interface class IFeedable {
  void eat();
}

// Робот реализует только то, что может
class RobotGood implements IWorkable {
  @override
  void work() => print('Working');
}