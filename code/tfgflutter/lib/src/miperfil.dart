

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tfgflutter/src/model/user_model.dart';
import 'package:tfgflutter/src/provider/solicitud_provider.dart';
import 'package:tfgflutter/src/provider/user_provider.dart';
import 'package:tfgflutter/src/solicitud.dart';
import 'controller/userdata.dart' as ud;
import 'package:image_picker/image_picker.dart';
import 'dart:ffi';
import 'dart:io';
import 'package:intl/intl.dart';

import 'package:image_cropper/image_cropper.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:async';

import 'home.dart';
import 'misanuncios.dart';

class PerfilPage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MiPerfilPage(title: 'Tablón de Anuncios'),
    );
  }
}

class MiPerfilPage extends StatefulWidget {
  MiPerfilPage({Key key, this.title}) : super(key: key);


  final String title;
  Timer _timer;


  @override
  _MiPerfilPageState createState() => _MiPerfilPageState();
}

class _MiPerfilPageState extends State<MiPerfilPage> {
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
                              ),
                              TextFormField(
                                  initialValue:
                                  usuario.Poblacion =
                                      solicitud.get('Poblacion'),
                                  onChanged: (value) =>
                                  usuario.Poblacion = value,
                                  decoration: InputDecoration(
                                    icon: Icon(Icons.roofing),

                                    labelText: "Población",
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      Text("Introduce Poblacion");
                                    }
                                    return null;
                                  }
                              ),

                              TextFormField(
                                  initialValue:
                                  usuario.NUser = solicitud.get('NUser'),
                                  onChanged: (value) => usuario.NUser = value,
                                  decoration: InputDecoration(
                                    icon: Icon(Icons.room),

                                    labelText: "Nombre de Usuario",
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      //return AppLocalizations.of(context).translate('introducecity');
                                    }
                                    return null;
                                  }
                              ),

                              TextFormField(
                                  initialValue: usuario.DNI =
                                      solicitud.get('DNI'),
                                  onChanged: (value) =>
                                  usuario.DNI = value,
                                  decoration: InputDecoration(
                                    icon: Icon(Icons.description),
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
                                  padding: const EdgeInsets.all(6.0)
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