import 'dart:isolate';

/*
Асинхронность, Future, Stream, Isolate и Event Loop в Dart
*/

// =============================================================================
// 1. What is a 'Future'? How to use? Alternatives?
// =============================================================================

/*
Теория:
Future - это объект, представляющий результат асинхронной операции, 
который может быть доступен в будущем.

Суть:
Future позволяет выполнять операции, которые могут занять некоторое время 
(например, сетевые запросы, чтение файлов), не блокируя основной поток выполнения.

Использование:
1.  Создание Future: с помощью async/await или Future.then().
2.  Обработка результата: с помощью .then(), .catchError() и .whenComplete().
3.  Ожидание завершения: с помощью await.

Альтернативы:
1.  Stream: для обработки последовательности асинхронных событий.
2.  Completer: для ручного управления Future.
*/

// Мини-шпаргалка:
// "Future - результат в будущем. then, catchError, await. Альтернативы: Stream, Completer"

// Пример кода:
import 'dart:async';

void main() async {
  // Создание Future
  Future<String> fetchData() async {
    await Future.delayed(Duration(seconds: 2)); // Имитация задержки
    return "Data fetched!";
  }

  // Использование Future
  fetchData()
      .then((result) => print("Result: $result"))
      .catchError((error) => print("Error: $error"))
      .whenComplete(() => print("Operation complete"));

  // Ожидание завершения (await)
  String data = await fetchData();
  print("Data: $data");
}

// =============================================================================
// 2. What is a 'Stream'? What types of Streams are there, what are the differences?
// =============================================================================

/*
Теория:
Stream - это последовательность асинхронных событий.

Суть:
Stream позволяет обрабатывать потоки данных, которые поступают не сразу, а постепенно 
(например, данные от сенсоров, сетевые соединения).

Типы Stream:
1.  Single-subscription Stream: Может быть прослушан только один раз. Данные теряются, если слушатель не готов.
2.  Broadcast Stream: Может быть прослушан несколько раз. Слушатели получают только новые данные, а не всю историю.

Отличия:
Single-subscription Stream используется для однократной передачи данных, 
Broadcast Stream - для многократной передачи данных нескольким слушателям.
*/

// Мини-шпаргалка:
// "Stream - последовательность событий. Single-subscription (один слушатель), Broadcast (много слушателей)"

// Пример кода:
void main() {
  // Single-subscription Stream
  Stream<int> countStream(int to) async* {
    for (int i = 1; i <= to; i++) {
      await Future.delayed(Duration(milliseconds: 500));
      yield i;
    }
  }

  // Broadcast Stream
  StreamController<int> controller = StreamController<int>.broadcast();
  controller.stream.listen((data) => print("Listener 1: $data"));
  controller.stream.listen((data) => print("Listener 2: $data"));

  controller.add(1);
  controller.add(2);
  controller.close();
}

// =============================================================================
// 3. What are yield, yeild*, sync*, async* statements?
// =============================================================================

/*
Теория:
yield, yield*, sync*, async* - это ключевые слова, используемые для создания Stream и Iterable:

1.  yield: Используется в async* функциях для отправки значения в Stream.
2.  yield*: Используется в async* функциях для делегирования генерации значений другому Stream.
3.  sync*: Используется для создания Iterable (синхронной последовательности).
4.  async*: Используется для создания Stream (асинхронной последовательности).
*/

// Мини-шпаргалка:
// "yield (Stream), yield* (делегирование Stream), sync* (Iterable), async* (Stream)"

// Пример кода:
Iterable<int> numbersSync(int n) sync* {
  for (int i = 0; i < n; i++) {
    yield i;
  }
}

Stream<int> numbersAsync(int n) async* {
  for (int i = 0; i < n; i++) {
    await Future.delayed(Duration(milliseconds: 100));
    yield i;
  }
}

Stream<int> countStream(int from, int to) async* {
  if (from <= to) {
    yield from;
    await Future.delayed(Duration(milliseconds: 100));
    yield* countStream(from + 1, to); // yield*
  }
}

// =============================================================================
// 4. Why is it impossible to do long computational operations in an asynchronous method? What should be used in this case?
// =============================================================================

/*
Теория:
Асинхронные методы (async) выполняются в том же потоке, что и UI. 
Если в асинхронном методе выполнить долгую вычислительную операцию, 
то UI поток будет заблокирован, и приложение станет "зависать".

Решение:
Использовать Isolate для выполнения долгих вычислительных операций в отдельном потоке.
*/

// Мини-шпаргалка:
// "Долгие вычисления в async -> блокировка UI. Решение: Isolate"

// =============================================================================
// 5. What is Isolate and what are they for? How to create one? How is communication between Isolates going?
// =============================================================================

/*
Теория:
Isolate - это независимый поток выполнения в Dart.

Суть:
Isolate позволяет выполнять код параллельно, не блокируя основной поток. 
Каждый Isolate имеет свою собственную память, что обеспечивает изоляцию и безопасность.

Создание Isolate:
с помощью функции Isolate.spawn().

Коммуникация между Isolates:
осуществляется через порты (SendPort и ReceivePort).
*/

// Мини-шпаргалка:
// "Isolate - параллельный поток, своя память. Isolate.spawn, SendPort, ReceivePort"

// Пример кода:

void main() async {
  ReceivePort receivePort = ReceivePort();

  Isolate.spawn(
    heavyComputation,
    receivePort.sendPort,
  );

  receivePort.listen((message) {
    print("Result from Isolate: $message");
    receivePort.close();
  });
}

void heavyComputation(SendPort sendPort) {
  int result = 0;
  for (int i = 0; i < 1000000000; i++) {
    result += i;
  }
  sendPort.send(result);
}

// =============================================================================
// 6. What is an Event Loop?
// =============================================================================

/*
Теория:
Event Loop - это механизм, который управляет выполнением асинхронных операций в Dart.

Суть:
Event Loop следит за очередью событий (Event Queue) и выполняет их по порядку. 
Когда асинхронная операция завершается, её результат помещается в очередь событий, 
и Event Loop выполняет соответствующий обработчик.
*/

// Мини-шпаргалка:
// "Event Loop - управляет асинхронными операциями, очередь событий"








void main() async {
  print('A');

  Future(() => print('B')).then((_) {
    print('C');
    Future(() => print('D'));
  });

  Future.sync(() => print('E')).then((_) => print('F'));

  await Future(() => print('G')).then((_) => print('H'));

  print('I');
}

a e i f h g b c d