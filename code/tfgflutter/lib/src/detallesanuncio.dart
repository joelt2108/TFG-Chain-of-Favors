
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tfgflutter/src/mianuncio.dart';
import 'package:tfgflutter/src/miperfil.dart';
import 'package:tfgflutter/src/model/solicitud_model.dart';
import 'package:tfgflutter/src/model/user_model.dart';
import 'package:tfgflutter/src/provider/chat_provider.dart';
import 'package:tfgflutter/src/provider/solicitud_provider.dart';
import 'package:tfgflutter/src/provider/user_provider.dart';
import 'package:tfgflutter/src/solicitud.dart';

import 'dart:async';
import 'chat.dart';
import 'controller/userdata.dart' as ud;


import 'home.dart';
import 'misanuncios.dart';
import 'model/chat_model.dart';

ud.DataUser datosuser = ud.DataUser();
Solicitud solicitud= new Solicitud();
Usuario usuario= new Usuario();

List<dynamic> listaFinal;
List<String> listahelp=[];
List<String> listahelp2=[];

final usuarioProvider = new Usuario_Provider();


class DetalleAnuncio extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MyDetallesAnuncios(datosuser.email,title: 'Tablón de Anuncios'),
    );
  }
}

class MyDetallesAnuncios extends StatefulWidget {
  MyDetallesAnuncios(this.email, {Key key, this.title}) : super(key: key);

  final String title;
  final String email;
  Timer _timer;


  @override
  _MyDetallesAnunciosPage createState() => _MyDetallesAnunciosPage();
}

class _MyDetallesAnunciosPage extends State<MyDetallesAnuncios> {
  Solicitud_Provider solicitud_provider= new Solicitud_Provider();
  Usuario_Provider usuario_provider= new Usuario_Provider();
  final usuarioProvider = new Usuario_Provider();

  Icon customIcon = const Icon(Icons.search);
  Icon customIcon2 = const Icon(Icons.edit_attributes_outlined);

  Widget customSearchBar = const Text('Tablón de anuncios');
  //final duplicateItems = List<String>.generate(10000, (i) => "Item $i");
  TextEditingController editingController = TextEditingController();
  var items = List<String>();
  Stream<QuerySnapshot> SolicitudesCargadas;
  Stream<QuerySnapshot> UsuarioCargado;
  Stream<DocumentSnapshot> UsuarioCargado2;

  Stream<DocumentSnapshot> DAnuncios;
  Stream<DocumentSnapshot> DUsuarios;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> NUsuario;
  ud.DataUser datosuser = ud.DataUser();
  Usuario us=new Usuario();
  String inst;
  List<dynamic> listaFinal;








  void _refresh()  {
    //SolicitudesCargadas = solicitud_provider.cargarSolicitudes();
    UsuarioCargado=usuario_provider.getUsuario(datosuser.email);
    DAnuncios=solicitud_provider.cargaSolicitud(widget.email);
    NUsuario=usuario_provider.getNUser(datosuser.email);




    setState(() {});

  }


