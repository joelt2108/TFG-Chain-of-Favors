
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:tfgflutter/src/detallesanuncio.dart';
import 'package:tfgflutter/src/miperfil.dart';
import 'package:tfgflutter/src/model/user_model.dart';
import 'package:tfgflutter/src/provider/solicitud_provider.dart';
import 'package:tfgflutter/src/provider/user_provider.dart';
import 'package:tfgflutter/src/solicitud.dart';

import 'dart:async';
import 'controller/userdata.dart' as ud;


import 'home.dart';
import 'misanuncios.dart';


int counter=0;

class RankingPage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MyRankingPage(title: 'Tablón de Anuncios'),
    );
  }
}

class MyRankingPage extends StatefulWidget {
  MyRankingPage({Key key, this.title}) : super(key: key);

  final String title;
  Timer _timer;


  @override
  _MyRankingPageState createState() => _MyRankingPageState();
}

class _MyRankingPageState extends State<MyRankingPage> {
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
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('Oflutter.com'),
              accountEmail: Text('example@gmail.com'),
              currentAccountPicture: CircleAvatar(
                child: ClipOval(
                  child: Image.network(
                    'https://e1.pngegg.com/pngimages/976/873/png-clipart-orb-os-x-icon-man-s-profile-icon-inside-white-circle.png',
                    fit: BoxFit.cover,
                    width: 90,
                    height: 90,
                  ),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(
                        'https://oflutter.com/wp-content/uploads/2021/02/profile-bg3.jpg')),
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
              leading: Icon(Icons.share),
              title: Text('Mis Solicitudes'),
              onTap: () => null,
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Chats'),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Mi Perfil'),
              onTap: () => _navigateMiPerfil(),
            ),
            ListTile(
              leading: Icon(Icons.description),
              title: Text('Ránking'),
              onTap: () => null,
            ),
            Divider(),
            ListTile(
              title: Text('Cerrar Sesión'),
              leading: Icon(Icons.exit_to_app),
              onTap: () => null,
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
                          Text(us.Puntos.toString(),style: TextStyle(fontSize: 16),), Icon(Icons.monetization_on),
                        ],
                      ),
                    ),


                  ],

                ),
              ),

      Padding(
        padding: const EdgeInsets.all(5.0)
    ),
              Container(
                child:
                Align(
                  alignment: Alignment.topRight,
                  child:
                  Text("Nº Favores:",style:TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15
                  ),),
                ),

              ),
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

          padding: const EdgeInsets.all(5.0),
          child:
          Container(
              decoration: BoxDecoration(
                color: Colors.white70,
                border: Border.all(
                  color: Colors.blueGrey,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),

              child:Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: <Widget>[

                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(15),

                        ),


                        Container(
                          padding: const EdgeInsets.only(left: 10, bottom: 10),

                          child:Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

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
                                  margin: const EdgeInsets.only(left: 20.0),
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
                                  margin: const EdgeInsets.only(left: 20.0),
                                  child:Text('${usuarios.get('Poblacion')}',
                                      style: TextStyle(
                                        fontSize:18.0,)
                                    //fontWeight: FontWeight.bold),
                                  )
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 100.0),
                              ),
                              Container(
                                  alignment: Alignment.topRight,
                                  child:
                                  Text('${usuarios.get('NFavores')}',
                                        style: TextStyle(
                                          fontSize:18.0,)
                                      //fontWeight: FontWeight.bold),
                                    ) ,
                                  )


                            ],
                          ),




                        ),

                      ],
                    ),

                  ]
              ))
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

  void _navigateDetallesAnuncio(String email){
    Navigator.of(context)
        .push(MaterialPageRoute<void>(
      builder: (context) => MyDetallesAnuncios(email),
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
