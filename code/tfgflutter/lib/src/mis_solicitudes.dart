import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tfgflutter/src/detallesanuncio.dart';
import 'package:tfgflutter/src/editaranuncio.dart';
import 'package:tfgflutter/src/mianuncio.dart';
import 'package:tfgflutter/src/provider/solicitud_provider.dart';
import 'package:tfgflutter/src/provider/user_provider.dart';
import 'package:tfgflutter/src/ranking.dart';
import 'package:tfgflutter/src/solicitud.dart';
import 'dart:async';
import 'avisolegal.dart';
import 'chatlist.dart';
import 'controller/userdata.dart' as ud;
import 'controller/userdata.dart';
import 'home.dart';
import 'miperfil.dart';
import 'misanuncios.dart';



class MisSolicitudes extends StatefulWidget {
  MisSolicitudes({Key key, this.title}) : super(key: key);

  final String title;
  Timer _timer;


  @override
  _MisSolicitudesPageState createState() => _MisSolicitudesPageState();
}

class _MisSolicitudesPageState extends State<MisSolicitudes> {
  Solicitud_Provider solicitud_provider= new Solicitud_Provider();
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('Mis Solicitudes');
  //final duplicateItems = List<String>.generate(10000, (i) => "Item $i");
  TextEditingController editingController = TextEditingController();
  var items = List<String>();
  Stream<QuerySnapshot> SolicitudesCargadas;
  Stream<QuerySnapshot> SolicitantesCargados;
  Usuario_Provider usuario_provider=Usuario_Provider();

  ud.DataUser datosuser=ud.DataUser();
  String id;




