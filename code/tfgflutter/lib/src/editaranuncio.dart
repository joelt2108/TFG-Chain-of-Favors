
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tfgflutter/src/model/solicitud_model.dart';
import 'package:tfgflutter/src/model/user_model.dart';
import 'package:tfgflutter/src/provider/solicitud_provider.dart';
import 'package:tfgflutter/src/provider/user_provider.dart';
import 'package:tfgflutter/src/solicitud.dart';
import 'controller/userdata.dart' as ud;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:async';

import 'home.dart';
import 'miperfil.dart';
import 'misanuncios.dart';
ud.DataUser datosuser = ud.DataUser();
String dropdownvalue;
String FirstValue='50';


class EditarPage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MiEditarPage(datosuser.email,title: 'Tablón de Anuncios'),
    );
  }
}

class MiEditarPage extends StatefulWidget {
  MiEditarPage(this.email, {Key key, this.title}) : super(key: key);

  final String email;
  final String title;
  Timer _timer;


  @override
  _MiEditarPageState createState() => _MiEditarPageState();
}

class _MiEditarPageState extends State<MiEditarPage> {
  Usuario_Provider usuario_provider = new Usuario_Provider();
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('Mi Perfil');
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
    EdAnuncio=solicitud_provider.cargaSolicitud(widget.email);
    setState(() {});
  }


  void initState() {
    super.initState();
    EdAnuncio=solicitud_provider.cargaSolicitud(widget.email);

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
              Flexible(
                fit: FlexFit.tight,
                child: StreamBuilder(
                  stream: EdAnuncio,
                  builder:
                      (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return PageView.builder(
                        itemCount: 1,
                        itemBuilder: (context, i) =>
                            _cargarDatos(context, snapshot.data),
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
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _cargarDatos(BuildContext context, DocumentSnapshot solicitud) {
    return GestureDetector(
      key: UniqueKey(),

      child:
      Container(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.lightBlue,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Row(
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(5.0),
                      ),


                      Container(

                          child: Form(key: _formKey, child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              TextFormField(
                                  initialValue:
                                  sol.Titulo = solicitud.get('Titulo'),
                                  onChanged: (value) => sol.Titulo = value,
                                  decoration: InputDecoration(
                                    icon: Icon(Icons.title),
                                    labelText: "Título",
                                  ),
                                  validator: (value) {
                                    sol.Titulo = value;
                                    if (value.isEmpty) {
                                      return "Introduce un nombre por favor";
                                    }
                                    return null;
                                  }
                              ),
                              TextFormField(
                                  maxLines: 4,
                                  minLines: 4,
                                  keyboardType: TextInputType.multiline,
                                  initialValue:
                                  sol.Descripcion = solicitud.get('Descripcion'),
                                  onChanged: (value) =>
                                  sol.Descripcion = value,
                                  decoration: InputDecoration(
                                    icon: Icon(Icons.textsms),

                                    labelText: "Descripción",
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      //return AppLocalizations.of(context).translate('introduceapellido');
                                    }
                                    return null;
                                  }
                              ),
                              TextFormField(
                                  initialValue:
                                  sol.Poblacion =
                                      solicitud.get('Poblacion'),
                                  onChanged: (value) =>
                                  sol.Poblacion = value,
                                  decoration: InputDecoration(
                                    icon: Icon(Icons.roofing),

                                    labelText: "Provincia",
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      Text("Introduce Poblacion");
                                    }
                                    return null;
                                  }
                              ),
                              Padding(
                                  padding: const EdgeInsets.all(8.0)
                              ),
                              Row(
                                children: [
                                  Icon(Icons.monetization_on,color: Colors.grey),
                                  Padding(
                                      padding: const EdgeInsets.all(8.0)
                                  ),
                                  DropdownButton(
                                    disabledHint: Text("Puntos Ofrecidos"),
                                    style: TextStyle(color: Colors.lightBlue,fontSize: 15),
                                    items: RangosPuntos.map((String items) {
                                      return DropdownMenuItem(

                                        value: items,
                                        child: Text(items),
                                      );
                                    }).toList(),
                                    value: FirstValue,
                                    onChanged: (String newValue) {
                                      sol.Puntos=newValue;

                                      setState(() {
                                        FirstValue = newValue;

                                      });

                                    },

                                  )
                                  //sol.Puntos=pd.getrang();


                                ],
                              ),





                              Padding(
                                  padding: const EdgeInsets.all(6.0)
                              ),

                              Padding(
                                  padding: const EdgeInsets.all(10.0)
                              ),

                            ],
                          ),
                          )
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        //Center Row contents horizontally,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        //Center Row contents vertically,
                        children: [
                          ElevatedButton(


                              style: ButtonStyle(alignment: Alignment.center,
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.lightBlue),
                              ),
                              child: Text(
                                "Realizar cambios", textAlign: TextAlign
                                  .center,),

                              onPressed: () {
                                hola = solicitud.reference.id;

                                solicitud_provider.updateSolicitud(hola, sol);
                                _refresh();
                                _navigateMisAnuncios();


                                //ud.DataUser datosuser1 = ud.DataUser();
                              }
                          ),
                        ],
                      ),


                    ]),
              ),

            ],),

        ),),);
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
