
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
        child:
        SingleChildScrollView(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(padding: EdgeInsets.only(left: 20, right: 2)),
            Text("1.Titular \n Para dar cumplimiento a lo establecido en la Ley 34/2002 de 11 de julio de Servicios de la Sociedad de la Información "
                "y de Comercio Electrónico (LSSICE), a continuación se indican los datos de información general de Chain of Favours App:\n"
                "Titular: Joel Trujillo Ramos. \n"
                "Email: chainoffavoursapp@gmail.com\n"

            ,style: TextStyle(fontSize: 16)),
            Padding(padding: EdgeInsets.only(left: 2, right: 2)),

            Text("2. Finalidad\n Chain of Favours App es una aplicación cuya finalidad es facilitar una plataforma  de comunicación y ayuda entre usuarios para las diversas necesidades diarias que puedan tener de forma totalmente gratuita.",style: TextStyle(fontSize: 16)),

            Text("3. Condiciones de uso\n Las presentes condiciones generales rigen el uso de Chain of Favours App. El acceso y posterior utilización de esta plataforma por parte del usuario implicará su conformidad de forma expresa, plena y sin reservas, "
                "con estas condiciones de uso. Si el usuario no estuviera de acuerdo con el contenido de este documento deberá abandonar la plataforma, no pudiendo acceder ni disponer de los servicios que ésta ofrece.",style: TextStyle(fontSize: 16)),
            Text("  4. Edad del usuario\n No se permite el registro de usuarios  a menores de 18 años. El cumplimiento de este requisito es responsabilidad del usuario. Si en cualquier momento tenemos constancia o sospechamos que el usuario no cumple este requisito de edad, procederemos al borrado de su cuenta sin previo aviso.",style: TextStyle(fontSize: 16)),

            Text("5. Privacidad y Seguridad\n Los datos personales que nos aporte mediante los formularios que ponemos a su disposición serán tratados por el equipo de Chain of Favours App\n",style: TextStyle(fontSize: 16)),

            Text("A continuación se describen los distintos apartados en los que se recaban y tratan datos de carácter personal.",style: TextStyle(fontSize: 16)),

            Padding(
                padding: const EdgeInsets.all(2.0)
            ),
            Text("Formulario de registro:\n Los datos que se recaban mediante este formulario serán utilizados con la finalidad de gestionar los usuarios registrados en nuestra plataforma y prestarle nuestros servicios. La base legal para el tratamiento de sus datos es tanto el consentimiento que otorga al registrarse, así como el cumplimiento del servicio solicitado",style: TextStyle(fontSize: 16)),
            Padding(
                padding: const EdgeInsets.all(2.0)
            ),
            Text("Permiso del almacenamiento del dispositivo:\n Para modificar las imágenes de perfil del usuario se deberá dotar a la aplicación de acceso al almacenamiento interno de su dispositivo Android. Esta opción es completamente opcional y no es requerida para poder usar la plataforma.",style: TextStyle(fontSize: 16)),
            Padding(
                padding: const EdgeInsets.all(2.0)
            ),
            Text("Permiso de uso de la cámara del dispositivo\n  Así como en el apartado anterior, se deberá dotar a la aplicación de acceso a la cámara de su dispositivo Android. Esta opción es completamente opcional y no es requerida para poder usar la plataforma.",style: TextStyle(fontSize: 16)),
            Padding(
                padding: const EdgeInsets.all(2.0)
            ),
            Text("En ningún caso, sus datos serán cedidos a terceros o utilizados para su comercialización",style: TextStyle(fontSize: 16)),

            Text("6. Contenidos\n Chain of Favours App se reserva el derecho de borrar en cualquier momento un contenido (fotografía, vídeo, texto, etc.) si estima que vulnera alguna ley vigente (derecho a la intimidad, propiedad intelectual, propiedad industrial, etc.). En caso de que algún usuario publique contenido delictivo (pedófilo, racista, insultante, difamatorio,…), dicho contenido será borrado sin previo aviso y la cuenta del responsable será inmediata y definitivamente eliminada.",style: TextStyle(fontSize: 16)),

            Text("7. Cookies\n  Cuando usted se registra en nuestra app, se generan cookies propias que le identifican como usuario registrado.Estas cookies son utilizadas para identificar su cuenta de usuario y sus servicios asociados. Estas cookies se mantienen mientras usted no abandone la cuenta, o apague el dispositivo.",style: TextStyle(fontSize: 16)),


          ],
        ),),

      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _cargarDatos(BuildContext context, DocumentSnapshot solicitud) {
    return GestureDetector(
      key: UniqueKey(),

      child:
      Container(
        child: Column(

        ),
       ),);
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