  void _incrementCounter() {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(
      builder: (context) => CreateSolicitud(),
    )).whenComplete(() => _refresh());
  }

  void _refresh() async {
    setState(() {});
    SolicitudesCargadas=solicitud_provider.cargarMisAnuncios(datosuser.email);




  }


  void initState() {
    super.initState();

    SolicitudesCargadas=solicitud_provider.cargarMisAnuncios(datosuser.email);

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
                  padding: const EdgeInsets.all(3.0)
              ),
              StreamBuilder(
                  stream: solicitud_provider.cargarSolicitudesFinalizadas(datosuser.email),
                  builder:
                      (BuildContext context1, AsyncSnapshot<QuerySnapshot> snapshot3) {
                    if (snapshot3.hasData) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot3.data.size,
                        itemBuilder: (context, i) =>
                            _cargarDatos3(
                                context, snapshot3.data.docs[i], i),


                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }


              ),
              Padding(
                  padding: const EdgeInsets.all(3.0)
              ),
               StreamBuilder(
                  stream: solicitud_provider.cargarSolicitudesAsignadas(datosuser.email),
                  builder:
                      (BuildContext context1, AsyncSnapshot<QuerySnapshot> snapshot1) {
                        if (snapshot1.hasData) {
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot1.data.size,
                            itemBuilder: (context, i) =>
                                _cargarDatos(
                                    context, snapshot1.data.docs[i], i),


                          );
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }


              ),
              Padding(
                  padding: const EdgeInsets.all(3.0)
              ),
               StreamBuilder(
                    stream: solicitud_provider.cargarSolicitudesPendientes(datosuser.email),
                    builder:
                        (BuildContext context2, AsyncSnapshot<QuerySnapshot> snapshot2) {
                      if (snapshot2.hasData) {
                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot2.data.size,
                          itemBuilder: (context, i) =>
                              _cargarDatos2(
                                  context, snapshot2.data.docs[i], i),


                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }

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
       // This trailing comma makes auto-formatting nicer for build methods.
    );


  }
  Widget _cargarDatos(BuildContext context, QueryDocumentSnapshot asignadas, int index){


if(asignadas.data()!=null) {
  return Column(

    children: [
      if(index==0)
        Text("Aceptadas:",textAlign: TextAlign.start,style: TextStyle(fontSize: 18,fontWeight:FontWeight.bold),),
      GestureDetector(
        child:
        Container(

            padding: const EdgeInsets.all(5.0),
            child:Container(
                decoration: BoxDecoration(
                  color: Colors.black26,

                  borderRadius: BorderRadius.circular(14.0),
                ),
                child:Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Padding(
                              padding: const EdgeInsets.all(4.0)
                          ),

                        ],
                      ),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                                padding: const EdgeInsets.all(2.0)
                            ),
                            Row(
                              children: [
                                Container(
                                  //padding: const EdgeInsets.only(left: 10),
                                  child: FutureBuilder<String>(
                                      future: solicitud_provider.getImagen('${asignadas.get('Image')}'),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return CircleAvatar( radius: 15.0,
                                              backgroundColor: Colors.transparent,
                                              backgroundImage:(NetworkImage(snapshot.data.toString(),

                                              )));
                                        }
                                        else {
                                          return CircularProgressIndicator();
                                        }
                                      }
                                  ),
                                ),

                                Padding(
                                    padding: const EdgeInsets.all(2.0)
                                ),
                                Flexible(
                                  child:Text("El usuario ${asignadas.get('NUser')} ha aceptado tu solicitud por el favor: '${asignadas.get('Titulo')}'",
                                    style: TextStyle(
                                        fontSize:18.0,
                                        fontStyle: FontStyle.italic),
                                  ),
                                ) ,

                              ],
                            ),


                            //SizedBox(width: 1), // give it width






                            Padding(
                                padding: const EdgeInsets.all(1.0)
                            ),

                          ],
                        ),
                      )
                    ]
                ))
        ),
        onTap: () {

        },
      )
    ],
  );
}
  }

  Widget _cargarDatos2(BuildContext context, QueryDocumentSnapshot pendientes, int index){


    if(pendientes.data()!=null) {
      return Column(

        //crossAxisAlignment: CrossAxisAlignment.start,


        children: [
          Padding(padding: EdgeInsets.only(left: 5)),
          if(index==0)
            Text("Pendientes:",textAlign: TextAlign.start,style: TextStyle(fontSize: 18,fontWeight:FontWeight.bold),),

          GestureDetector(
            child:
            Container(

                padding: const EdgeInsets.all(5.0),
                child:Container(
                    height: 48.0,
                    decoration: BoxDecoration(
                      color: Colors.black26,



                      borderRadius: BorderRadius.circular(14.0),
                    ),
                    child:Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Padding(
                                  padding: const EdgeInsets.all(4.0)
                              ),

                            ],
                          ),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                    padding: const EdgeInsets.all(5.0)
                                ),
                                Row(
                                  children: [
                                    Container(
                                      //padding: const EdgeInsets.only(left: 10),
                                      child: FutureBuilder<String>(
                                          future: solicitud_provider.getImagen('${pendientes.get('Image')}'),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return CircleAvatar( radius: 15.0,
                                                  backgroundColor: Colors.transparent,
                                                  backgroundImage:(NetworkImage(snapshot.data.toString(),

                                                  )));
                                            }
                                            else {
                                              return CircularProgressIndicator();
                                            }
                                          }
                                      ),
                                    ),

                                    Padding(
                                        padding: const EdgeInsets.all(7.0)
                                    ),
                                    Flexible(
                                      child:Text( pendientes.get('Titulo') ,
                                        style: TextStyle(
                                            fontSize:18.0,
                                            ),
                                      ),
                                    ) ,

                                  ],
                                ),


                                //SizedBox(width: 1), // give it width






                                Padding(
                                    padding: const EdgeInsets.all(1.0)
                                ),

                              ],
                            ),
                          )
                        ]
                    ))
            ),
            onTap: () {

            },
          )
        ],
      );
    }
  }

  Widget _cargarDatos3(BuildContext context, QueryDocumentSnapshot finalizadas, int index) {

    if(finalizadas.data()!=null) {
      return Column(

        children: [
          if(index==0)
            Text("Finalizadas:",textAlign: TextAlign.start,style: TextStyle(fontSize: 18,fontWeight:FontWeight.bold),),
          GestureDetector(
            child:
            Container(

                padding: const EdgeInsets.all(5.0),
                child:Container(
                    decoration: BoxDecoration(
                      color: Colors.black26,

                      borderRadius: BorderRadius.circular(14.0),
                    ),
                    child:Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Padding(
                                  padding: const EdgeInsets.all(4.0)
                              ),

                            ],
                          ),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                    padding: const EdgeInsets.all(2.0)
                                ),
                                Row(
                                  children: [
                                    Container(
                                      //padding: const EdgeInsets.only(left: 10),
                                      child: FutureBuilder<String>(
                                          future: solicitud_provider.getImagen('${finalizadas.get('Image')}'),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return CircleAvatar( radius: 15.0,
                                                  backgroundColor: Colors.transparent,
                                                  backgroundImage:(NetworkImage(snapshot.data.toString(),

                                                  )));
                                            }
                                            else {
                                              return CircularProgressIndicator();
                                            }
                                          }
                                      ),
                                    ),

                                    Padding(
                                        padding: const EdgeInsets.all(2.0)
                                    ),
                                    Flexible(
                                      child:Text("¡Felicidades! Has completado el favor '${finalizadas.get('Titulo')}', obteniendo ${finalizadas.get('Puntos')} puntos.",
                                        style: TextStyle(
                                            fontSize:18.0,
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ) ,

                                  ],
                                ),


                                //SizedBox(width: 1), // give it width






                                Padding(
                                    padding: const EdgeInsets.all(1.0)
                                ),

                              ],
                            ),
                          )
                        ]
                    ))
            ),
            onTap: () {

            },
          )
        ],
      );
    }
  }

    cargarMisAnuncios(){
    //ud.DataUser datosuser = ud.DataUser();

    SolicitudesCargadas = solicitud_provider.cargarMisAnuncios(datosuser.email);

    //selectedReportList.clear();
    //selectedReportListPreferencias.clear();
    //Navigator.of(context).pop();
  }

  void _navigateMisAnuncios(){
    Navigator.of(context)
        .push(MaterialPageRoute<void>(
      builder: (context) => MisAnuncios(),
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
  void _navigateDetallesAnuncio(String email){
    Navigator.of(context)
        .push(MaterialPageRoute<void>(
      builder: (context) => EditarPage(email),
    )).then( (var value) {
      _refresh();
    });
  }

  void _navigateDetallesMiAnuncio(String email){
    Navigator.of(context)
        .push(MaterialPageRoute<void>(
      builder: (context) => MiAnuncio(email),
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
  void _navigateMiPerfil(){
    Navigator.of(context)
        .push(MaterialPageRoute<void>(
      builder: (context) => PerfilPage(),
    )).then( (var value) {
      _refresh();
    });
  }


  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamed(context, 'login');

  }

}