  void initState() {
    super.initState();
    SolicitudesCargadas = solicitud_provider.cargarSolicitudes();
    DAnuncios=solicitud_provider.cargaSolicitud(widget.email);

    UsuarioCargado=usuario_provider.getUsuario(datosuser.email);
    NUsuario=usuario_provider.getNUser(datosuser.email);




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
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.

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



              //camBIAAAA
              Flexible(
                fit: FlexFit.tight,
                child: StreamBuilder(
                  stream: DAnuncios,
                  builder:
                      (BuildContext context1, AsyncSnapshot<DocumentSnapshot> snapshot1) {
                    if (snapshot1.hasData) {

                      return StreamBuilder<QuerySnapshot>(
                        stream: usuario_provider.getUsuario(datosuser.email),
                        builder:  (BuildContext context2, AsyncSnapshot<QuerySnapshot> snapshot2) {
                          if (snapshot2.hasData) {
                            return PageView.builder(

                              itemCount: 1,
                              itemBuilder: (context, i) => _cargarDatosAnuncio(context, snapshot1.data, snapshot2.data.docs[i]),



                            );

                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },



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
  Widget _cargarDatosAnuncio(BuildContext context, DocumentSnapshot solicitud, QueryDocumentSnapshot usuario){
    return GestureDetector(
      key: UniqueKey(),

      child:
      Container(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.grey,
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

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Padding(
                                  padding: const EdgeInsets.all(6.0)
                              ),

                              Text(solicitud.get("Titulo"),style: TextStyle( fontSize: 20, fontWeight: FontWeight.bold
                              )
                                  //usuario.Nombre = solicitud.get('Nombre'),
                                  //onChanged: (value) => usuario.Nombre = value,

                              ),

                              Padding(
                                  padding: const EdgeInsets.all(10.0)
                              ),
                              Text(solicitud.get("Descripcion")),

                              Padding(
                                  padding: const EdgeInsets.all(10.0)
                              ),
                              Text("Provincia: " + solicitud.get("Poblacion")),
                              Row(children: [
                                Text("Puntos ofrecidos: " + solicitud.get("Puntos")),
                                Icon(Icons.monetization_on),

                              ],),
                              Padding(
                                  padding: const EdgeInsets.all(10.0)
                              ),
                              Row(
                                children: [
                                  Text("Solicitante: "),
                                  Row(children: [
                                    FutureBuilder<String>(
                                        future: solicitud_provider.getImagen('${solicitud.get('Image')}'),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            print("A"+snapshot.data.toString());
                                            return CircleAvatar(radius: 10, backgroundImage: NetworkImage(snapshot.data.toString()));
                                          }
                                          else{
                                            return CircularProgressIndicator();
                                          }
                                        }
                                    ),

                                    Text(" "+ solicitud.get("NUser"),style: TextStyle(fontStyle: FontStyle.italic))
                                  ],),

                                  
                                ],
                              ),
                              Padding(
                                  padding: const EdgeInsets.all(15.0)
                              ),
                              Row(

                                  mainAxisAlignment: MainAxisAlignment.center,
                                //Center Column contents vertically,
                              children: [

                                  ElevatedButton(onPressed: ()   async {

                                    int valida;

                                    ud.DataUser datosuser = ud.DataUser();
                                    Chats chats=new Chats();
                                    Chats_Provider chpr=Chats_Provider();

                                    //chpr.saveChat(chats);
                                    var aux=datosuser.email+ solicitud.get("id").toString();
                                    var aux2=solicitud.get("id").toString()+datosuser.email;

                                    var res= await chpr.validaChat(aux);
                                    var res2= await chpr.validaChat(aux2);

                                    if(res.size==0 && res2.size==0){
                                      //creamos chat
                                      chats.id=datosuser.email+ solicitud.get("id").toString();
                                      chats.Usuario1=datosuser.email;
                                      chats.Usuario2=solicitud.get("id").toString();
                                      chats.Mensajes=[];
                                      List<String> lista1=[];
                                      List<String> lista2=[];
                                      lista1.add(solicitud.get("id"));
                                      lista2.add(datosuser.email);
                                      QuerySnapshot querySnap = await FirebaseFirestore.instance.collection('Usuario').where('id',isEqualTo: solicitud.get("id")).get();
                                      QueryDocumentSnapshot doc = querySnap.docs[0];
                                      DocumentReference docRef = doc.reference;
                                      usuario_provider.updateChatsUser(usuario.reference.id,  lista1);
                                      usuario_provider.updateChatsUser(docRef.id,lista2);

                                      chpr.saveChat(chats);
                                      _navigateOpenChat(datosuser.email, solicitud.get("id").toString(),solicitud.get("NUser").toString());




                                    }
                                    else{
                                      //llamamos chat entre usuarios
                                      print("estos usuarios ya han hablado");
                                      _navigateOpenChat(datosuser.email, solicitud.get("id").toString(), solicitud.get("NUser").toString());


                                    }






                                    //chats.Mensajes=[];




                                  },
                                      child: Icon(Icons.mail_outline)),
                                  Padding(padding: const EdgeInsets.symmetric(
                                      horizontal: 2.0)),
                                  ElevatedButton(onPressed: () {

                                    String el=solicitud.reference.id;
                                    String ele2=usuario.reference.id;


                                    cargaNUsers(el,ele2);






                                    //sl.Solicitantes.add(datosuser.email);
                                    },

                                      child: Text("Realizar solicitud",
                                          style: TextStyle(fontSize: 12))),


                                ],
                              ),
                              Padding(
                                  padding: const EdgeInsets.all(10.0)
                              ),

                            ],
                          ),
                          )




                    ]),
              ),

            ],),

        ),),);

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
  void _navigateMiPerfil(){
    Navigator.of(context)
        .push(MaterialPageRoute<void>(
      builder: (context) => PerfilPage(),
    )).then( (var value) {
      _refresh();
    });
  }

  void _navigateOpenChat(String us1, String us2, String nuser){
    Navigator.of(context)
        .push(MaterialPageRoute<void>(
      builder: (context) => Chat(us1, us2, nuser),
    )).then( (var value) {
      _refresh();
    });
  }



  void cargaNUsers(String ele, String usid)async{
    //print(solicitud.Solicitantes);
    listahelp=[];
    listahelp2=[];
    _rellenarItems2();
    ud.DataUser datosuser = ud.DataUser();
    Solicitud_Provider pr = new Solicitud_Provider();
    Usuario_Provider upr = new Usuario_Provider();

    //upr.getUsuario(datosuser.email);
    //solicitud.id=datosuser.email;
    //solicitud.Solicitantes.add(listaFinal[0].get("NUser").toString());
     //solicitud.Solicitantes(context, listen=false).add
      String rr=solicitud.id;
      String rr2=usuario.id;


      listahelp.add(datosuser.email);
      listahelp2.add(ele);
      pr.updateSolicitudSolicitante(ele, rr,solicitud, listahelp);
      upr.updateSolicitudUser(usid,rr2,usuario, listahelp2);

    Navigator.pop(context);

  }


  Future<List> _rellenarItems2() async {
    Stream<QuerySnapshot> usuario = await usuarioProvider.getUsuario(datosuser.email);
    Future<List> lista = recuperarNUsers(usuario);
    final lista2 = await recuperarNUsers(usuario);

    return lista;
  }

  void createChat()async{
   
  }
  Future<List> recuperarNUsers(Stream<QuerySnapshot> us) async {
    int i=1;
    int j=0;
    List<dynamic> lista = new List();
    us.forEach((element) {
      element.docs.asMap().forEach((key, value) {
        lista.add(element.docs[key]);
        print(element.docs[key]);
        print("FUNCION"+lista.toString());
      });
      i++;
      j++;
      listaFinal = lista;
    });
    return lista;
  }
}







