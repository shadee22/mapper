// ignore_for_file: prefer_const_constructors, prefer_final_fields

import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Home());
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 10.4746,
  );

  List _avatars = [
    'zakeer.jpg',
    'shakeeb.jpg',
    'jhon.jpg',
    'alwar.jpg',
    'parker.jpg',
  ]; 

  GoogleMapController? _controller;

  final LatLng _center = const LatLng(45.521563, -122.677433);

  Map<String, Marker> _markers = {};
  Map<CircleId, Circle> circles = <CircleId, Circle>{};

  bool showed = false;

  _goToTheLake ()async{
    _controller!.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

  final _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Mapper'),
        centerTitle: true,
        
        actions: [
          MaterialButton(
              child: Icon(
                Icons.show_chart,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  showed = !showed;
                });
              })
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          _goToTheLake();
        },
        label: Text('To the lake!'),
        icon: Icon(Icons.directions_boat),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
        _controller = controller;
    },
            scrollGesturesEnabled: true,
            tiltGesturesEnabled: true,
            markers: _markers.values.toSet(),
            circles: circles.values.toSet(),
            myLocationButtonEnabled: false,
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            onTap: (LatLng latLng) {
              Marker marker = Marker(
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueAzure),
                flat: true,
                draggable: true,
                markerId: MarkerId(latLng.toString()),
                position: latLng,
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Padding(
                          padding: const EdgeInsets.all(50.0),
                          child: Text('Your location longtitude is : $latLng'),
                        );
                      });
                },
              );

              setState(() {
                _markers[latLng.toString()] = marker;
              });
            },
          ),
          showed == false
              ? Container()
              : Positioned(
                  bottom: 10,
                  left: 10,
                  right: 10,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width - 20,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          for (var i in _avatars)
                            Container(
                              margin: EdgeInsets.all(5),
                              child: CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.red,
                                backgroundImage: AssetImage("assets/$i"),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
          Positioned(
            bottom: 90,
            right: 15,
            child: Container(
                width: 35,
                height: 105,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        setState(() {
                          _controller?.animateCamera(CameraUpdate.zoomIn());
                          var _zoom = _controller?.getZoomLevel();
                          print(_zoom);
                        });
                      },
                      padding: EdgeInsets.all(0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.add, size: 25),
                    ),
                    Divider(height: 5),
                    MaterialButton(
                      onPressed: () {
                        setState(() {
                          _controller?.animateCamera(CameraUpdate.zoomOut());
                        });
                      },
                      padding: EdgeInsets.all(0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.remove, size: 25),
                    )
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
