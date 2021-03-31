import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:newserverdemo/screens/home_screen.dart';
import 'package:newserverdemo/services/server_demo_service.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:at_demo_data/at_demo_data.dart' as at_demo_data;

class LoginScreen extends StatefulWidget {
  static const String id = 'login';

  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String atSign;
  bool showSpinner = false;
  ServerDemoService _serverDemoService = ServerDemoService.getInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyanAccent[200],
        title: Center(
          child: Text(
            'Login',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: ModalProgressHUD(
        color: Colors.white,
        inAsyncCall: showSpinner,
        child: Center(
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top:50.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.asset(
                    'assets/mahi.png',
                    height: 200.0,
                    width: 200.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top:100),
                child: Center(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: 400,
                        height: 70,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          color: Colors.white,
                          elevation: 10,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(

                                title: Center(
                                   child: DropdownButton<String>(
                                    hint: Text('\tChoose an @sign'),
                                    icon: Icon(Icons.keyboard_arrow_down),
                                    iconSize: 24,
                                    elevation: 16,
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.black87,
                                    ),
                                    underline: Container(
                                      height: 2,
                                      color: Colors.cyan,
                                    ),
                                    onChanged: (String newValue) {
                                      setState(() => atSign = newValue);
                                    },
                                    value: atSign,
                                    //!= null ? atSign : null,
                                    items: at_demo_data.allAtsigns
                                        .map<DropdownMenuItem<String>>(
                                      (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      },
                                    ).toList(),
                                ),
                                 ),
                              ),
                              ],
                          ),
                        ),
          ),
                    ),
                  ),
                 ),
              ),

                        Padding(
                          padding: const EdgeInsets.only(bottom:300),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            margin: EdgeInsets.only(left:20,right: 20),
                            child: FlatButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.cyan[500])
                              ),
                              splashColor: Colors.white,
                              child: Text('Login'),
                              color: Colors.cyan[700],
                              textColor: Colors.white,
                              onPressed: _login,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),



    );
  }

  // TODO: Write _login method
  /// Use onboard() to authenticate via PKAM public/private keys. If
  /// onboard() fails, use authenticate() to place keys.
  _login() async {
    if (atSign != null) {
      FocusScope.of(context).unfocus();
      setState(() {
        showSpinner = true;
      });
      String jsonData = _serverDemoService.encryptKeyPairs(atSign);
      _serverDemoService.onboard(atsign: atSign).then((value) async {
        Navigator.pushReplacementNamed(
          context,
          HomeScreen.id,
          arguments: atSign,
        );
      }).catchError((error) async {
        await _serverDemoService.authenticate(
          atSign,
          jsonData: jsonData,
          decryptKey: at_demo_data.aesKeyMap[atSign],
        );
        Navigator.pushReplacementNamed(
          context,
          HomeScreen.id,
          arguments: atSign,
        );
      });
    }
  }
}
