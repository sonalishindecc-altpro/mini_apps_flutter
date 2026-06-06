import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorApp extends StatefulWidget {
  @override
  _CalculatorAppState createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  String _expression = "";
  String _output = "0";

  void _onButtonPressed(String value) {
    setState(() {
      if (value == "C") {
        _expression = "";
        _output = "0";
      } else if (value == "=") {
        try {
          Parser p = Parser();
          Expression exp = p.parse(_expression.replaceAll("×", "*").replaceAll("÷", "/"));
          ContextModel cm = ContextModel();
          double eval = exp.evaluate(EvaluationType.REAL, cm);
          _output = eval.toString();
        } catch (e) {
          _output = "Error";
        }
      } else {
        _expression += value;
        _output = _expression;
      }
    });
  }

  Widget _buildButton(String value) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () => _onButtonPressed(value),
        child: Text(value, style: TextStyle(fontSize: 24)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Calculator")),
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.all(24),
              child: Text(_output, style: TextStyle(fontSize: 36)),
            ),
          ),
          Row(children: [_buildButton("7"), _buildButton("8"), _buildButton("9"), _buildButton("÷")]),
          Row(children: [_buildButton("4"), _buildButton("5"), _buildButton("6"), _buildButton("×")]),
          Row(children: [_buildButton("1"), _buildButton("2"), _buildButton("3"), _buildButton("-")]),
          Row(children: [_buildButton("0"), _buildButton("."), _buildButton("="), _buildButton("+")]),
          Row(children: [_buildButton("C")]),
        ],
      ),
    );
  }
}
