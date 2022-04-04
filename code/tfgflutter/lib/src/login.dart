import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'controller/userdata.dart' as ud;


class LoginPage extends StatefulWidget {
  //final String title = 'Registration';


  @override
  State<StatefulWidget> createState() => _LoginSectionState();
}

class _LoginSectionState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _success;
  String _userEmail;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return  new WillPopScope(
        onWillPop: null,
        child:Scaffold(
            body:
            Stack(
                children: <Widget>[
                  _crearFondo(context),
                  SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          SafeArea(
                            child: Container(
                              height: 180.0,
                            ),
                          ),
                          Form(
                              key: _formKey,
                              child: Container(
                                width: size.width * 0.85,
                                margin: EdgeInsets.symmetric(vertical: 30.0),
                                padding: EdgeInsets.symmetric(vertical: 50.0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5.0),
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 3.0,
                                          offset: Offset(0.0, 5.0),
                                          spreadRadius: 3.0)
                                    ]),
                                child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child:
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text("Email"),
                                            TextFormField(
                                              controller: _emailController,
                                              cursorColor: Colors.lightGreen,
                                              decoration: InputDecoration(

                                                  ),
                                              validator: (String value) {
                                                if (value.isEmpty) {
                                                  return null;
                                                }
                                                return null;
                                              },
                                            ),
                                            Text( "Password"),
                                            TextFormField(
                                              obscureText: true,
                                              controller: _passwordController,
                                              cursorColor: Colors.lightGreen,
                                              decoration: InputDecoration(

                                                 ),
                                              validator: (String value) {
                                                if (value.isEmpty) {
                                                  return  null;
                                                }
                                                return null;
                                              },
                                            ),
                                            Container(
                                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                                              alignment: Alignment.center,
                                              child: RaisedButton(
                                                onPressed: () async {
                                                  if (_formKey.currentState.validate()) {
                                                    _login();
                                                  }
                                                },
                                                child:  Text("Iniciar Sesión"),
                                              ),
                                            ),

                                            Container(
                                              alignment: Alignment.center,
                                              child: Text(_success == null
                                                  ? ''
                                                  : (_success
                                                  ? 'loginok' + _userEmail
                                                  : 'loginfail')),
                                            )
                                          ],
                                        ),)]
                                ),)
                          ),FlatButton(
                              onPressed: () =>
                                  Navigator.pushReplacementNamed(context, 'registro'),
                              child: Text( "Crear Nueva Cuenta")),

                        ],
                      ))
                ]))
    );
  }
  void _login() async {
    try {
      final User user = (await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      )).user;
      if (user != null) {
        setState(() async {
          ud.DataUser datosuser = ud.DataUser();
          final token = await user.getIdToken();
          datosuser.token = token.toString();
          datosuser.email=_emailController.text;
          datosuser.refreshtoken=user.refreshToken;
          _success = true;
          _userEmail = user.email;
          Navigator.pushReplacementNamed(context, 'home');
        });

        setState(() {
          _success = true;
        });
      }
    } on FirebaseAuthException catch  (e) {
      if (e.code == 'invalid-email') {
        Text("Formato incorrecto");
      } else {
        Text("Ha ocurrido un error");
      }
    }
  }

  }

  Widget _crearFondo(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final fondoMorado = Container(
      height: size.height * 0.4,
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: <Color>[
            Color.fromRGBO(63, 63, 156, 1.0),
            Color.fromRGBO(90, 70, 178, 1.0)
          ])),
    );

    final circulo = Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color: Color.fromRGBO(255, 255, 255, 0.05)),
    );

    return Stack(
      children: <Widget>[
        fondoMorado,
        Positioned(top: 90.0, left: 30.0, child: circulo),
        Positioned(top: -40.0, right: -30.0, child: circulo),
        Positioned(bottom: -50.0, right: -10.0, child: circulo),
        Positioned(bottom: 120.0, right: 20.0, child: circulo),
        Positioned(bottom: -50.0, left: -20.0, child: circulo),
        Container(
          padding: EdgeInsets.only(top: 80.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 10.0, width: double.infinity),
              Text('Cadena de Favores',
                  style: TextStyle(color: Colors.white, fontSize: 25.0))
            ],
          ),
        )
      ],
    );



}