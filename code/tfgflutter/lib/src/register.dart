import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'controller/userdata.dart' as ud;
import 'package:tfgflutter/main.dart';
import 'dataregister.dart';
import 'package:tfgflutter/src/provider/user_provider.dart';

import 'login.dart';
import 'model/user_model.dart';




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
  final TextEditingController controller= TextEditingController();

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _poblacionController = TextEditingController();
  final TextEditingController _dniController = TextEditingController();
  final TextEditingController _nuserController = TextEditingController();
  Usuario usuario=new Usuario();
  bool _saved=false;
  bool isChecked=false;

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
                                            onChanged: (value) => usuario.Nombre = value,

                                            validator: (String value) {
                                              if (value.isEmpty) {
                                                return ;
                                              }
                                              return null;
                                            },
                                          ),
                                          Text("Apellidos"),
                                          TextFormField(
                                            decoration: InputDecoration(
                                            ),
                                            controller: _apellidoController,
                                            onChanged: (value) => usuario.Apellido = value,
                                            validator: (String value) {
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
                                          Text("Nombre de Usuario"),
                                          TextFormField(
                                            decoration: InputDecoration(
                                            ),
                                            controller: _nuserController,
                                            onChanged: (value) => usuario.NUser = value,
                                            validator: (String value) {
                                              return null;
                                            },
                                          ),
                                          Text("Provincia"),
                                          TextFormField(
                                            controller: _poblacionController,
                                            onChanged: (value) => usuario.Poblacion = value,
                                            decoration: InputDecoration(
                                            ),
                                            validator: (String value) {
                                              if (value.isEmpty) {
                                              }
                                              return null;
                                            },
                                          ),
                                          Text("Fecha de nacimiento"),
                                          GestureDetector(
                                            onTap: () {
                                              showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime(DateTime.now().year - 100),
                                                  lastDate: DateTime(DateTime.now().year + 1))
                                                  .then((value) {
                                                DateTime today = DateTime.now();
                                                int year= today.year - value.day;
                                                int mes= today.month - value.month;
                                                int dia= today.day - value.day;
                                                controller.text =
                                                '${value.day.toString()}/${value.month.toString()}/${value.year.toString()}';
                                              });
                                            },
                                            child: TextField(
                                              controller: this.controller,
                                              enabled: false,
                                            ),
                                          ),
                                          Text("DNI"),
                                          TextFormField(
                                            decoration: InputDecoration(
                                            ),
                                            controller: _dniController,
                                            onChanged: (value) => usuario.DNI = value,
                                            validator: (String value) {
                                              return null;
                                            },
                                          ),
                                          Padding(
                                              padding: const EdgeInsets.all(2.0)
                                          ),

                                     Row(
                                       mainAxisAlignment: MainAxisAlignment.start,
                                       children: [
                                         Checkbox(

                                           checkColor: Colors.white,

                                           value: isChecked,
                                           onChanged: (bool value) {
                                             setState(() {
                                               isChecked = value;
                                             });
//"Acepto los Términos de servicio y la Política de privacidad"
                                           },
                                         ),
                                         Flexible(child: GestureDetector(

                                           onTap: () { TerminosCond();},
                                           child: Text.rich(TextSpan(text:"Acepto los ", children: <TextSpan>[
                                             TextSpan(text: "Términos de servicio y la Política de privacidad",style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline)),
                                           ] ),)


                                         ),),

                                       ],
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
                                              child:  Text("Siguiente"),
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
    if(isChecked==true){

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
            usuario.Image="https://www.nicepng.com/png/detail/128-1280406_view-user-icon-png-user-circle-icon-png.png";


            _userEmail = user.email;
            final token = await user.getIdToken();
            datosuser.token = token.toString();
            datosuser.email=_emailController.text;
            datosuser.refreshtoken=user.refreshToken;
            datosuser.name=_nombreController.text;
            usuario.Solicitudes=[];
            _success = true;
            _userEmail = user.email;
            usuario.id=datosuser.email;
            usuario.Chats= [];
            Usuario_Provider upr = new Usuario_Provider();
            upr.saveUsuario(usuario);


            setState(() {
              _saved = true;
            });
            Navigator.of(context)
                .push(MaterialPageRoute<void>(
              builder: (context) => LoginPage(),
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
    else{
        Terminos();
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

  Future<bool> Terminos() async {
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text("Debes aceptar los Términos de servicio y la Política de privacidad para continuar"),

        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text("Ok"),
          ),
        ],
      ),
    )) ?? false;
  }

  Future<bool> TerminosCond() async {
    return (await showDialog(
      context: context,
      builder: (context) =>
      SingleChildScrollView(child: new AlertDialog(
        title: new Text("Términos legales y Política de privacidad"),



        actions: <Widget>[
          Text("1.Titular \n Para dar cumplimiento a lo establecido en la Ley 34/2002 de 11 de julio de Servicios de la Sociedad de la Información "
              "y de Comercio Electrónico (LSSICE), a continuación se indican los datos de información general de Chain of Favours App:\n"
              "Titular: Joel Trujillo Ramos. \n"
              "Email: chainoffavoursapp@gmail.com\n"

          ),
          Text("2. Finalidad\n Chain of Favours App es una aplicación cuya finalidad es facilitar una plataforma  de comunicación y ayuda entre usuarios para las diversas necesidades diarias que puedan tener de forma totalmente gratuita."),

          Text("3. Condiciones de uso\n Las presentes condiciones generales rigen el uso de Chain of Favours App. El acceso y posterior utilización de esta plataforma por parte del usuario implicará su conformidad de forma expresa, plena y sin reservas, "
              "con estas condiciones de uso. Si el usuario no estuviera de acuerdo con el contenido de este documento deberá abandonar la plataforma, no pudiendo acceder ni disponer de los servicios que ésta ofrece."),
          Text("  4. Edad del usuario\n No se permite el registro de usuarios  a menores de 18 años. El cumplimiento de este requisito es responsabilidad del usuario. Si en cualquier momento tenemos constancia o sospechamos que el usuario no cumple este requisito de edad, procederemos al borrado de su cuenta sin previo aviso."),

          Text("5. Privacidad y Seguridad\n Los datos personales que nos aporte mediante los formularios que ponemos a su disposición serán tratados por el equipo de Chain of Favours App\n"),

          Text("A continuación se describen los distintos apartados en los que se recaban y tratan datos de carácter personal."),

          Padding(
              padding: const EdgeInsets.all(2.0)
          ),
          Text("Formulario de registro:\n Los datos que se recaban mediante este formulario serán utilizados con la finalidad de gestionar los usuarios registrados en nuestra plataforma y prestarle nuestros servicios. La base legal para el tratamiento de sus datos es tanto el consentimiento que otorga al registrarse, así como el cumplimiento del servicio solicitado"),
          Padding(
              padding: const EdgeInsets.all(2.0)
          ),
          Text("Permiso del almacenamiento del dispositivo:\n Para modificar las imágenes de perfil del usuario se deberá dotar a la aplicación de acceso al almacenamiento interno de su dispositivo Android. Esta opción es completamente opcional y no es requerida para poder usar la plataforma."),
          Padding(
              padding: const EdgeInsets.all(2.0)
          ),
          Text("Permiso de uso de la cámara del dispositivo\n  Así como en el apartado anterior, se deberá dotar a la aplicación de acceso a la cámara de su dispositivo Android. Esta opción es completamente opcional y no es requerida para poder usar la plataforma."),
          Padding(
              padding: const EdgeInsets.all(2.0)
          ),
          Text("En ningún caso, sus datos serán cedidos a terceros o utilizados para su comercialización"),

          Text("6. Contenidos\n Chain of Favours App se reserva el derecho de borrar en cualquier momento un contenido (fotografía, vídeo, texto, etc.) si estima que vulnera alguna ley vigente (derecho a la intimidad, propiedad intelectual, propiedad industrial, etc.). En caso de que algún usuario publique contenido delictivo (pedófilo, racista, insultante, difamatorio,…), dicho contenido será borrado sin previo aviso y la cuenta del responsable será inmediata y definitivamente eliminada."),

          Text("7. Cookies\n  Cuando usted se registra en nuestra app, se generan cookies propias que le identifican como usuario registrado.Estas cookies son utilizadas para identificar su cuenta de usuario y sus servicios asociados. Estas cookies se mantienen mientras usted no abandone la cuenta, o apague el dispositivo."),




          TextButton(

            onPressed: () => Navigator.of(context).pop(false),
            child: new Text("Ok"),
          ),
        ],
      ),),

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

  void _validateRegister(){
    Navigator.of(context)
        .push(MaterialPageRoute<void>(
      builder: (context) => RegistroUserPage(),
    )).then( (var value) {
      setState(() => {
        _refresh()
      });
    });
  }
}