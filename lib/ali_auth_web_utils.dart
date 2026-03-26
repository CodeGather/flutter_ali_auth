import 'dart:js_interop';

// 基础 JS 函数映射
@JS('JSON.stringify')
external String stringify(Object? obj);

@JS('console.log')
external void log(Object? obj);

@JS('alert')
external void alert(Object? obj);

// 注意：新版 Dart 会自动将 JS 的 Promise 对象转换为 Dart 的 Future，
// 因此无需再自定义 PromiseJsImpl、ThenableJsImpl 等包装类。
// 如果原代码中有以下场景：
//   - 调用返回 Promise 的 JS 函数，可直接声明为返回 Future<T>。
//   - 手动创建 Promise，可通过 JS 的 Promise 构造函数 callAsConstructor 实现（通常不必要）。
//   - 将 Dart 函数作为回调传递给 JS，使用 .toJS 扩展方法转换。

// 示例：假设 JS 端有一个返回 Promise 的函数
// @JS('someAsyncFunction')
// external Future<String> someAsyncFunction();

// 示例：将 Dart 回调转换为 JS 函数
// void someJsFunction(JSFunction callback) { ... }
// final jsCallback = (String msg) { print(msg); }.toJS;
// someJsFunction(jsCallback);