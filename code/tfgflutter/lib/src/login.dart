import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'controller/userdata.dart' as ud;
import 'home.dart';


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


  void _navigateHome(){
    Navigator.of(context)
        .push(MaterialPageRoute<void>(
      builder: (context) => HomePage(),
    )).then( (var value) {

    });
  }
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
                                    //color: Colors.yellow,
                                    borderRadius: BorderRadius.circular(5.0),
                                   ),
                                child: Column(


                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child:
                                        Column(

                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[

                                            Container(
                                              color:Colors.white,
                                              child:TextFormField(

                                              controller: _emailController,
                                              cursorColor: Colors.blue,
                                                decoration: InputDecoration(
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(1.0),
                                                    ),
                                                    filled: true,
                                                    hintStyle: TextStyle(color: Colors.grey[800]),
                                                    hintText: "Email",
                                                    fillColor: Colors.white70),
                                              validator: (String value) {
                                                if (value.isEmpty) {
                                                  return ("Debes introducir un email válido");
                                                }
                                                return null;
                                              },
                                            ) ,),
                                            Padding(padding: EdgeInsets.all(10)),


                                            Container(
                                              color: Colors.white,
                                              child:  TextFormField(
                                                obscureText: true,
                                                controller: _passwordController,
                                                cursorColor: Colors.lightGreen,
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(1.0),
                                                  ),
                                                    filled: true,
                                                    hintStyle: TextStyle(color: Colors.grey[800]),
                                                    hintText: "Contraseña",
                                                    fillColor: Colors.white70),



                                                validator: (String value) {

                                                  if (value.isEmpty) {
                                                    return  ("Debes introducir tu contraseña ");
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),

                                            Container(
                                              padding: const EdgeInsets.symmetric(vertical: 30.0),

                                              alignment: Alignment.center,
                                              child:
                                              SizedBox(
                                                width: 350.0,
                                                height: 50.0,
                                                child:  ElevatedButton(
                                                  onPressed: () async {
                                                    if (_formKey.currentState.validate()) {
                                                      _login();
                                                    }
                                                  },
                                                  child:  Text("Iniciar Sesión"),
                                                ),
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
          //_navigateHome();

          Navigator.pushReplacementNamed(context, 'home');


        });

        setState(() {
          _success = true;
        });
      }
    } on FirebaseAuthException catch  (e) {
      if (e.code == 'invalid-email') {
        mostrarAviso(context, "El mail proporcionado no es válido, inténtelo de nuevo");
      }
      if (e.code == 'user-not-found') {
        mostrarAviso(context, "El mail proporcionado no corresponde a ningún usuario, inténtelo de nuevo o regístrese");
      }
      if (e.code == 'wrong-password') {
        mostrarAviso(context, "La contraseña introducida no es correcta");
      }
    }
  }

  }

void mostrarAviso(BuildContext context, String mensaje) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Alerta'),
          content: Text(mensaje),
          actions: <Widget>[
            FlatButton(
                onPressed: () => Navigator.of(context).pop(), child: Text('Ok'))
          ],
        );
      });
}



  Widget _crearFondo(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final fondoMorado = Container(
      height: size.height ,
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: <Color>[
            //Color.fromRGBO(29, 23, 91, 1.0),
            Colors.amberAccent,
            Colors.blueGrey,

          ])),
    );

    final circulo = Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color: Color.fromRGBO(255, 255, 255, 0.05)),
    );

    void _navigateHome(){
      Navigator.of(context)
          .push(MaterialPageRoute<void>(
        builder: (context) => HomePage(),
      )).then( (var value) {

      });
    }


    return Stack(
      children: <Widget>[
        fondoMorado,
        Positioned(top: 90.0, left: 30.0, child: circulo),
        Positioned(top: -40.0, right: -30.0, child: circulo),
        Positioned(bottom: -50.0, right: -10.0, child: circulo),
        Positioned(bottom: 120.0, right: 20.0, child: circulo),
        Positioned(bottom: -50.0, left: -20.0, child: circulo),
        Container(
          padding: EdgeInsets.only(top: 70.0,right: 20),
          child: Column(
            children: <Widget>[

              Image.network("https://firebasestorage.googleapis.com/v0/b/tfg-cadena.appspot.com/o/biglogo.png?alt=media&token=5e788e35-c138-42b3-bf0a-40bf60e6a3f7"),

            ],
          ),
        )
      ],
    );



}