import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'constants.dart';
import 'location.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

const double _movedZoom = 5.0;

void main() => runApp(TerminalApp());

class TerminalApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Terminal Gözle',
      theme: CupertinoThemeData(
          textTheme: CupertinoTextThemeData()),
      home: TerminalMapPage(title: 'Terminallar'),
    );
  }
}

class TerminalMapPage extends StatefulWidget {
  TerminalMapPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _TerminalMapPageState createState() => _TerminalMapPageState();
}

class _TerminalMapPageState extends State<TerminalMapPage> {
  GoogleMapController _mapController;

  final Set<Marker> _markers = {};

  static LatLng _center = const LatLng(37.922607, 58.384225);

  MapType _currentMapType = MapType.normal;

  List<Terminal> terminalList = List<Terminal>();

  bool _isLoaded = false;


  _tryActionSheet(BuildContext context) async {
    await showCupertinoModalPopup(
      context:  context,
      builder: (context){
        return CupertinoActionSheet(
          title: Text("Welaýatlar"),
          message: Text("Kartany haýsy welaýata süýşirmek isleseňiz, şol welaýaty saýlaň"),
          actions: <Widget>[
            CupertinoActionSheetAction(
              onPressed:(){
                Navigator.of(context, rootNavigator: true).pop();
                _center = LatLng(38.839561, 58.860998);
                _mapController.animateCamera(
                    CameraUpdate.newCameraPosition(
                        CameraPosition(
                            target: _center,
                            zoom: _movedZoom
                        )
                    )
                );
              } ,
              child: Text("Ahal"),
            ),
            CupertinoActionSheetAction(
              onPressed:(){
                Navigator.of(context, rootNavigator: true).pop();
                _center = LatLng(37.922607, 58.384225);
                _mapController.animateCamera(
                    CameraUpdate.newCameraPosition(
                        CameraPosition(
                            target: _center,
                            zoom: 11.0
                        )
                    )
                );
              } ,
              child: Text("Aşgabat"),
            ),
            CupertinoActionSheetAction(
              onPressed:(){
                Navigator.of(context, rootNavigator: true).pop();
                setState(() => _center = LatLng(39.935362, 54.912013));
                _mapController.animateCamera(
                    CameraUpdate.newCameraPosition(
                        CameraPosition(
                          target: _center,
                          zoom: _movedZoom
                        )
                    )
                );
                print("balkan");
              } ,
              child: Text("Balkan"),
            ),
            CupertinoActionSheetAction(
              onPressed:(){
                Navigator.of(context, rootNavigator: true).pop();
                _center = LatLng(41.386199, 58.558616);
                _mapController.animateCamera(
                    CameraUpdate.newCameraPosition(
                        CameraPosition(
                            target: _center,
                            zoom: _movedZoom
                        )
                    )
                );
              } ,
              child: Text("Daşoguz"),
            ),
            CupertinoActionSheetAction(
              onPressed:(){
                Navigator.of(context, rootNavigator: true).pop();
                _center = LatLng(38.813115, 63.051339);
                _mapController.animateCamera(
                    CameraUpdate.newCameraPosition(
                        CameraPosition(
                            target: _center,
                            zoom: _movedZoom
                        )
                    )
                );
              } ,
              child: Text("Lebap"),
            ),
            CupertinoActionSheetAction(
              onPressed:(){
                Navigator.of(context, rootNavigator: true).pop();
                _center = LatLng(37.604699, 61.846276);
                _mapController.animateCamera(
                    CameraUpdate.newCameraPosition(
                        CameraPosition(
                            target: _center,
                            zoom: _movedZoom
                        )
                    )
                );
              } ,
              child: Text("Mary"),
            ),
          ],
          cancelButton:CupertinoActionSheetAction(
            onPressed:(){
              Navigator.of(context, rootNavigator: true).pop();
            } ,
            child: Text("Bes Et"),
          ),
        );
      },
    );
  }

  //Method to get user data from server
  Future<List<Terminal>> _fetchTerminals(BuildContext context) async {

    try{
      final response = await http.get(
          Constants.TERMINAL_URL
      );

      if (response.statusCode == 200) {
        // If server returns an OK response, parse the JSON.
        var terminals = json.decode(response.body) as List;

        print("Terminal response: " + response.statusCode.toString());

        setState(() {
          terminalList = terminals.map((i) => Terminal.fromJson(i)).toList();

          terminalList.forEach((terminal) {
            _markers.add(Marker(
              // This marker id can be anything that uniquely identifies each marker.
              markerId: MarkerId(terminal.terminalId),
              position: LatLng(terminal.altitude, terminal.longitude),
              infoWindow: InfoWindow(
                  title: terminal.owner,
                  snippet: terminal.address + " (" + terminal.statusText + ")"
              ),
              icon: terminal.status ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen): BitmapDescriptor.defaultMarker,
            ));
          });

          _isLoaded = true;
        });

        return terminalList;

      } else {
        // If that response was not OK, throw an error.
        print("Terminals response code: " + response.statusCode.toString());
        setState(() {
          _isLoaded = true;
        });
      }
    }catch(e){
      print("Could not connect to api. Check internet connectivity!");

      setState(() {
        _isLoaded = true;
      });
    }

    return null;
  }

  @override
  void initState() {
    super.initState();

    _fetchTerminals(context);
    _center = const LatLng(37.922607, 58.384225);
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _onCameraMove(CameraPosition position) {
    //_center = position.target;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.title),
      ),
      child: Stack(
        children: <Widget>[
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 11.0,
            ),
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            mapType: _currentMapType,
            markers: _markers,
            onCameraMove: _onCameraMove,
          ),
          _isLoaded ?
          Container() :
          Center(
            child: const CupertinoActivityIndicator(radius: 20.0)
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.topRight,
              child: Column(
                children: <Widget> [
                  SizedBox(height: 100.0),
                  FloatingActionButton(
                    onPressed: () {
                      _tryActionSheet(context);
                    },
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    backgroundColor: Colors.green,
                    child: const Icon(Icons.gps_not_fixed, size: 32.0),
                  ),
                ],
              ),
            ),
          ),
        ],
      )
    );
  }
}
