
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:tfgflutter/src/detallesanuncio.dart';
import 'package:tfgflutter/src/miperfil.dart';
import 'package:tfgflutter/src/model/user_model.dart';
import 'package:tfgflutter/src/provider/solicitud_provider.dart';
import 'package:tfgflutter/src/provider/user_provider.dart';
import 'package:tfgflutter/src/solicitud.dart';

import 'dart:async';
import 'avisolegal.dart';
import 'chatlist.dart';
import 'controller/userdata.dart' as ud;


import 'controller/userdata.dart';
import 'home.dart';
import 'mis_solicitudes.dart';
import 'misanuncios.dart';


int counter=0;


class RankingPage extends StatefulWidget {
  RankingPage({Key key, this.title}) : super(key: key);

  final String title;
  Timer _timer;


  @override
  _MyRankingPageState createState() => _MyRankingPageState();
}

class _MyRankingPageState extends State<RankingPage> {
  Solicitud_Provider solicitud_provider= new Solicitud_Provider();
  Usuario_Provider usuario_provider= new Usuario_Provider();
  Icon customIcon = const Icon(Icons.search);
  Icon customIcon2 = const Icon(Icons.edit_attributes_outlined);

  Widget customSearchBar = const Text('Tablón de anuncios');
  //final duplicateItems = List<String>.generate(10000, (i) => "Item $i");
  TextEditingController editingController = TextEditingController();
  var items = List<String>();
  Stream<QuerySnapshot> SolicitudesCargadas;
  Stream<QuerySnapshot> UsuarioCargado;
  Stream<QuerySnapshot> RankingLoad;

  ud.DataUser datosuser = ud.DataUser();
  Usuario us=new Usuario();
  int i=0;




  String id;


  void _refresh()  {
    SolicitudesCargadas = solicitud_provider.cargarSolicitudes();
    UsuarioCargado=usuario_provider.getUsuario(datosuser.email);
    RankingLoad=usuario_provider.getRanking();
    setState(() {});

  }


  void initState() {
    super.initState();
    SolicitudesCargadas = solicitud_provider.cargarSolicitudes();
    RankingLoad=usuario_provider.getRanking();


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
      backgroundColor: Colors.white70,


      appBar: AppBar(
        title: Text("Ranking de Usuarios"),
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.//automaticallyImplyLeading: false,

      ),

      drawer: Drawer(
        child: ListView(
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
        child: Column(

            children: <Widget>[
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


      Padding(
        padding: const EdgeInsets.all(5.0)
    ),
              SingleChildScrollView(child: Container(

                  child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("Pos.",style: TextStyle(fontWeight: FontWeight.bold),),
                      Padding(padding: EdgeInsets.only(right: 3)),

                      Text("Usuario",style: TextStyle(fontWeight: FontWeight.bold),),
                      Padding(padding: EdgeInsets.only(left: 1)),

                      Text("Provincia",style: TextStyle(fontWeight: FontWeight.bold),),


                      Text("Nº Favores",style: TextStyle(fontWeight: FontWeight.bold),)

                    ],)

              ) ,),


              Flexible(
                fit: FlexFit.tight,
                child: StreamBuilder(
                  stream: RankingLoad,
                  builder:
                      (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                       i=0;
                      return ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) =>

                          _cargarDatos(context, snapshot.data.docs[index],index+1),


                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),

              ),
            ]
          // Column is also layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).




        ),
      ),
    );


  }
  Widget _cargarDatos(BuildContext context, QueryDocumentSnapshot usuarios,int index){
    return GestureDetector(
      key: UniqueKey(),

      child:
      Container(
          //alignment: Alignment.center,
          padding: const EdgeInsets.all(5.0),
          child:
          Container(
              //alignment: Alignment.center,

              decoration: BoxDecoration(
                color: Colors.white70,
                border: Border.all(
                  color: Colors.blueGrey,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),

              child:

                    Column(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(15),

                        ),


                        Container(
                          padding: const EdgeInsets.only(left: 10, bottom: 10),

                          child:Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                            children: [
                              Text( index.toString() + "º "),



                              FutureBuilder<String>(
                                  future: usuario_provider.getImagen('${usuarios.get('Image')}'),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return CircleAvatar( radius: 20.0,
                                          backgroundColor: Colors.transparent,
                                          backgroundImage:(NetworkImage(snapshot.data.toString(),

                                          )));
                                    }
                                    else {
                                      return CircularProgressIndicator();
                                    }
                                  }
                              ),
                              Container(
                                  margin: const EdgeInsets.only(left: 5.0),
                                  child:Text('${usuarios.get('NUser')}',
                                    style: TextStyle(
                                        fontSize:18.0,
                                        fontWeight: FontWeight.bold),
                                  )
                              ),

                              Padding(
                                  padding: const EdgeInsets.all(1.0)
                              ),
                              Container(
                                  margin: const EdgeInsets.only(left: 10.0),
                                  child:Text('${usuarios.get('Poblacion')}',
                                      style: TextStyle(
                                        fontSize:18.0,)
                                    //fontWeight: FontWeight.bold),
                                  )
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15),

                              ),



                              Text('${usuarios.get('NFavores')}',
                                              style: TextStyle(
                                                fontSize:18.0,)
                                            //fontWeight: FontWeight.bold),
                                          ) ,






                            ],
                          ),




                        ),

                      ],
                    ),


              )
      ),
      onTap: () {

      },
    );



  }


  void _navigateMisAnuncios(){
    Navigator.of(context)
        .push(MaterialPageRoute<void>(
      builder: (context) => MisAnuncios(),
    )).then( (var value) {
      _refresh();
    });
  }
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamed(context, 'login');

  }
  void _navigateDetallesAnuncio(String email){
    Navigator.of(context)
        .push(MaterialPageRoute<void>(
      builder: (context) => DetallesAnuncios(email),
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
  void _navigateChat(){
    Navigator.of(context)
        .push(MaterialPageRoute<void>(
      builder: (context) => ChatList(),
    )).then( (var value) {
      _refresh();
    });
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
  Future<Widget> _showMyDialog()  {
    return showDialog<Widget>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Preferencias de Búsqueda'),
          content: SingleChildScrollView(
            child: Column(children: [
              Row(
                children: [
                  Text("Provincia:"),
                  MyDialog(),
                ],
              ),
              Padding(
                  padding: const EdgeInsets.all(3.0)
              ),
              Row(
                children: [
                  Text("Puntos ofrecidos:"),
                  MyDialogP(),
                ],
              ),


            ],),




          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Guardar'),
              onPressed: () {

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}
