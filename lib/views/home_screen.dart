import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'tracking_screen.dart';
import 'package:walkdistancetracker/datamodels/location_model.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Body());
  }
}

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final myController = TextEditingController();
  bool _enabled = false;

  @override
  void dispose() {
    // TODO: implement dispose
    myController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    //myController.clear();

    var _navigateToNext;
    if (_enabled) {
      _navigateToNext = () async {
        //Getting the initial location
        UserLocation _initialLocation;
        var location = await Location().getLocation();
        _initialLocation = UserLocation(
            longitude: location.longitude, latitude: location.latitude);


        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TrackingScreen(
                  initialLocation: _initialLocation,
                  goalDistance: myController.text,
                )));
        //myController.clear();
      };
    }
    //returned widget from this build
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
              onPressed: _navigateToNext,
              child: Text(
                "Start",
                style: TextStyle(fontSize: 20.0),
              ),
            )),
        Positioned(
            bottom: 90,
            left: 5,
            child: Container(
              width: 350,
              child: TextField(
                onChanged: (text) {
                  setState(() {
                    _enabled = true;
                  });
                },
                keyboardType: TextInputType.number,
                controller: myController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Set Target Distance (meter)',
                ),
              ),
            )),
        Positioned(
          bottom: 160,
          left: 5,
          width: 290,
          child: Text(
            'Set your walking goal'.toUpperCase(),
            overflow: TextOverflow.ellipsis,
            maxLines: 4,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
