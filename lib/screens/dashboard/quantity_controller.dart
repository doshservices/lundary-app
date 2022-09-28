import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import './number_increment_decrement.dart';

class QuantityController extends StatelessWidget {
  final int initialValue;
  final Function onIncrement, onDecrement;
  QuantityController({this.initialValue, this.onIncrement, this.onDecrement});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 30,
      child: NumberInputWithIncrementDecrement(
        onIncrement: onIncrement,
        onDecrement: onDecrement,
        controller: TextEditingController(),
        min: 0,
        max: 50,
        enabled: false,
        initialValue: initialValue,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
        ),
        incIconSize: 20,
        decIconSize: 20,
        incIcon: Icons.add,
        incIconColor: Theme.of(context).primaryColor,
        decIconColor: Theme.of(context).primaryColor,
        decIcon: CupertinoIcons.minus,
        buttonArrangement: ButtonArrangement.incRightDecLeft,
        incIconDecoration: BoxDecoration(
          border: Border.all(width: 0, color: Colors.black54),
        ),
        decIconDecoration: BoxDecoration(
          border: Border.all(width: 0, color: Colors.black54),
        ),
        widgetContainerDecoration: BoxDecoration(
            color: Color(0xffEAE8FE),
            border: Border.all(width: 0, color: Color(0xffEAE8FE)),
            borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
