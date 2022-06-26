
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tfgflutter/src/model/solicitud_model.dart';
import 'package:tfgflutter/src/model/user_model.dart';
import 'package:tfgflutter/src/provider/solicitud_provider.dart';
import 'package:tfgflutter/src/provider/user_provider.dart';
import 'package:tfgflutter/src/ranking.dart';
import 'package:tfgflutter/src/solicitud.dart';
import 'chatlist.dart';
import 'controller/userdata.dart' as ud;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:async';

import 'controller/userdata.dart';
import 'home.dart';
import 'miperfil.dart';
import 'mis_solicitudes.dart';
import 'misanuncios.dart';


class Aviso extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MiAviso(title: 'Tablón de Anuncios'),
    );
  }
}

class MiAviso extends StatefulWidget {
  MiAviso( {Key key, this.title}) : super(key: key);

  final String title;
  Timer _timer;


  @override
  _MiAvisoPageState createState() => _MiAvisoPageState();
}

class _MiAvisoPageState extends State<MiAviso> {
  Usuario_Provider usuario_provider = new Usuario_Provider();
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('Aviso Legal');
  TextEditingController editingController = TextEditingController();
  var items = List<String>();
  Stream<QuerySnapshot> PerfilStream;
  ud.DataUser datosuser = ud.DataUser();
  Stream<DocumentSnapshot> EdAnuncio;
  Solicitud_Provider solicitud_provider= new Solicitud_Provider();
  List<String> RangosPuntos = <String>['50','100','150','200','250','300','350','400','450','500'];
  String hola;



  Solicitud sol = new Solicitud();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool saved = false;



  void _refresh() async {
    setState(() {});
  }


  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(

      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: customSearchBar,
        //automaticallyImplyLeading: false,
        actions: [
        ],
      ),

      drawer: Drawer(
        child:ListView(
          // Remove padding

          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture:FutureBuilder<String>(
                  future: usuario_provider.recuperaImagen(datosuser.email),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return FutureBuilder(future: usuario_provider.getImagen(snapshot.data.toString()),
                          builder: (context, snapshot2) {
                            if(snapshot2.hasData){
                              return CircleAvatar( radius: 10.0,
                                  backgroundColor: Colors.transparent,
                                  backgroundImage:(NetworkImage(snapshot2.data.toString(),

                                  )));
                            }
                            else {
                              return CircularProgressIndicator();
                            }
                          });

                    }
                    else {
                      return CircularProgressIndicator();
                    }
                  }
              ),

