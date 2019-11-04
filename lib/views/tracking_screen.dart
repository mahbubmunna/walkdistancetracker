import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:walkdistancetracker/datamodels/location_model.dart';
import 'package:walkdistancetracker/services/location_service.dart';

class TrackingScreen extends StatelessWidget {
  final _startLocation = LocationService().getLocation();
  final _fireStore = Firestore.instance;
  static var _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 30,
            left: 15,
            child: Text(
              'Now Tracking...',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
          ),
          Positioned(
            top: 60,
            child: SizedBox(
              height: 400,
              width: 350,
              child: CheckPointList(),
            ),
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
                  _calculateDistanceNSaveToDatabase(context);
                },
                child: Text(
                  "Add Check Point",
                  style: TextStyle(fontSize: 20.0),
                ),
              ))
        ],
      ),
    );
  }

  void _calculateDistanceNSaveToDatabase(BuildContext context) async {
    final geo = Geoflutterfire();
    final futureLocation = LocationService().getLocation();
    UserLocation currentLocation;
    futureLocation.then((location) {
      currentLocation = location;
    }).catchError((error) => print('This is the error: $error'));

    UserLocation startLocation;
    _startLocation.then((location) {
      startLocation = location;
      print('longitude:${location.longitude}');
    }).catchError((error) => print('This is the error: $error'));


    GeoFirePoint currentGeoPoint = geo.point(
        latitude: currentLocation.latitude, longitude: currentLocation.longitude);

    final distance = currentGeoPoint.distance(
        lat: startLocation.latitude, lng: startLocation.longitude);

    saveToFireStore(distance);

  }

  void saveToFireStore(double distance) async{
    await _fireStore.collection('checkpoints').add(
      {'title': _counter++, 'distance': distance}
    );
  }
}



class CheckPointList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection('books').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Text('Loading...');
        return ListView.builder(
            itemExtent: 80,
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) =>
                _buildListItem(context, snapshot.data.documents[index]));
      },
    );
  }
}

Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
  return Row(
    children: <Widget>[
      Expanded(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(document['title']),
        ),
      ),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            document['description'],
            overflow: TextOverflow.ellipsis,
          ),
        ),
      )
    ],
  );
}
