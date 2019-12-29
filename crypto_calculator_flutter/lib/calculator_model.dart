import 'package:flutter/foundation.dart';
import 'dart:math';


extension Precision on double {
    double toPrecision(int fractionDigits) {
    double mod = pow(10, fractionDigits.toDouble());
    return ((this * mod).round().toDouble() / mod);
  }
}

enum Direction { forward, reverse,
}

class CalculatorModel extends ChangeNotifier {

  Direction _direction = Direction.forward;
  double _rate = 0.0;
  double _amount = 0.0;

  Direction get direction => _direction;
  set direction(Direction value) {
    _direction = value;

    notifyListeners();
  }

  double get rate => _rate;
  set rate(double value) {
    _rate = value;

    notifyListeners();
  }

  double get amount => _amount;
  set amount(double value) {
    _amount = value;

    notifyListeners();
  }

  double get totalAmount {
    var totalAmout = 0.0;
    switch (_direction) {
      case Direction.forward:
        totalAmout = (amount * rate).toPrecision(2);
        break;
      case Direction.reverse:
        totalAmout = (rate != 0.0) ? (amount / rate).toPrecision(8) : 0.0;
        break;
    }
    return totalAmout;
  }
}
