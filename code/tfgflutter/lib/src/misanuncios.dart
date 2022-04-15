import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tfgflutter/src/provider/solicitud_provider.dart';
import 'package:tfgflutter/src/solicitud.dart';
import 'dart:async';
import 'controller/userdata.dart' as ud;
import 'home.dart';



class MisAnuncios extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MisAnunciosPage(title: 'Tablón de Anuncios'),
    );
  }
}

class MisAnunciosPage extends StatefulWidget {
  MisAnunciosPage({Key key, this.title}) : super(key: key);

  final String title;
  Timer _timer;


  @override
  _MisAnunciosPageState createState() => _MisAnunciosPageState();
}

class _MisAnunciosPageState extends State<MisAnunciosPage> {
  Solicitud_Provider solicitud_provider= new Solicitud_Provider();
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('Mis Anuncios');
  //final duplicateItems = List<String>.generate(10000, (i) => "Item $i");
  TextEditingController editingController = TextEditingController();
  var items = List<String>();
  Stream<QuerySnapshot> SolicitudesCargadas;
  ud.DataUser datosuser=ud.DataUser();



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
              onTap: () => null,
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
          padding: const EdgeInsets.all(5.0),
          child:Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.lightBlue,
                ),
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
                        ],
                      ),
                    )
                  ]
              ))
      ),
      onTap: () {

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

}