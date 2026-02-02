// =============================================================================
// DESIGN PATTERNS (GoF) IN DART/FLUTTER (THE SENIOR GUIDE)
// =============================================================================

/*
  DESIGN PATTERNS (GoF)
  -----------------------------------------------------------------------------
  ОПРЕДЕЛЕНИЕ:
 
  ВАЖНО:
  Знать паттерны — это хорошо, но уметь применять их К МЕСТУ — еще лучше.
  Не нужно пихать Factory Method везде, где только можно.
  Главное — понимать проблему, которую решает паттерн.

  КАТЕГОРИИ:
  1. Creational (Порождающие): Про создание объектов (Factory, Builder, Singleton).
  2. Structural (Структурные): Про структуру классов (Adapter, Facade, Decorator).
  3. Behavioral (Поведенческие): Про взаимодействие объектов (Strategy, Observer, Command).
*/

// ===================s==========================================================
// 1. SINGLETON
// =============================================================================

/*
  SINGLETON
  -----------------------------------------------------------------------------
  ОПРЕДЕЛЕНИЕ:
  Паттерн, гарантирующий, что у класса будет только ОДИН экземпляр,
  и предоставляющий глобальную точку доступа к этому экземпляру.

  ПЛЮСЫ:
  1. Глобальная точка доступа.
  2. Ленивая инициализация (создается только когда нужен).

  МИНУСЫ:
  1. Глобальное состояние (сложно тестировать).
  2. Нарушение Single Responsibility Principle (класс отвечает и за свою логику, и за свой lifecycle).
  3. Может скрывать зависимости (как Service Locator).

  КОГДА ИСПОЛЬЗОВАТЬ:
  Когда нужен ровно один экземпляр (logger, database connection, app settings).

  РЕАЛИЗАЦИЯ В DART:
  1. Приватный конструктор (`_()`).
  2. Статическое поле с экземпляром (`_instance`).
  3. Статический метод `getInstance()`.
*/

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppSettings {
  // 1. Приватный конструктор
  AppSettings._();

  // 2. Статическое поле
  static final AppSettings _instance = AppSettings._();

  // 3. Геттер для доступа
  static AppSettings get instance => _instance;

  // Данные (пример)
  String theme = 'light';

  void toggleTheme() {
    theme = (theme == 'light') ? 'dark' : 'light';
    print('Theme toggled to $theme');
  }
}

void testSingleton() {
  final settings1 = AppSettings.instance;
  final settings2 = AppSettings.instance;

  print(identical(settings1, settings2)); // true (это один и тот же объект)

  settings1.toggleTheme(); // Theme toggled to dark
  print(
    settings2.theme,
  ); // dark (изменилось и в settings2, потому что это один объект)
}

/*
  SINGLETON ВО FLUTTER:
  Во Flutter Singleton часто используют для:
  - App Settings
  - Theme Service
  - Analytics Service
  - Database Connection
*/

// =============================================================================
// 2. FACTORY METHOD
// =============================================================================

/*
  FACTORY METHOD
  -----------------------------------------------------------------------------
  ОПРЕДЕЛЕНИЕ:
  Паттерн, определяющий интерфейс для создания объекта,
  но позволяющий подклассам решать, какой класс инстанцировать.

  ПЛЮСЫ:
  1. Инкапсуляция логики создания.
  2. Снижение связности (зависим от абстракции, а не от конкретного класса).
  3. Возможность возвращать подтипы.

  МИНУСЫ:
  1. Усложняет код (нужно создавать интерфейсы и фабрики).
  2. Может привести к разрастанию иерархии классов.

  КОГДА ИСПОЛЬЗОВАТЬ:
  Когда нужно создавать объекты разных типов в зависимости от условий
  (например, разные источники данных, разные платформы).

  РЕАЛИЗАЦИЯ В DART:
  1. Интерфейс продукта (абстрактный класс).
  2. Конкретные продукты (подклассы).
  3. Интерфейс фабрики (абстрактный класс или интерфейс).
  4. Конкретные фабрики (подклассы, реализующие логику создания).
*/

// --- EXAMPLE: Different Button Styles ---

// 1. Product Interface
abstract class Button {
  Widget render();
}

// 2. Concrete Products
class ElevatedButon implements Button {
  @override
  Widget render() => ElevatedButton(onPressed: () {}, child: Text('Elevated'));
}

