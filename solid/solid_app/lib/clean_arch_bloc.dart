import 'dart:async';
// =============================================================================
// CLEAN ARCHITECTURE & BLoC IN FLUTTER (THE SENIOR GUIDE)
// =============================================================================

/*
  PART 1: CLEAN ARCHITECTURE (Чистая Архитектура)
  -----------------------------------------------------------------------------
  КОНЦЕПЦИЯ:
  Разделение приложения на слои, чтобы UI не зависел от Базы Данных,
  а Бизнес-логика не зависела от Фреймворка.

  ГЛАВНОЕ ПРАВИЛО (DEPENDENCY RULE):
  Зависимости направлены ТОЛЬКО ВНУТРЬ круга.
  - Data зависит от Domain.
  - Presentation зависит от Domain.
  - DOMAIN НИ ОТ КОГО НЕ ЗАВИСИТ. Это ядро.

  СЛОИ:
  1. Presentation (UI, BLoC, Widgets): Рисует пиксели и реагирует на юзера.
  2. Domain (Entities, UseCases, Repo Interfaces): Чистая бизнес-логика.
  3. Data (Repositories Impl, DTOs, API Sources): Работа с грязным миром (JSON, BD).
*/

// =============================================================================
// LAYER 1: DOMAIN (THE CORE)
// Здесь живут правила бизнеса. Здесь НЕТ Flutter-кода (ни Widgets, ни JSON).
// =============================================================================

// 1. Entity (Сущность)
// Чистый класс. То, как мы хотим видеть данные в приложении.
class UserEntity {
  final String id;
  final String fullName;
  final bool isActive;

  UserEntity({
    required this.id,
    required this.fullName,
    required this.isActive,
  });
}

// 2. Repository Interface (Контракт)
// ВАЖНО: Интерфейс лежит в Domain, чтобы UseCase мог его вызывать.
// Это инверсия зависимостей (DIP). Domain диктует условия: "Мне нужен метод getUser".
abstract interface class IUserRepository {
  Future<UserEntity> getUser(String id);
}

// 3. UseCase (Сценарий использования)
// Отвечает на вопрос "ЧТО нужно сделать?". (Single Responsibility).
class GetUserUseCase {
  final IUserRepository repository;

  GetUserUseCase(this.repository);

  Future<UserEntity> execute(String id) async {
    // Здесь может быть бизнес-логика: проверить права, залогировать и т.д.
    return repository.getUser(id);
  }
}

// =============================================================================
// LAYER 2: DATA (INFRASTRUCTURE)
// Здесь мы работаем с внешним миром и приводим его к виду Domain.
// =============================================================================

// 1. DTO (Data Transfer Object) / Model
// Модель, которая зеркалит ответ от API (JSON).
// SENIOR QUESTION: "Зачем дублировать модели?"
// ОТВЕТ: Чтобы отвязать API от Бизнес-логики. Если бэкенд переименует поле 'name' в 'n',
// мы поменяем только DTO и Mapper. Entity и весь остальной код не пострадают.
class UserDto {
  final String uid; // API присылает 'uid', а не 'id'
  final String f_name; // API присылает 'f_name'
  final String l_name;
  final bool is_active;

  UserDto({
    required this.uid,
    required this.f_name,
    required this.l_name,
    required this.is_active,
  });

  // Парсинг JSON живет только здесь
  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      uid: json['uid'],
      f_name: json['f_name'],
      l_name: json['l_name'],
      is_active: json['is_active'],
    );
  }
}

// 2. Mapper (Преобразователь)
// Превращает DTO (Data layer) в Entity (Domain layer).
extension UserMapper on UserDto {
  UserEntity toEntity() {
    return UserEntity(
      id: uid,
      fullName: '$f_name $l_name', // Логика склейки имени - здесь
      isActive: is_active,
    );
  }
}

// 3. API Source
class UserApi {
  Future<Map<String, dynamic>> fetchUser(String id) async {
    await Future.delayed(Duration(milliseconds: 500));
    return {'uid': '123', 'f_name': 'John', 'l_name': 'Doe', 'is_active': true};
  }
}

// 4. Repository Implementation
// Реализует интерфейс из Domain. Зависит от API.
class UserRepositoryImpl implements IUserRepository {
  final UserApi api;

