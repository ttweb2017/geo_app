import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'constants.dart';
import 'location.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Geo Locations',
      theme: CupertinoThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          textTheme: CupertinoTextThemeData()),
      home: MyHomePage(title: 'Terminals Map Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController _mapController;

  final Set<Marker> _markers = {};

  static const LatLng _center = const LatLng(37.922607, 58.384225);

  LatLng _lastMapPosition = _center;

  MapType _currentMapType = MapType.normal;

  List<Terminal> terminalList = List<Terminal>();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  //Method to get user data from server
  Future<List<Terminal>> _fetchTerminals(BuildContext context) async {

    final response = await http.get(
        Constants.TERMINAL_URL
    );

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      var terminals = json.decode(response.body) as List;

      print("User response: " + terminalList.length.toString());

      return terminals.map((i) => Terminal.fromJson(i)).toList();

    } else {
      // If that response was not OK, throw an error.
      print("Terminals response code: " + response.statusCode.toString());
    }

    return null;
  }

  @override
  void initState() {

    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) async {
    terminalList = await _fetchTerminals(context);
    setState(() {
      //_mapController = controller;
      terminalList.forEach((terminal) {
        _markers.add(Marker(
          // This marker id can be anything that uniquely identifies each marker.
          markerId: MarkerId(terminal.terminalId),
          position: LatLng(terminal.altitude, terminal.longitude),
          infoWindow: InfoWindow(
            title: terminal.owner,
            snippet: terminal.address,
          ),
          icon: BitmapDescriptor.defaultMarker,
        ));
      });
    });
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("Terminals"),
      ),
      child: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
        mapType: _currentMapType,
        markers: _markers,
        onCameraMove: _onCameraMove,
      ),
    );
  }
}
