import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:location/location.dart';
import 'package:walkdistancetracker/datamodels/location_model.dart';
import 'package:walkdistancetracker/views/finish_screen.dart';

class TrackingScreen extends StatelessWidget {
  final UserLocation initialLocation;
  final String goalDistance;
  final _fireStore = Firestore.instance;
  static var _counter = 1;
  static var _recentCheckPoint = 0.0;
  static var _recentDistCovered = 0;

  TrackingScreen({this.initialLocation, this.goalDistance});

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
            top: 90,
            child: SizedBox(
              height: 450,
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

    //Value Confirmation Debug
    print('Debug values:');
    print(initialLocation.longitude);
    print(goalDistance);

    var currentLocation = await Location().getLocation();

    GeoFirePoint currentGeoPoint = geo.point(
        latitude: currentLocation.latitude,
        longitude: currentLocation.longitude);
    final checkPointDistance = currentGeoPoint.distance(
        lat: initialLocation.latitude, lng: initialLocation.longitude);

    saveToFireStore(checkPointDistance * 1000, context);
  }

  void saveToFireStore(double totalDistance, BuildContext context) async {
    if (totalDistance.toInt() < int.parse(goalDistance)) {
      _recentDistCovered = totalDistance.toInt() - _recentCheckPoint.toInt();

      if (_recentDistCovered < 0) {
        _recentDistCovered = 0;
        _recentCheckPoint = 0;
      } else {
        _recentCheckPoint = totalDistance;
      }

      await _fireStore
          .collection('checkpoints')
          .add({'title': _counter++, 'distance': _recentDistCovered});
    } else {
      await _fireStore
          .collection('checkpoints')
          .getDocuments()
          .then((snapshot) {
            for (var ds in snapshot.documents) ds.reference.delete();
      });
      _counter = 1;

      Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(builder: (context) => FinishScreen()), ModalRoute.withName('/'));
    }
  }
}

class CheckPointList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection('checkpoints').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Center(child: const Text('Loading...'));
        return Scrollbar(
          child: ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) =>
                  _buildListTile(context, snapshot.data.documents[index])),
        );
      },
    );
  }
}

Widget _buildListTile(BuildContext context, DocumentSnapshot document) {
  return Card(
    color: Colors.yellowAccent[100],
    child: ListTile(
      leading: Text('Checkpoint ${document['title'].toString()}'),
      trailing: Text(
        document['distance'].toString(),
        overflow: TextOverflow.ellipsis,
      ),
      dense: true,
      selected: true,
    ),
  );
}
