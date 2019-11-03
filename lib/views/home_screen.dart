import 'package:flutter/material.dart';
import 'package:walkdistancetracker/datamodels/location_model.dart';
import 'package:walkdistancetracker/services/location_service.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';


class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var userContinuousLocation = Provider.of<UserLocation>(context);


    return Scaffold(
      body: Center(
        child: LocationText()
      ),
    );
  }
}

class LocationText extends StatelessWidget {
  Firestore _firestore = Firestore.instance;
  Geoflutterfire geo = Geoflutterfire();


  @override
  Widget build(BuildContext context) {
    var collectionReference = _firestore.collection('locations');
    GeoFirePoint myLocation = geo.point(latitude: 12.960632, longitude: 77.641603);
    print('Munna');
    return FutureBuilder<UserLocation>(
      future: LocationService().getLocation(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(
            'There is an Error ',
            style: Theme
                .of(context)
                .textTheme
                .headline,
          );
        } else if (snapshot.hasData) {
          collectionReference
              .add({'name': 'random name', 'position': myLocation.data});

          print(myLocation.distance(lat: snapshot.data.latitude,
              lng: snapshot.data.longitude));
          return Text(
            snapshot.data.latitude.toString(),
            style: Theme.of(context).textTheme.headline,
          );
        } else {
          return CircularProgressIndicator();
        }
      }
    );
  }
}