  UserRepositoryImpl(this.api);

  @override
  Future<UserEntity> getUser(String id) async {
    try {
      final json = await api.fetchUser(id);
      final dto = UserDto.fromJson(json);
      return dto.toEntity(); // Маппинг происходит на границе слоев
    } catch (e) {
      throw Exception('Server error');
    }
  }
}

// =============================================================================
// PART 2: STATE MANAGEMENT & BLoC
// =============================================================================

/*
  WHAT TYPES OF STATE MANAGEMENT DO YOU KNOW?
  1. Ephemeral State (SetState): Для одной кнопки, анимации.
  2. App State (Global):
     - Provider (InheritedWidget wrap): Простой, популярный, но можно запутаться.
     - Riverpod: "Provider 2.0", безопасный, без контекста, compile-safe.
     - BLoC / Cubit: Стандарт индустрии. Потоки данных (Streams). Предсказуемый.
     - GetX: (Осторожно на собеседовании). Часто считают анти-паттерном из-за
       нарушения архитектуры, но он популярен. Лучше сказать: "Знаю, но предпочитаю BLoC/Riverpod".
     - MobX: Реактивный подход (Observables).
     - Redux: Единый стор (редко используется во Flutter сейчас).

  WHAT IS BLoC? (Business Logic Component)
  Паттерн, основанный на Streams (потоках).
  Основная идея: Вход (Events) -> Обработка -> Выход (States).
  UI ничего не знает о логике, он просто кидает события и слушает состояния.
*/

// --- BLoC COMPONENTS ---

// 1. Events (События)
// Что UI может попросить сделать?
abstract class UserEvent {}

class LoadUserEvent extends UserEvent {
  final String userId;
  LoadUserEvent(this.userId);
}

// 2. States (Состояния)
// Что UI может показать? (Обычно: Init, Loading, Data, Error)
abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final UserEntity user;
  UserLoaded(this.user);
}

class UserError extends UserState {
  final String message;
  UserError(this.message);
}

// 3. The BLoC
// "Черный ящик", превращающий Event в State.
class UserBloc {
  final GetUserUseCase getUserUseCase;

  // StreamController управляет потоком.
  // _stateController.stream - это то, что слушает UI (StreamBuilder).
  final _stateController = StreamController<UserState>.broadcast();

  // Текущее состояние (чтобы UI мог получить его синхронно, если надо)
  UserState _state = UserInitial();

  Stream<UserState> get stream => _stateController.stream;
  UserState get state => _state;

  UserBloc(this.getUserUseCase);

  // Метод добавления события (обычно это метод add() в библиотеке flutter_bloc)
  void add(UserEvent event) {
    if (event is LoadUserEvent) {
      _mapLoadUserToState(event);
    }
  }

  // Логика обработки
  void _mapLoadUserToState(LoadUserEvent event) async {
    // 1. Emit Loading
    _emit(UserLoading());

    try {
      // 2. Call Domain
      final user = await getUserUseCase.execute(event.userId);
      // 3. Emit Success
      _emit(UserLoaded(user));
    } catch (e) {
      // 4. Emit Error
      _emit(UserError(e.toString()));
    }
  }

  void _emit(UserState newState) {
    _state = newState;
    _stateController.add(newState);
  }

  void dispose() {
    _stateController.close();
  }
}

/*
  LIBRARY NOTE:
  В реальном проекте мы используем пакет `flutter_bloc`.
  Там не нужно создавать StreamController вручную.
  Мы пишем: on<LoadUserEvent>((event, emit) async { ... });
*/

// =============================================================================
// LAYER 3: PRESENTATION (UI)
// =============================================================================

// Псевдокод виджета
void uiExample() async {
  // Setup (Dependency Injection)
  final api = UserApi();
  final repo = UserRepositoryImpl(api);
  final useCase = GetUserUseCase(repo);
  final bloc = UserBloc(useCase);

  // UI слушает поток
  bloc.stream.listen((state) {
    if (state is UserLoading) print('UI: Показываю спиннер...');
    if (state is UserLoaded) print('UI: Привет, ${state.user.fullName}');
    if (state is UserError) print('UI: Ошибка ${state.message}');
  });

  // UI кидает событие
  print('UI: Юзер нажал кнопку');
  bloc.add(LoadUserEvent('123'));
}
