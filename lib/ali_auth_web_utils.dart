import 'dart:async';
import 'dart:js_util';
import 'package:js/js.dart';

typedef Func1<A, R> = R Function(A a);

@JS('JSON.stringify')
external String stringify(Object obj);

@JS('console.log')
external void log(Object obj);

@JS('alert')
external void alert(Object obj);

@JS('Promise')
class PromiseJsImpl<T> extends ThenableJsImpl<T> {
  external PromiseJsImpl(Function resolver);
  external static PromiseJsImpl<List> all(List<PromiseJsImpl> values);
  external static PromiseJsImpl reject(error);
  external static PromiseJsImpl resolve(value);
}

@anonymous
@JS()
abstract class ThenableJsImpl<T> {
  external ThenableJsImpl then([Func1 onResolve, Func1 onReject]);
}

Future<T> handleThenable<T>(ThenableJsImpl<T> thenable) =>
    promiseToFuture(thenable);
