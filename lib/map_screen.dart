import 'dart:async';
import 'dart:convert';
import 'dart:io';




import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:math' as Math;



const kGoogleApiKey = "YOUR_API_KEY";
//GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
class locationscreen extends StatefulWidget {
   const locationscreen({Key? key}) : super(key: key);



  @override
  State<locationscreen> createState() => _locationscreenState();
}


class _locationscreenState extends State<locationscreen> {


  late String _currentAddress = "";
  //Position? _currentPosition;
  late GoogleMapController googleMapController;
  static  CameraPosition inialcameraposition= CameraPosition(target: LatLng(19.2785471,72.8796206),zoom: 14);
  Set <Marker> markers={};
  bool isLoading = false;
  late String errorLoading;
  bool _isLoading = true;
  var demoadress="";
  var userid=0;

 // late PlacesDetailsResponse place;
  Completer<GoogleMapController> _controller = Completer();
  Location location = Location();
  LocationData? _locationData;
  double distanceInMeters=0.00;
  bool isdistance=false;
  StreamSubscription<LocationData>? _locationSubscription;

  double _buildingLat = 19.0084243; // Building latitude
  double _buildingLng = 72.8208822; // Building longitude
  double _radius = 300; // Radius in meters



  ///below code for distance calculation
  double calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    const p = 0.017453292519943295;
    final c = Math.cos;
    final a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lng2 - lng1) * p)) / 2;
    return 12742 * Math.asin(Math.sqrt(a));
  }
  @override
  void initState() {
    super.initState();
    _locationSubscription =
        location.onLocationChanged.listen((LocationData data) {
          setState(() {
            _locationData = data;
            print("stated data"+_locationData!.longitude!.toString());

          });
          setState(() {

          });
        });

  }


  @override
  void dispose() {
   // _locationSubscription?.cancel();
    super.dispose();
  }

/*  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }


  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
        _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
        '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }
  Future<Position>_determineposition()async{
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if(!serviceEnabled){
      return Future.error("Location Service are disabled");
    }
    permission=await Geolocator.checkPermission();
    if(permission==LocationPermission.denied){
      permission=await Geolocator.requestPermission();
      if(permission==LocationPermission.denied){
        return Future.error("Location Service are disabled");

      }
    }
    if(permission==LocationPermission.deniedForever){
      return Future.error("Location Service are disabled");
    }
    Position position =await Geolocator.getCurrentPosition();
    return position;
  }
  Position? pos;

  Future<void> Loc() async {
     pos =await _determineposition();
     print("rohanbhai"+pos!.longitude.toString());

    googleMapController.animateCamera
      (CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(pos!.latitude,pos!.longitude),zoom: 14)));
  }
  late LatLng buildingLocation;

  @override
  void initState() {
    Loc();

    super.initState();
  }*/
  static final LatLng buildingLocation1 = LatLng(19.0084243, 72.8208822);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Material(

      child: InkWell(
        onTap: (){},
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.blueAccent,
            title: const Text(
              "Location Screen",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              color: Colors.black,
              onPressed: () {

                Navigator.of(context)
                    .pop();

              },
            ),
          ),
          body: SafeArea(
            child: Container(
              margin: const EdgeInsets.all(10.0),
              child: GoogleMap(initialCameraPosition: inialcameraposition,
                myLocationEnabled: true,
                markers: markers,
                zoomControlsEnabled: true,
                mapType: MapType.normal,
                onMapCreated: (GoogleMapController controller)  {
                  googleMapController =controller;
                  googleMapController.animateCamera
                    (CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(_buildingLat,_buildingLng),zoom: 15)));
                  print( "mydata");
                  print(_locationData);
                  if(_locationData !=null){
                    print("hererohan"+_locationData.toString());
                     distanceInMeters = calculateDistance(
                      // 19.0076413, 72.8141792,
                     _locationData!.latitude!,
                     _locationData!.longitude!,
                      _buildingLat,
                      _buildingLng,
                    );
                     if(distanceInMeters<=0.3){
                       setState(() {
                         print(isdistance);
                         isdistance=true;
                         print(isdistance);
                       });

                     }
                    print("distancefromToto"+distanceInMeters.toString());
                    /*if (distanceInMeters<=3.000) {
                      print("19.0699, 72.8374");
                      print(distanceInMeters);
                      print("rohandada1");
                      // Show alert dialog indicating the person is inside the building
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Inside Building'),
                            content: const Text('You are inside the building.'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      print("rohandada2");

                      // Show alert dialog indicating the person is outside the building
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Outside Building'),
                            content: const Text('You are outside the building.'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }*/
                  }
                },
                onCameraIdle: (){
                 // googleMapController =controller;
                  googleMapController.animateCamera
                    (CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(_buildingLat,_buildingLng),zoom: 15)));
                  print( "mydata");
                  print(_locationData);
                  if(_locationData !=null){
                    print("hererohan"+_locationData.toString());
                    distanceInMeters = calculateDistance(
                       //19.0076413, 72.8141792, ///sidhjivinayak tempal
                      19.0082821, 72.8182627,  //ommkar building
                      //  _locationData!.latitude!,
                    //  _locationData!.longitude!,
                      _buildingLat,
                      _buildingLng,
                    );
                    if(distanceInMeters<=0.3){
                      setState(() {
                        isdistance=true;
                      });

                    }
                    print("distancefromToto"+distanceInMeters.toString());

                  }
                },


                circles: {
                  Circle(
                    circleId: CircleId('building_circle'),
                    center: LatLng(_buildingLat, _buildingLng),
                    radius: _radius,
                    fillColor: Colors.blue.withOpacity(0.5),
                    strokeColor: Colors.blue.withOpacity(0.5),
                    strokeWidth: 2,
                    zIndex: 1,
                    visible: distanceInMeters<=0.3?true:false
                   // visible: isdistance==true?true:false
                  ),
                  if (_locationData != null)
                    Circle(
                      circleId: CircleId('person_circle'),
                     center: LatLng(19.0082821, 72.8182627),
                     // center: LatLng(_locationData!.latitude!, _locationData!.longitude!),
                      radius: 20,
                      fillColor: Colors.red.withOpacity(0.5),
                      strokeColor: Colors.green.withOpacity(0.5),
                      strokeWidth: 2,
                      zIndex: 0,
                    ),
                },

              ),
            ),
          ),
        ),
      ),
    );
  }


}
