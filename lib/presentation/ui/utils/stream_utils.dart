import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class BehaviorSubjectNotifier<T> extends ValueNotifier<T> {
  late StreamSubscription<T> _subscription;

  BehaviorSubjectNotifier(
    BehaviorSubject<T> subject, {
    void Function(T)? onListen,
  }) : super(subject.value) {
    _subscription = subject.listen(
      onListen ??
          (newValue) {
            value = newValue;
          },
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
