import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class BehaviorSubjectNotifier<T> extends ValueNotifier<T> {
  late StreamSubscription<T> _subscription;

  BehaviorSubjectNotifier(BehaviorSubject<T> subject) : super(subject.value) {
    _subscription = subject.listen((newValue) {
      value = newValue;
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
