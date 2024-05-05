import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(ArithmeticDrillsApp());
}

class ArithmeticDrillsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arithmetic Drills',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Comic Sans MS',
      ),
      home: ArithmeticDrillsScreen(),
    );
  }
}

class ArithmeticDrillsScreen extends StatefulWidget {
  const ArithmeticDrillsScreen({Key? key}) : super(key: key);

  @override
  _ArithmeticDrillsScreenState createState() => _ArithmeticDrillsScreenState();
}

class _ArithmeticDrillsScreenState extends State<ArithmeticDrillsScreen> {
  static const int numProblems = 10;
  static const int maxAddSub = 50;
  static const int maxMul = 12;

  final Random _random = Random();
  final List<String> _problems = [];
  final List<int> _answers = [];
  int _score = 0;
  int _currentIndex = 0;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _generateProblems();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _generateProblems() {
    for (int i = 0; i < numProblems; i++) {
      int operand1, operand2;
      String operator;

      if (i < numProblems / 4) {
        operand1 = _random.nextInt(maxAddSub) + 1;
        operand2 = _random.nextInt(maxAddSub) + 1;
        operator = '+';
      } else if (i < numProblems / 2) {
        operand1 = _random.nextInt(maxAddSub) + 1;
        operand2 = _random.nextInt(operand1) + 1;
        operator = '-';
      } else if (i < 3 * numProblems / 4) {
        operand1 = _random.nextInt(maxMul) + 1;
        operand2 = _random.nextInt(maxMul) + 1;
        operator = '×';
      } else {
        operand2 = _random.nextInt(maxMul) + 1;
        operand1 = operand2 * (_random.nextInt(maxMul) + 1);
        operator = '÷';
      }

      _problems.add('$operand1 $operator $operand2');
      _answers.add(_getExpectedAnswer(operand1, operand2, operator));
    }
  }

  int _getExpectedAnswer(int operand1, int operand2, String operator) {
    switch (operator) {
      case '+':
        return operand1 + operand2;
      case '-':
        return operand1 - operand2;
      case '×':
        return operand1 * operand2;
      case '÷':
        return (operand1 / operand2).truncate();
      default:
        throw ArgumentError('Invalid operator');
    }
  }

  void _checkAnswer(int userAnswer) {
    setState(() {
      String message;
      if (userAnswer == _answers[_currentIndex]) {
        _score++;
        message = 'Correct!';
      } else {
        message = 'Wrong! The correct answer is ${_answers[_currentIndex]}.';
      }
      _currentIndex++;
      _controller.clear();

      if (_currentIndex == numProblems) {
        _showCelebratoryAnimation();
      } else {
        _showMessageDialog(message);
      }
    });
  }

  void _showMessageDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showCelebratoryAnimation() {
    String scoreMessage;
    if (_score == numProblems) {
      scoreMessage = 'Congratulations! YOU ARE A STAR\nYou scored $_score / $numProblems. Well done!';
    } else if (_score >= 8) {
      scoreMessage = 'Excellent!\nYou scored $_score / $numProblems.';
    } else if (_score >= 5) {
      scoreMessage = 'Good Score!\nYou scored $_score / $numProblems.';
    } else {
      scoreMessage = 'Winners do not quit,Keep Practicing!\nYou scored $_score / $numProblems.';
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: Duration(seconds: 2),
                  curve: Curves.easeInOut,
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.orange,
                        Colors.green,
                        Colors.blue,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      scoreMessage,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _restart() {
    setState(() {
      _score = 0;
      _currentIndex = 0;
      _problems.clear();
      _answers.clear();
      _generateProblems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Arithmetic Drills'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      backgroundColor: Colors.lightBlue.shade50,
      body: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.blue,
            width: 4.0,
          ),
        ),
        child: _currentIndex < numProblems
            ? SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Problem ${_currentIndex + 1}:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  _problems[_currentIndex],
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Enter your answer',
                    hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear, color: Colors.grey),
                      onPressed: () {
                        setState(() {
                          _controller.clear();
                        });
                      },
                    ),
                  ),
                  onSubmitted: (String value) {
                    _checkAnswer(int.parse(value));
                  },
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Row(

                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _controller.clear();
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                        minimumSize: MaterialStateProperty.all<Size>(Size(60, 40)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      child: Text('Clear', style: TextStyle(color: Colors.white)),
                    ),
                      ElevatedButton(
                onPressed: _restart,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                ),
                child: Text('Restart'),
              ),
                    ElevatedButton(
                      onPressed: () {
                        _checkAnswer(int.parse(_controller.text));
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                        minimumSize: MaterialStateProperty.all<Size>(Size(60, 40)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      child: Text('Submit', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        for (int i = 1; i <= 3; i++)
                          ElevatedButton(
                            onPressed: () {
                              _controller.text += '$i';
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                              minimumSize: MaterialStateProperty.all<Size>(Size(100, 100)),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                            child: Text('$i', style: TextStyle(color: Colors.white)),
                          ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        for (int i = 4; i <= 6; i++)
                          ElevatedButton(
                            onPressed: () {
                              _controller.text += '$i';
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                              minimumSize: MaterialStateProperty.all<Size>(Size(100, 100)),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                            child: Text('$i', style: TextStyle(color: Colors.white)),
                          ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        for (int i = 7; i <= 9; i++)
                          ElevatedButton(
                            onPressed: () {
                              _controller.text += '$i';
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                              minimumSize: MaterialStateProperty.all<Size>(Size(100, 100)),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                            child: Text('$i', style: TextStyle(color: Colors.white)),
                          ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _controller.text += '0';
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                            minimumSize: MaterialStateProperty.all<Size>(Size(100, 100)),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          child: Text('0', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
            : Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Your score: $_score / $numProblems',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _restart,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                ),
                child: Text('Restart'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