              accountName: FutureBuilder<String>(
                  future: usuario_provider.recuperaNombre(datosuser.email),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text("Bienvenido "+ snapshot.data.toString(),style: TextStyle(fontSize: 16),);
                    }
                    else {
                      return CircularProgressIndicator();
                    }
                  }
              ),
              accountEmail: Text(datosuser.email),

              decoration: BoxDecoration(

                  gradient:  LinearGradient(colors: <Color>[
                    //Color.fromRGBO(29, 23, 91, 1.0),
                    Colors.blue,
                    Colors.blueGrey,

                  ])

              ),
            ),
            ListTile(
              leading: Icon(Icons.library_books),
              title: Text('Tablón de anuncios'),
              onTap: () => _navigateHome(),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Mis Anuncios'),
              onTap: () => _navigateMisAnuncios(),
            ),
            ListTile(
              leading: Icon(Icons.request_page),
              title: Text('Mis Solicitudes'),
              onTap: () => _navigateMisSolicitudes(),
            ),
            ListTile(
              leading: Icon(Icons.chat),
              title: Text('Chats'),
              onTap: () => _navigateChat(),
            ),

            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Mi Perfil'),
              onTap: () => _navigateMiPerfil(),
            ),
            ListTile(
              leading: Icon(Icons.description),
              title: Text('Ránking'),
              onTap: () => _navigateRanking(),
            ),
            ListTile(
              title: Text('Aviso Legal'),
              leading: Icon(Icons.help),
              onTap: () => _navigateAviso(),
            ),
            Divider(),
            ListTile(
                title: Text('Cerrar Sesión'),
                leading: Icon(Icons.exit_to_app),
                onTap: () {
                  final _prefs = new DataUser();
                  // _timer.cancel();
                  _prefs.token = '';
                  _prefs.email = '';
                  _prefs.refreshtoken = '';
                  _prefs.name='';
                  _prefs.nuser='';
                  _prefs.puntos=0;



                  _signOut();

                  //_navigateLogin();

                }

            ),


          ],
        ),
      ),


      body:


      Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child:
            Column(children: [
              Container(
                alignment: Alignment.topRight,
                child:  AppBar(
                  toolbarHeight: 30,
                  backgroundColor: Colors.blueGrey,
                  automaticallyImplyLeading: false,
                  actions: [
                    Container( decoration: BoxDecoration(
                      //color: Colors.black12, //puntitos
                    ),
                      child:
                      Row(

                        children: [
                          Padding(padding: const EdgeInsets.all(2.0),
                          ),

                          //Text(datosuser.puntos.toString(),style: TextStyle(fontSize: 16),),
                          FutureBuilder(
                              future: usuario_provider.recuperaPuntos2(datosuser.email),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Text(snapshot.data.toString(),style: TextStyle(fontSize: 16),);
                                }
                                else {
                                  return CircularProgressIndicator();
                                }
                              }
                          ),

                          Icon(Icons.monetization_on),
                        ],
                      ),
                    ),


                  ],

                ),
              ),
              Flexible(

                child:
                  SingleChildScrollView(child: Column(children: [
                    Padding(padding: EdgeInsets.all(8)),
                    Text("Términos de Servicio y Política de Privacidad",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),

                    Padding(padding: EdgeInsets.all(4)),
                    Text("1.Titular",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13)),
                    Padding(padding: EdgeInsets.all(4)),
                    Text("Para dar cumplimiento a lo establecido en la Ley 34/2002 de 11 de julio de Servicios de la Sociedad de la Información "
                        "y de Comercio Electrónico (LSSICE), a continuación se indican los datos de información general de Chain of Favours App:"


                        ,style: TextStyle(fontSize: 15)),

                    Text("Titular: Joel Trujillo Ramos.",style: TextStyle(fontSize: 15)),
                    Text("Email: chainoffavoursapp@gmail.com",style: TextStyle(fontSize: 15)),
                    Padding(padding: EdgeInsets.all(4)),
                    Text("2.Finalidad",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13)),
                    Padding(padding: EdgeInsets.all(4)),


                    Text("Chain of Favours App es una aplicación cuya finalidad es facilitar una plataforma  de comunicación y ayuda entre usuarios para las diversas necesidades diarias que puedan tener de forma totalmente gratuita.",style: TextStyle(fontSize: 15)),
                    Padding(padding: EdgeInsets.all(4)),
                    Text("3.Condiciones de uso",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13)),
                    Padding(padding: EdgeInsets.all(4)),

                    Text("Las presentes condiciones generales rigen el uso de Chain of Favours App. El acceso y posterior utilización de esta plataforma por parte del usuario implicará su conformidad de forma expresa, plena y sin reservas, "
                        "con estas condiciones de uso. Si el usuario no estuviera de acuerdo con el contenido de este documento deberá abandonar la plataforma, no pudiendo acceder ni disponer de los servicios que ésta ofrece.",style: TextStyle(fontSize: 15)),
                    Padding(padding: EdgeInsets.all(4)),
                    Text("4.Edad del usuario",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13)),
                    Padding(padding: EdgeInsets.all(4)),

                    Text("No se permite el registro de usuarios  a menores de 18 años. El cumplimiento de este requisito es responsabilidad del usuario. Si en cualquier momento tenemos constancia o sospechamos que el usuario no cumple este requisito de edad, procederemos al borrado de su cuenta sin previo aviso.",style: TextStyle(fontSize: 15)),
                    Padding(padding: EdgeInsets.all(4)),
                    Text("5. Privacidad y Seguridad",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13)),

                    Text("Los datos personales que nos aporte mediante los formularios que ponemos a su disposición serán tratados por el equipo de Chain of Favours App.\n",style: TextStyle(fontSize: 15)),

                    Text("A continuación se describen los distintos apartados en los que se recaban y tratan datos de carácter personal.",style: TextStyle(fontSize: 15)),

                    Padding(
                        padding: const EdgeInsets.all(4.0)
                    ),
                    Text("Formulario de registro:",style: TextStyle(fontSize: 15)),

                    Text("Los datos que se recaban mediante este formulario serán utilizados con la finalidad de gestionar los usuarios registrados en nuestra plataforma y prestarle nuestros servicios. La base legal para el tratamiento de sus datos es tanto el consentimiento que otorga al registrarse, así como el cumplimiento del servicio solicitado",style: TextStyle(fontSize: 15)),
                    Padding(
                        padding: const EdgeInsets.all(4.0)
                    ),
                    Text("Permiso del almacenamiento del dispositivo:",style: TextStyle(fontSize: 15)),

                    Text("Para modificar las imágenes de perfil del usuario se deberá dotar a la aplicación de acceso al almacenamiento interno de su dispositivo Android. Esta opción es completamente opcional y no es requerida para poder usar la plataforma.",style: TextStyle(fontSize: 15)),
                    Padding(
                        padding: const EdgeInsets.all(4.0)
                    ),
                    Text("Permiso de uso de la cámara del dispositivo:",style: TextStyle(fontSize: 15)),

                    Text("Así como en el apartado anterior, se deberá dotar a la aplicación de acceso a la cámara de su dispositivo Android. Esta opción es completamente opcional y no es requerida para poder usar la plataforma.",style: TextStyle(fontSize: 15)),
                    Padding(
                        padding: const EdgeInsets.all(4.0)
                    ),
                    Text("En ningún caso, sus datos serán cedidos a terceros o utilizados para su comercialización",style: TextStyle(fontSize: 15)),
                    Padding(
                        padding: const EdgeInsets.all(4.0)
                    ),
                    Text("6.Contenidos",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13)),
                    Padding(
                        padding: const EdgeInsets.all(4.0)
                    ),
                    Text("Chain of Favours App se reserva el derecho de borrar en cualquier momento un contenido (fotografía, vídeo, texto, etc.) si estima que vulnera alguna ley vigente (derecho a la intimidad, propiedad intelectual, propiedad industrial, etc.). En caso de que algún usuario publique contenido delictivo (pedófilo, racista, insultante, difamatorio,…), dicho contenido será borrado sin previo aviso y la cuenta del responsable será inmediata y definitivamente eliminada.",style: TextStyle(fontSize: 15)),
                    Padding(
                        padding: const EdgeInsets.all(4.0)
                    ),
                    Text("7.Cookies",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13)),
                    Padding(
                        padding: const EdgeInsets.all(4.0)
                    ),
                    Text("Cuando usted se registra en nuestra app, se generan cookies propias que le identifican como usuario registrado.Estas cookies son utilizadas para identificar su cuenta de usuario y sus servicios asociados. Estas cookies se mantienen mientras usted no abandone la cuenta, o apague el dispositivo.",style: TextStyle(fontSize: 15)),

                  ],),)



              ),
            ],)


      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }



  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamed(context, 'login');

  }
  void _navigateAviso(){
    Navigator.of(context)
        .push(MaterialPageRoute<void>(
      builder: (context) => Aviso(),
    )).then( (var value) {
      _refresh();
    });
  }
  void _navigateRanking(){
    Navigator.of(context)
        .push(MaterialPageRoute<void>(
      builder: (context) => RankingPage(),
    )).then( (var value) {
      _refresh();
    });
  }
  void _navigateChat(){
    Navigator.of(context)
        .push(MaterialPageRoute<void>(
      builder: (context) => ChatList(),
    )).then( (var value) {
      _refresh();
    });
  }
  void _navigateMisSolicitudes(){
    Navigator.of(context)
        .push(MaterialPageRoute<void>(
      builder: (context) => MisSolicitudes(),
    )).then( (var value) {
      _refresh();
    });
  }


  void _navigateMisAnuncios() {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(
      builder: (context) => MisAnuncios(),
    )).then((var value) {
      _refresh();
    });
  }
  void _navigateHome(){
    Navigator.of(context)
        .push(MaterialPageRoute<void>(
      builder: (context) => HomePage(),
    )).then( (var value) {
      _refresh();
    });
  }
  void _navigateMiPerfil(){
    Navigator.of(context)
        .push(MaterialPageRoute<void>(
      builder: (context) => PerfilPage(),
    )).then( (var value) {
      _refresh();
    });
  }





}
