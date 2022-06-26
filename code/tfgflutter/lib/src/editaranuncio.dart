
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
import 'avisolegal.dart';
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
ud.DataUser datosuser = ud.DataUser();
String dropdownvalue;
String FirstValue='50';
int mispuntos;




class EditarPage extends StatefulWidget {
  EditarPage(this.email, {Key key, this.title}) : super(key: key);

  final String email;
  final String title;
  Timer _timer;


  @override
  _MiEditarPageState createState() => _MiEditarPageState();
}

class _MiEditarPageState extends State<EditarPage> {
  Usuario_Provider usuario_provider = new Usuario_Provider();
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('Editar Favor');
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
        color: Colors.white70,
        padding: const EdgeInsets.all(5.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white70,

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
                              Padding(
                                padding: EdgeInsets.all(5.0),
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
                                      return "Introduce una pequeña descripción por favor";
                                    }
                                    return null;
                                  }
                              ),
                              Padding(
                                padding: EdgeInsets.all(5.0),
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
                                  padding: const EdgeInsets.all(15.0)
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



                              onPressed: () async {

                                if(sol.Puntos==''){
                                  sol.Puntos=solicitud.get("Puntos");
                                }

                                if(int.parse(sol.Puntos)<=mispuntos){
                                  QuerySnapshot querySnap = await FirebaseFirestore.instance.collection('Usuario').where('id',isEqualTo: datosuser.email).get();
                                  QueryDocumentSnapshot doc = querySnap.docs[0];
                                  DocumentReference docRef = doc.reference;
                                  if(int.parse(sol.Puntos)>int.parse(solicitud.get("Puntos")))
                                  {
                                    int resultado=int.parse(sol.Puntos)-int.parse(solicitud.get("Puntos"));
                                    int resta=mispuntos-resultado;


                                    usuario_provider.updatePuntos(docRef.id, resta);
                                  }
                                  if(int.parse(sol.Puntos)<int.parse(solicitud.get("Puntos")))
                                    {
                                      int resultado=int.parse(solicitud.get("Puntos"))-int.parse(sol.Puntos);
                                      int suma=mispuntos+resultado;


                                      usuario_provider.updatePuntos(docRef.id, suma);
                                    }
                                  hola = solicitud.reference.id;

                                  solicitud_provider.updateSolicitud(hola, sol);
                                  _refresh();
                                  _navigateMisAnuncios();
                                }
                                else{
                                  mostrarAviso(context, "Lo sentimos, no tienes los puntos suficientes");

                                }




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





}
