

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tfgflutter/src/model/user_model.dart';
import 'package:tfgflutter/src/provider/solicitud_provider.dart';
import 'package:tfgflutter/src/provider/user_provider.dart';
import 'package:tfgflutter/src/ranking.dart';
import 'package:tfgflutter/src/solicitud.dart';
import 'avisolegal.dart';
import 'chatlist.dart';
import 'controller/userdata.dart' as ud;
import 'package:image_picker/image_picker.dart';
import 'dart:ffi';
import 'dart:io';
import 'package:intl/intl.dart';

import 'package:image_cropper/image_cropper.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:async';

import 'controller/userdata.dart';
import 'home.dart';
import 'mis_solicitudes.dart';
import 'misanuncios.dart';


class PerfilPage extends StatefulWidget {
  PerfilPage({Key key, this.title}) : super(key: key);


  final String title;
  Timer _timer;


  @override
  _MiPerfilPageState createState() => _MiPerfilPageState();
}

class _MiPerfilPageState extends State<PerfilPage> {
  Usuario_Provider usuario_provider = new Usuario_Provider();
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('Mi Perfil');
  TextEditingController editingController = TextEditingController();
  var items = List<String>();
  Stream<QuerySnapshot> PerfilStream;
  ud.DataUser datosuser = ud.DataUser();

  Usuario usuario = new Usuario();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool saved = false;
  String hola;
  File imageFile;

  bool hasImg = false;


  void _incrementCounter() {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(
      builder: (context) => CreateSolicitud(),
    )).whenComplete(() => _refresh());
  }

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
              Flexible(
                fit: FlexFit.tight,
                child: StreamBuilder(
                  stream: usuario_provider.getUsuario(datosuser.email),
                  builder:
                      (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, i) =>
                            _cargarDatos(context, snapshot.data.docs[i]),
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

  Widget _cargarDatos(BuildContext context, QueryDocumentSnapshot solicitud) {
    return GestureDetector(
      key: UniqueKey(),

      child:
      Container(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          decoration: BoxDecoration(
            //color: Colors.white,

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
                            crossAxisAlignment: CrossAxisAlignment.center,

                            children: [

                              FutureBuilder<String>(
                                  future: usuario_provider.recuperaImagen(datosuser.email),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return FutureBuilder(future: usuario_provider.getImagen(snapshot.data.toString()),
                                          builder: (context, snapshot2) {
                                            if(snapshot2.hasData){
                                              return CircleAvatar( radius: 50.0,
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
                              TextFormField(
                                  initialValue:
                                  usuario.Nombre = solicitud.get('Nombre'),
                                  onChanged: (value) => usuario.Nombre = value,
                                  decoration: InputDecoration(
                                    icon: Icon(Icons.person),
                                    labelText: "Nombre",
                                  ),
                                  validator: (value) {
                                    usuario.Nombre = value;
                                    if (value.isEmpty) {
                                      return "Introduce un nombre por favor";
                                    }
                                    return null;
                                  }
                              ),Padding(
                                  padding: const EdgeInsets.all(10.0)
                              ),
                              TextFormField(
                                  initialValue:
                                  usuario.Apellido = solicitud.get('Apellido'),
                                  onChanged: (value) =>
                                  usuario.Apellido = value,
                                  decoration: InputDecoration(
                                    icon: Icon(Icons.person),

                                    labelText: "Apellidos",
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      //return AppLocalizations.of(context).translate('introduceapellido');
                                    }
                                    return null;
                                  }
                              ),Padding(
                                  padding: const EdgeInsets.all(10.0)
                              ),
                              TextFormField(
                                  initialValue:
                                  usuario.Poblacion =
                                      solicitud.get('Poblacion'),
                                  onChanged: (value) =>
                                  usuario.Poblacion = value,
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
                                  padding: const EdgeInsets.all(10.0)
                              ),
                              TextFormField(
                                  initialValue:
                                  usuario.NUser = solicitud.get('NUser'),
                                  onChanged: (value) => usuario.NUser = value,
                                  decoration: InputDecoration(
                                    icon: Icon(Icons.person_pin_circle_rounded),

                                    labelText: "Nombre de Usuario",
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      //return AppLocalizations.of(context).translate('introducecity');
                                    }
                                    return null;
                                  }
                              ),
                              Padding(
                                  padding: const EdgeInsets.all(10.0)
                              ),
                              TextFormField(
                                  initialValue: usuario.DNI =
                                      solicitud.get('DNI'),
                                  onChanged: (value) =>
                                  usuario.DNI = value,
                                  decoration: InputDecoration(
                                    icon: Icon(Icons.article_rounded),
                                    labelText: "DNI",
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      //return  AppLocalizations.of(context).translate('introducecop');
                                    }
                                    return null;
                                  }
                              ),
                              Padding(
                                  padding: const EdgeInsets.all(14.0)
                              ),
                              Row(
                                children: [
                                  Text("Foto de perfil: ",
                                    style: TextStyle(fontSize: 12),),
                                  ElevatedButton(onPressed: () {
                                    _getImageFromGallery();
                                    usuario_provider.savePhoto(
                                        usuario, imageFile, hasImg);
                                    //_openImagePicker();
                                    //usuario.Image=_image.toString();

                                  },
                                      child: Text("Subir foto de galería",
                                          style: TextStyle(fontSize: 12))),
                                  Padding(padding: const EdgeInsets.symmetric(
                                      horizontal: 2.0)),
                                  ElevatedButton(onPressed: () {
                                    _getImageFromCamera();
                                    usuario_provider.savePhoto(
                                        usuario, imageFile, hasImg);
                                    //usuario.Image=_image.toString();
                                  },
                                      child: Text("Realizar fotografía",
                                          style: TextStyle(fontSize: 12))),


                                ],
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
                                //ud.DataUser datosuser1 = ud.DataUser();
                                DateTime now = DateTime.now();
                                String formattedDate = DateFormat(
                                    "yyyy-dd-M--HH-mm-ss").format(now);
                                if (hasImg == true) {
                                  usuario.Image =
                                      datosuser.email + "_" + formattedDate;
                                  uploadFile(imageFile, usuario.Image);
                                } else {
                                  usuario.Image = "";
                                }
                                hola = solicitud.reference.id;

                                usuario_provider.updateUsuario(hola, usuario);
                                _navigateMisAnuncios();
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
  void _navigateHome(){
    Navigator.of(context)
        .push(MaterialPageRoute<void>(
      builder: (context) => HomePage(),
    )).then( (var value) {
      _refresh();
    });
  }

  void _submit() {
    //Navigator.of(context).pop();

  }


  _getImageFromCamera() async {
    PickedFile image = await ImagePicker().getImage(source: ImageSource.camera);
    _cropImage(image.path);
  }

  _getImageFromGallery() async {
    PickedFile image = await ImagePicker().getImage(
        source: ImageSource.gallery);
    _cropImage(image.path);
  }

  _cropImage(imagePath) async {
    File croppedImage = await ImageCropper().cropImage(sourcePath: imagePath,
        maxWidth: 1080,
        maxHeight: 1080,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1));
    if (croppedImage != null) {
      imageFile = croppedImage;
      hasImg = true;
      setState(() {});
    }
  }

  uploadFile(File image,String name) async {
    FirebaseStorage storage= FirebaseStorage.instance;
    Reference ref = storage.ref().child(name);
    UploadTask uploadTask = ref.putFile(image);
  }
}