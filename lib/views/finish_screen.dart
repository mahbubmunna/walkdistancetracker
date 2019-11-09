import 'package:flutter/material.dart';

class FinishScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Center(
            child: Text(
              'Yahoo, you reached to your goal',
              style: Theme.of(context).textTheme.title,
            )
          ),
          Positioned(
              bottom: 15,
              right: 15,
              child: MaterialButton(
                minWidth: 200,
                height: 50,
                color: Colors.blue,
                textColor: Colors.white,
                disabledColor: Colors.grey,
                disabledTextColor: Colors.black,
                padding: EdgeInsets.all(8.0),
                splashColor: Colors.blueAccent,
                shape: StadiumBorder(),
                onPressed: () {
                  _backToHome(context);
                },
                child: Text(
                  "Home",
                  style: TextStyle(fontSize: 20.0),
                ),
              ))
        ],
      ),
    );
  }
  
  void _backToHome(BuildContext context) {
    Navigator.popUntil(context, ModalRoute.withName('/'));
  }
}

