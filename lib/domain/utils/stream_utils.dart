import 'package:rxdart/rxdart.dart';

BehaviorSubject<T?> sendToStream<T>(
  T? value, {
  BehaviorSubject<T?>? stream,
  bool sendNull = true,
}) {
  if (!sendNull && value == null && stream != null) {
    return stream;
  }

  if (stream == null) {
    return BehaviorSubject.seeded(value);
  } else {
    return stream..add(value);
  }
}
