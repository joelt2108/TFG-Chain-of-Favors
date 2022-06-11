
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tfgflutter/src/miperfil.dart';
import 'package:tfgflutter/src/model/solicitud_model.dart';
import 'package:tfgflutter/src/model/user_model.dart';
import 'package:tfgflutter/src/provider/solicitud_provider.dart';
import 'package:tfgflutter/src/provider/user_provider.dart';
import 'package:tfgflutter/src/solicitud.dart';

import 'dart:async';
import 'controller/userdata.dart' as ud;


import 'home.dart';
import 'misanuncios.dart';

ud.DataUser datosuser = ud.DataUser();
Solicitud solicitud= new Solicitud();

final usuarioProvider = new Usuario_Provider();



class MiAnuncio extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MyMiAnuncio(datosuser.email,title: 'Tablón de Anuncios'),

    );
  }
}

class MyMiAnuncio extends StatefulWidget {
  MyMiAnuncio(this.email, {Key key, this.title}) : super(key: key);

  final String title;
  final String email;
  Timer _timer;


  @override
  _MyMiAnuncioPage createState() => _MyMiAnuncioPage();
}

class _MyMiAnuncioPage extends State<MyMiAnuncio> {
  Solicitud_Provider solicitud_provider= new Solicitud_Provider();
  Usuario_Provider usuario_provider= new Usuario_Provider();
  final usuarioProvider = new Usuario_Provider();
  List<dynamic> listaFinal;
  List<String> listahelp=[];
  Icon customIcon = const Icon(Icons.search);
  Icon customIcon2 = const Icon(Icons.edit_attributes_outlined);

  Widget customSearchBar = const Text('Mis Anuncios');
  //final duplicateItems = List<String>.generate(10000, (i) => "Item $i");
  TextEditingController editingController = TextEditingController();
  var items = List<String>();
  Stream<QuerySnapshot> SolicitudesCargadas;
  Stream<QuerySnapshot> UsuarioCargado;
  Stream<QuerySnapshot> UsuariosCargados;

  Stream<DocumentSnapshot> UsuarioCargado2;
  List <String> listaFinalSol=[];
  List<String> strs=[];
  List listaa=[];
int tt=0;
  Stream<DocumentSnapshot> DAnuncios;
  Stream<DocumentSnapshot> DUsuarios;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;


  Future<String> NUsuario;
  ud.DataUser datosuser = ud.DataUser();
  Usuario us=new Usuario();
  String inst;
  List<String> listaFinalQ;
  List<String> listaFinalS;

  List<String> helpme=solicitud.Solicitantes;
  Future<String> SoliFuture;
  List<String> listaaux=[];
  Stream<QuerySnapshot<Object>> StrSol;










  void _refresh()  {
    _rellenarItemsSol();

    //SolicitudesCargadas = solicitud_provider.cargarSolicitudes();
    UsuarioCargado=usuario_provider.getUsuario(datosuser.email);
    DAnuncios=solicitud_provider.cargaSolicitud(widget.email);
    NUsuario=usuario_provider.getNUser(datosuser.email);
    UsuariosCargados=usuario_provider.getUsersSol(widget.email);






    setState(() {});

  }


