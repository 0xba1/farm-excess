import 'package:flutter/cupertino.dart';

class StateNotifier {
  ValueNotifier state = ValueNotifier("initial");

  void changeState(newState) {
    state.value = newState;
  }
}
