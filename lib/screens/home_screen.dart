import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:at_commons/at_commons.dart';
import 'package:newserverdemo/services/server_demo_service.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home';

  final String atSign;

  const HomeScreen({
    Key key,
    @required this.atSign,
  })  : assert(atSign != null),
        super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // TODO: Instantiate variables
  //update
  String _key;
  String _value;

  // lookup
  TextEditingController _lookupTextFieldController = TextEditingController();
  String _lookupKey;
  String _lookupValue = '';

  // scan
  List<String> _scanItems = List<String>();

  // service
  ServerDemoService _serverDemoService = ServerDemoService.getInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text(
          'Home',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //update
              Flexible(
                fit: FlexFit.loose,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: Colors.cyan[700],
                  elevation: 10,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[

                      Container(
                        margin: EdgeInsets.all(10),
                        child: FlatButton(
                          child: Text('Update'),
                          color: Colors.cyan[700],
                          textColor: Colors.white,
                          // TODO: Complete the onPressed function
                          onPressed: _update,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //scan

            ],
          ),
        ),
      ),
    );
  }

  // TODO: add the _scan, _update, and _lookup methods
  /// Create instance of an AtKey and pass that
  /// into the put() method with the corresponding
  /// _value string.
  _update() async {
    if (_key != null && _value != null) {
      AtKey pair = AtKey();
      pair.key = _key;
      pair.sharedWith = widget.atSign;
      await _serverDemoService.put(pair, _value);
    }
  }

  /// getAtKeys() will retrieve keys shared by [atSign].
  /// Strip any meta data away from the retrieves keys. Store
  /// the keys into [_scanItems].
  _scan() async {
    List<AtKey> response = await _serverDemoService.getAtKeys(
      sharedBy: widget.atSign,
    );
    if (response.length > 0) {
      List<String> scanList = response.map((atKey) => atKey.key).toList();
      setState(() => _scanItems = scanList);
    }
  }

  /// Create instance of an AtKey and call get() on it.
  _lookup() async {
    if (_lookupKey != null) {
      AtKey lookup = AtKey();
      lookup.key = _lookupKey;
      lookup.sharedWith = widget.atSign;
      String response = await _serverDemoService.get(lookup);
      if (response != null) {
        setState(() => _lookupValue = response);
      }
    }
  }
}
