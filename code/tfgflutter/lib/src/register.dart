import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'controller/userdata.dart' as ud;
import 'package:tfgflutter/main.dart';



class RegistroPage extends StatefulWidget {
  final String title = 'Registration';


  @override
  State<StatefulWidget> createState() =>
      _RegisterEmailSectionState();
}
class _RegisterEmailSectionState extends State<RegistroPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _success;
  String _userEmail;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return new WillPopScope(
        onWillPop: _onWillPop,
        child:
        Scaffold(

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

                              child:


                              Container(
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


                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text("Nombre"),
                                          TextFormField(
                                            decoration: InputDecoration(
                                               ),
                                            controller: _nombreController,
                                            validator: (String value) {
                                              if (value.isEmpty) {
                                                return ;
                                              }
                                              return null;
                                            },
                                          ),
                                          Text("Email"),
                                          TextFormField(
                                            decoration: InputDecoration(
                                                ),
                                            controller: _emailController,
                                            validator: (String value) {
                                              return null;
                                            },
                                          ),
                                          Text("Contraseña"),
                                          TextFormField(
                                            obscureText: true,
                                            controller: _passwordController,
                                            decoration: InputDecoration(
                                               ),
                                            validator: (String value) {
                                              if (value.isEmpty) {
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
                                                  _register();
                                                }
                                              },
                                              child:  Text("Registrarme"),
                                            ),
                                          ),


                                          Container(
                                            alignment: Alignment.center,
                                            child: Text(_success == null
                                                ? ''
                                                : (_success
                                                ? _userEmail
                                                : Text("Fallo registro"))),
                                          ),


                                        ],

                                      ),
                                    ]
                                ),)

                          ) ],
                      )),

                ])));

  }
  void _register() async {
    try {
      final User user = (await
      _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      )
      ).user;
      if (user != null) {
        setState(() async {
          _success = true;
          ud.DataUser datosuser = ud.DataUser();

          _userEmail = user.email;
          final token = await user.getIdToken();
          datosuser.token = token.toString();
          datosuser.email=_emailController.text;
          datosuser.refreshtoken=user.refreshToken;
          datosuser.name=_nombreController.text;
          _success = true;
          _userEmail = user.email;
          Navigator.of(context)
              .push(MaterialPageRoute<void>(
            builder: (context) => null,
          )).then( (var value) {
          });

        });

        setState(() {
          _success = true;
        });
      }
    } on FirebaseAuthException catch  (e) {
      if (e.code == 'invalid-email') {
        Text("Formato invalido");
        // Do something :D
      }else{
        Text("Ha ocurrido un error");
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
              Text('Registro',
                  style: TextStyle(color: Colors.white, fontSize: 25.0))
            ],
          ),
        )
      ],
    );
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text("Estas seguro?"),
        content: new Text("Tal"),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text("No"),
          ),
          TextButton(
            onPressed: () =>  Navigator.pushNamed(context, 'log'),
            child: new Text("Sí"),
          ),
        ],
      ),
    )) ?? false;
  }

  void _mainpage(){
    Navigator.of(context)
        .push(MaterialPageRoute<void>(
      builder: (context) => MyApp(),
    )).whenComplete(() => _refresh());
  }
  void _refresh() async {
    setState(() {});
  }

}