  void initState() {
    super.initState();
    _rellenarItemsSol();

    SolicitudesCargadas = solicitud_provider.cargarSolicitudes();
    DAnuncios=solicitud_provider.cargaSolicitud(widget.email);

    UsuarioCargado=usuario_provider.getUsuario(datosuser.email);
    NUsuario=usuario_provider.getNUser(datosuser.email);
    UsuariosCargados=usuario_provider.getUsersSol(widget.email);




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


              Flexible(
                fit: FlexFit.tight,
                child: StreamBuilder(
                  stream: DAnuncios,
                  builder:
                      (BuildContext context1, AsyncSnapshot<DocumentSnapshot> snapshot1) {
                    if (snapshot1.hasData) {

                      return StreamBuilder<QuerySnapshot>(
                        stream: usuario_provider.getUsersSol("ihugi"),
                        builder:  (BuildContext context2, AsyncSnapshot<QuerySnapshot> snapshot2) {
                          if (snapshot2.hasData) {
                            return PageView.builder(

                              itemCount: 1,
                              itemBuilder: (context, i) => _cargarDatosAnuncio(context, snapshot1.data),



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

        Container(
          child: Text("Solicitantes:"),
        ),

        Flexible (
            fit: FlexFit.tight,
          child: StreamBuilder (
            key: Key("${Random().nextDouble()}"),
            stream:  DAnuncios, /////////////////////este esss
            builder:
                (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot1) {
              if (snapshot1.hasData) {

                return StreamBuilder (
                  stream:  usuario_provider.getUsersSol(widget.email), /////////////////////este esss
                  builder:
                      (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot2) {
                    if (snapshot2.hasData) {

                      return ListView.builder(
                        itemCount: snapshot2.data.size,
                        itemBuilder: (context, i) =>

                            _cargarDatosAnuncio2(context, snapshot2.data.docs[i], snapshot1.data),


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



        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );


  }
  Widget _cargarDatosAnuncio(BuildContext context, DocumentSnapshot solicitud){
    List<String> caden;
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

                                  Text(" "+ solicitud.get("NUser"),style: TextStyle(fontStyle: FontStyle.italic)),



                                  //Expanded(child: MySolicitantes(),),
                                ],),


                              ],
                            ),
                            Padding(
                                padding: const EdgeInsets.all(10.0)
                            ),
                            Text(solicitud.get("Descripcion")),

                            Padding(
                                padding: const EdgeInsets.all(10.0)
                            ),
                            Text("Provincia: " + solicitud.get("Poblacion")),
                            Row(children:[
                              Text("Puntos ofrecidos: " + solicitud.get("Puntos")),
                              Icon(Icons.monetization_on),
                              //listahelp.length=solicitud.get("Solicitantes").length,
                              //Text(listahelp.length.toString()),

                             Container(

                             )
                             // listaFinalQ=solicitud_provider.getData(solicitud.id),
                              //print(solicitud_provider.getData(solicitud.id)),
                              //Text( listaFinalSol.get("Solicitantes").toString())

                               //caden = solicitud.get("Solicitantes").map((e) => e).toList(),
                              //Text(listaFinalQ.toString())


    ],),





                          ],
                        ),

                      ),





                    ]),
              ),


            ],

             ),

        ),



      ),

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


  Widget _cargarDatosAnuncio2(BuildContext context, QueryDocumentSnapshot usuarios, DocumentSnapshot soli){

    //_refresh();
    if(soli.get("NSol")==''){
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
                                  padding: EdgeInsets.only(right: 35.0),
                                ),
                                Container(
                                  alignment: Alignment.topRight,


                                ),
                                CupertinoButton(
                                    onPressed: (){
                                      solicitud.NSol='${usuarios.get('id')}';
                                      solicitud.Estado="Asignada";
                                      solicitud_provider.updateok(widget.email, solicitud);
                                      solicitud_provider.updateSolicitudAsignada('${usuarios.get('id')}');
                                      listaFinalS=[];
                                      listaFinalS.add('${usuarios.get('id')}');
                                      solicitud_provider.borrarSolicitud(soli.reference.id, listaFinalS);
                                      _refresh();
                                    }, child: Icon(Icons.check_circle,color: Colors.green,size: 18,)),
                                //SizedBox(width: 1), // give it width

                                CupertinoButton(
                                    onPressed: (){
                                      listaFinalQ=[];
                                      listaFinalQ.add(widget.email);
                                      usuario_provider.borrarSolicitudUser(usuarios.id, listaFinalQ);

                                     // _refresh();
                                    }, child: Icon(Icons.cancel,color: Colors.red,size: 18,)),


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


else{
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
                                  padding: EdgeInsets.only(right: 50.0),
                                ),
                                Container(
                                  alignment: Alignment.topRight,


                                ),
                               ElevatedButton(onPressed: (){
                                 tt=usuarios.get("Puntos") +int.parse(soli.get("Puntos"));
                                  usuario_provider.updatePuntos(usuarios.id, tt);
                                  solicitud_provider.FinalizarFavor(soli.reference.id,"Finalizado");
                               }, child: Text("Finalizar Favor"))
                                //SizedBox(width: 1), // give it width




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

  }
  Widget _cargarDatosAnuncioAceptado(BuildContext context, QueryDocumentSnapshot usuarios){

    Text("Va esto?");

  }


  void cargaNUsers(String ele)async{
    //print(solicitud.Solicitantes);
    listahelp=[];
    _rellenarItems2();
    ud.DataUser datosuser = ud.DataUser();
    Solicitud_Provider pr = new Solicitud_Provider();
    Usuario_Provider upr = new Usuario_Provider();
    //upr.getUsuario(datosuser.email);
    solicitud.id=datosuser.email;
    //solicitud.Solicitantes.add(listaFinal[0].get("NUser").toString());
    //solicitud.Solicitantes(context, listen=false).add
    String rr=solicitud.id;
    listahelp.add(datosuser.email);

    pr.updateSolicitudSolicitante(ele, rr,solicitud, listahelp);


    Navigator.pop(context);

  }


  Future<List> _rellenarItems2() async {
    Stream<QuerySnapshot> usuario = await usuarioProvider.getUsuario(datosuser.email);
    Future<List> lista = recuperarNUsers(usuario);
    final lista2 = await recuperarNUsers(usuario);

    return lista;
  }

  Future<List> _rellenarItemsSol() async {
    Stream<QuerySnapshot> sol = await solicitud_provider.getSolicitud(solicitud.id);
    Future<List> listae = recuperarSolicitantes(sol);
    final listae2 = await recuperarSolicitantes(sol);
    listahelp=listaFinal[0].get("Solicitantes");

    return listae;
  }

  Future<List> recuperarSolicitantes(Stream<QuerySnapshot> us) async {
    int i=1;
    int j=0;
    List<dynamic> listae = new List();
    us.forEach((element) {
      element.docs.asMap().forEach((key, value) {
        listae.add(element.docs[key]);
        print(element.docs[key]);
        print("FUNCION"+listae.toString());
      });
      i++;
      j++;
      listaFinalSol = listae;
    });
    return listae;
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

  Widget getSolicitantes(List<dynamic> solicitantes){
    for(int i=0;i<solicitantes.length;i++)
      {
        Text(solicitantes[i].toString());
      }

  }

  tornaGetSol(QueryDocumentSnapshot solicitud){
    return solicitud.get("Solicitantes");
  }
Widget _cargarDatos2(BuildContext context, QueryDocumentSnapshot usuario){
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
                children: <Widget>[

                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(15),

                      ),


                      Container(
                        padding: const EdgeInsets.only(left: 10),
                        child: FutureBuilder<String>(
                            future: solicitud_provider.getImagen('${usuario.get('Image')}'),
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
                            child:Text('${usuario.get('Titulo')}',
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
                            child:Text('${usuario.get('Descripcion')}',
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
                            child:Text('${usuario.get('Poblacion')}')
                        ),
                        Padding(
                            padding: const EdgeInsets.all(1.0)
                        ),
                        Container(
                            margin: const EdgeInsets.only(left: 20.0),
                            child:Text('${usuario.get('Puntos')}'+" Puntos")
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

  Widget _cargarDatosv(BuildContext context, QueryDocumentSnapshot usuarios,int index){
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



}


class MySolicitantes extends StatefulWidget {
  const MySolicitantes({Key key}) : super(key: key);


  @override
  MySolicitantesState createState() => MySolicitantesState();
}

class MySolicitantesState extends State<MySolicitantes> {
  Usuario_Provider uspr = new Usuario_Provider();





  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child:StreamBuilder<QuerySnapshot>(
          stream: uspr.getAllUsers(),
          builder:  (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return ListView(


              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },



        ) ,);



  }

}