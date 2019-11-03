import 'package:flutter/material.dart';
import 'package:walkdistancetracker/datamodels/location_model.dart';
import 'package:walkdistancetracker/services/location_service.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';


class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Body()
    );
  }
}

class Body extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Stack(

      children: <Widget>[
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
              /*...*/
            },
            child: Text(
              "Start",
              style: TextStyle(fontSize: 20.0),
            ),
          )
        ),
        Positioned(
          bottom: 90,
          left: 5,
          child: Container(
            width: 350,
            child: Center(
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Set Target Distance (meter)',
                ),
              ),
            ),
          )
        ),
        Positioned(
          bottom: 160,
          left: 5,
          width: 290,
          child: Text(
            'Set your walking goal'.toUpperCase(),
            overflow: TextOverflow.ellipsis,
            maxLines: 4,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold
            ),
          ),
        )
      ],
    );
  }


}

