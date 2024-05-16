import 'package:carl/database.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
    required this.title,
    required UserDatabase databaseHelper,
    required User user,
  }) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String display = '0';
  String operand = '';
  double firstNumber = 0.0;
  double secondNumber = 0.0;
  List<String> history = [];

  void buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        display = '0';
        firstNumber = 0.0;
        secondNumber = 0.0;
        operand = '';
      } else if (buttonText == '+' || buttonText == '-' || buttonText == 'x' || buttonText == '/') {
        firstNumber = double.parse(display);
        operand = buttonText;
        display = '0';
      } else if (buttonText == '=') {
        secondNumber = double.parse(display);
        String calculation;
        if (operand == '+') {
          calculation = '$firstNumber + $secondNumber';
          display = (firstNumber + secondNumber).toString();
        } else if (operand == '-') {
          calculation = '$firstNumber - $secondNumber';
          display = (firstNumber - secondNumber).toString();
        } else if (operand == 'x') {
          calculation = '$firstNumber * $secondNumber';
          display = (firstNumber * secondNumber).toString();
        } else if (operand == '/') {
          if (secondNumber != 0) {
            calculation = '$firstNumber / $secondNumber';
            display = (firstNumber / secondNumber).toString();
          } else {
            calculation = '$firstNumber / $secondNumber';
            display = 'Error';
          }
        } else {
          calculation = 'Error';
        }
        history.add('$calculation = $display');
        operand = '';
      } else {
        display = (display == '0') ? buttonText : display + buttonText;
      }
    });
  }

  Widget buildButton(String buttonText, Color color, {Color textColor = Colors.white}) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(5),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(20.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: color,
            textStyle: const TextStyle(fontSize: 24),
          ),
          child: Text(buttonText, style: TextStyle(color: textColor)),
          onPressed: () => buttonPressed(buttonText),
        ),
      ),
    );
  }

  void showHistory(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("History"),
          content: Container(
            width: double.maxFinite,
            height: 300.0,
            child: ListView(
              children: history.map((entry) => Text(entry)).toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void logout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Logout"),
          content: Text("Are you sure you want to logout?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Logout"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => showHistory(context),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: logout,
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(
                vertical: 24,
                horizontal: 12,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    operand.isEmpty ? '' : '$firstNumber $operand $secondNumber',
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    display,
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(),
          Column(
            children: [
              Row(
                children: [
                  buildButton('C', Colors.grey, textColor: Colors.black),
                  buildButton('/', Colors.orange),
                  buildButton('x', Colors.orange),
                  buildButton('-', Colors.orange),
                ],
              ),
              Row(
                children: [
                  buildButton('7', Colors.grey.shade800),
                  buildButton('8', Colors.grey.shade800),
                  buildButton('9', Colors.grey.shade800),
                  buildButton('+', Colors.orange),
                ],
              ),
              Row(
                children: [
                  buildButton('4', Colors.grey.shade800),
                  buildButton('5', Colors.grey.shade800),
                  buildButton('6', Colors.grey.shade800),
                  buildButton('=', Colors.orange),
                ],
              ),
              Row(
                children: [
                  buildButton('1', Colors.grey.shade800),
                  buildButton('2', Colors.grey.shade800),
                  buildButton('3', Colors.grey.shade800),
                ],
              ),
              Row(
                children: [
                  buildButton('0', Colors.grey.shade800),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
