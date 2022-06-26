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
import 'mis_solicitudes.dart';




class MisAnuncios extends StatefulWidget {
  MisAnuncios({Key key, this.title}) : super(key: key);

  final String title;
  Timer _timer;


  @override
  _MisAnunciosPageState createState() => _MisAnunciosPageState();
}

class _MisAnunciosPageState extends State<MisAnuncios> {
  Solicitud_Provider solicitud_provider= new Solicitud_Provider();
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('Mis Anuncios');
  //final duplicateItems = List<String>.generate(10000, (i) => "Item $i");
  TextEditingController editingController = TextEditingController();
  var items = List<String>();
  Stream<QuerySnapshot> SolicitudesCargadas;
  Stream<QuerySnapshot> SolicitantesCargados;
  Usuario_Provider usppr=Usuario_Provider();
  int mispuntos;

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
      backgroundColor: Colors.grey,

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
                  future: usppr.recuperaImagen(datosuser.email),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return FutureBuilder(future: usppr.getImagen(snapshot.data.toString()),
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
                  future: usppr.recuperaNombre(datosuser.email),
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
                color: Colors.grey,
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
                              future: usppr.recuperaPuntos2(datosuser.email),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {

                                  mispuntos=snapshot.data;
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
                fit: FlexFit.tight,
                child: StreamBuilder(
                  stream: SolicitudesCargadas,
                  builder:
                      (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {

                      return ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, i) => _cargarDatos(context, snapshot.data.docs[i]),
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
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );


  }
  Widget _cargarDatos(BuildContext context, QueryDocumentSnapshot solicitud){
    return GestureDetector(

      key: UniqueKey(),
      child:
      Container(
        color: Colors.grey,
          padding: const EdgeInsets.all(5.0),
          child:Container(
              decoration: BoxDecoration(
                color: Colors.white70,

                borderRadius: BorderRadius.circular(10.0),
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
                              padding: const EdgeInsets.all(12.0)
                          ),



                            Container(
                                margin: const EdgeInsets.only(left: 20.0),
                                child:Text('${solicitud.get('Titulo')}',
                                  style: TextStyle(
                                      fontSize:18.0,
                                      fontWeight: FontWeight.bold),
                                )
                            ),
                            //SizedBox(width: 1), // give it width





                          Padding(
                              padding: const EdgeInsets.all(1.0)
                          ),
                          Container(
                              margin: const EdgeInsets.only(left: 20.0),
                              child:Text('${solicitud.get('Descripcion')}',
                                  style: TextStyle(
                                    fontSize:18.0,)
                                //fontWeight: FontWeight.bold),
                              )
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 20.0),
                            //child:Text(tipoC)
                          ),
                          Padding(
                              padding: const EdgeInsets.all(1.0)
                          ),
                          Container(
                              margin: const EdgeInsets.only(left: 20.0),
                              child:Text('${solicitud.get('Poblacion')}')
                          ),
                          Padding(
                              padding: const EdgeInsets.all(1.0)
                          ),
                          Container(
                              margin: const EdgeInsets.only(left: 20.0),
                              child:Text('${solicitud.get('Puntos')}'+" Puntos")
                          ),
                          Padding(
                              padding: const EdgeInsets.all(1.0)
                          ),
                          Row(children: [
                            CupertinoButton(  padding: EdgeInsets.only(left:20),
                                onPressed: (){
                                  if(solicitud.get("Estado")=="Sin asignar") {

                                    id=solicitud.id;
                                    _navigateDetallesAnuncio(id);
                                  }
                                  else{
                                    mostrarAviso(context,"Lo sentimos, pero no puedes editar este anuncio porque ya ha sido asignado"
                                        " a otro usuario");
                                  }
                                }, child: Icon(Icons.edit,color: Colors.grey,size: 20,)),
                            //SizedBox(width: 1), // give it width

                            CupertinoButton(
                                onPressed: () async {

                                  if(solicitud.get("Estado")=="Sin asignar"){
                                    id=solicitud.id;

                                    int nuevosp= mispuntos + int.parse(solicitud.get("Puntos"));
                                    QuerySnapshot querySnap = await FirebaseFirestore.instance.collection('Usuario').where('id',isEqualTo: datosuser.email).get();
                                    QueryDocumentSnapshot doc = querySnap.docs[0];
                                    DocumentReference docRef = doc.reference;
                                    usppr.updatePuntos(docRef.id, nuevosp);
                                    solicitud_provider.eliminarAnuncio(id);
                                    _refresh();
                                  }
                                  else{
                                    mostrarAviso(context,"Lo sentimos, pero no puedes eliminar este anuncio porque ya ha sido asignado"
                                        " a otro usuario");
                                  }

                                }, child: Icon(Icons.delete,color: Colors.grey,size: 20,)),
                          ],),
                        ],
                      ),
                    )
                  ]
              ))
      ),
      onTap: () {
        _navigateDetallesMiAnuncio(solicitud.id);
      },
    );

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

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamed(context, 'login');

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

}