class OutlinedButton implements Button {
  @override
  Widget render() => OutlinedButton(onPressed: () {}, child: Text('Outlined'));
}

// 3. Factory Interface (или просто функция)
abstract class ButtonFactory {
  Button createButton();
}

// 4. Concrete Factories
class ElevatedButtonFactory implements ButtonFactory {
  @override
  Button createButton() => ElevatedButon();
}

class OutlinedButtonFactory implements ButtonFactory {
  @override
  Button createButton() => OutlinedButton();
}

void testFactory() {
  final elevatedFactory = ElevatedButtonFactory();
  final elevatedButton = elevatedFactory.createButton();
  elevatedButton.render(); // Elevated Button

  final outlinedFactory = OutlinedButtonFactory();
  final outlinedButton = outlinedFactory.createButton();
  outlinedButton.render(); // Outlined Button
}

/*
  FACTORY METHOD ВО FLUTTER:
  Часто используется для:
  - Создание виджетов для разных платформ (Platform.isAndroid ? AndroidButton() : IOSButton()).
  - Создание разных источников данных (ApiDataSource() или CacheDataSource()).
*/

// =============================================================================
// 3. ABSTRACT FACTORY
// =============================================================================

/*
  ABSTRACT FACTORY
  -----------------------------------------------------------------------------
  ОПРЕДЕЛЕНИЕ:
  Паттерн, предоставляющий интерфейс для создания СЕМЕЙСТВА связанных объектов,
  не специфицируя их конкретные классы.

  ОТЛИЧИЕ ОТ FACTORY METHOD:
  Factory Method создает ОДИН продукт.
  Abstract Factory создает СЕМЕЙСТВО продуктов (связанных между собой).

  ПЛЮСЫ:
  1. Гарантирует, что продукты из семейства будут совместимы.
  2. Легко заменить целое семейство продуктов.

  МИНУСЫ:
  1. Сложно добавлять новые продукты в существующее семейство.
  2. Усложняет код.

  КОГДА ИСПОЛЬЗОВАТЬ:
  Когда нужно создавать группы связанных объектов (например, UI-компоненты для разных платформ,
  или разные темы оформления).

  РЕАЛИЗАЦИЯ В DART:
  1. Абстрактный класс фабрики (интерфейс для создания семейств продуктов).
  2. Конкретные фабрики (реализуют создание конкретных семейств).
  3. Абстрактные продукты (интерфейсы для отдельных продуктов).
  4. Конкретные продукты (реализуют отдельные продукты).
*/

// --- EXAMPLE: Cross-Platform UI Components ---

// 1. Abstract Factory
abstract class UIFactory {
  Button createButton();
  TextField createTextField();
}

// 2. Concrete Factories
class AndroidUIFactory implements UIFactory {
  @override
  Button createButton() => AndroidButton();

  @override
  TextField createTextField() => AndroidTextField();
}

class IOSUIFactory implements UIFactory {
  @override
  Button createButton() => IOSButton();

  @override
  TextField createTextField() => IOSTextField();
}

// 3. Abstract Products
abstract class Button {
  Widget render();
}

abstract class TextField {
  Widget build();
}

// 4. Concrete Products
class AndroidButton implements Button {
  @override
  Widget render() =>
      ElevatedButton(onPressed: () {}, child: Text('Android Button'));
}

class IOSButton implements Button {
  @override
  Widget render() =>
      CupertinoButton(child: Text('IOS Button'), onPressed: () {});
}

class AndroidTextField implements TextField {
  @override
  Widget build() => TextField(decoration: InputDecoration(hintText: 'Android'));
}

class IOSTextField implements TextField {
  @override
  Widget build() => CupertinoTextField(placeholder: 'IOS');
}

void testAbstractFactory() {
  final androidFactory = AndroidUIFactory();
  final androidButton = androidFactory.createButton();
  final androidTextField = androidFactory.createTextField();

  androidButton.render(); // Android Button
  androidTextField.build(); // Android TextField

  final iosFactory = IOSUIFactory();
  final iosButton = iosFactory.createButton();
  final iosTextField = iosFactory.createTextField();

  iosButton.render(); // IOS Button
  iosTextField.build(); // IOS TextField
}

/*
  ABSTRACT FACTORY ВО FLUTTER:
  Идеально подходит для:
  - Создания UI для разных платформ (Material vs Cupertino).
  - Поддержки разных тем оформления (Light vs Dark).
  - Работы с разными API (REST vs GraphQL).
*/
