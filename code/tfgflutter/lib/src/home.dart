
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tfgflutter/src/register.dart';
import 'controller/userdata.dart' as ud;
import 'package:flutter/material.dart';
import 'package:tfgflutter/src/avisolegal.dart';
import 'package:tfgflutter/src/chatlist.dart';
import 'package:tfgflutter/src/detallesanuncio.dart';
import 'package:tfgflutter/src/login.dart';
import 'package:tfgflutter/src/miperfil.dart';
import 'package:tfgflutter/src/mis_solicitudes.dart';
import 'package:tfgflutter/src/model/user_model.dart';
import 'package:tfgflutter/src/provider/solicitud_provider.dart';
import 'package:tfgflutter/src/provider/user_provider.dart';
import 'package:tfgflutter/src/ranking.dart';
import 'package:tfgflutter/src/solicitud.dart';

import 'dart:async';
import 'chat.dart';
import 'controller/userdata.dart' as ud;


import 'controller/userdata.dart';
import 'mianuncio.dart';
import 'misanuncios.dart';


String dropdownvalue = 'Cualquiera';
String rangPuntos='Cualquiera';



class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;
  Timer _timer;


  @override
  _MyHomePageState createState() => _MyHomePageState();
}


class _MyHomePageState extends State<HomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
  ud.DataUser datosuser = ud.DataUser();
  Usuario us=new Usuario();


  List<String> ProvinciasSPN = <String>['Cualquiera','Alava','Albacete','Alicante','Almería','Asturias','Avila','Badajoz','Barcelona','Burgos','Cáceres',
    'Cádiz','Cantabria','Castellón','Ciudad Real','Córdoba','La Coruña','Cuenca','Gerona','Granada','Guadalajara',
    'Guipúzcoa','Huelva','Huesca','Islas Baleares','Jaén','León','Lérida','Lugo','Madrid','Málaga','Murcia','Navarra',
    'Orense','Palencia','Las Palmas','Pontevedra','La Rioja','Salamanca','Segovia','Sevilla','Soria','Tarragona',
    'Santa Cruz de Tenerife','Teruel','Toledo','Valencia','Valladolid','Vizcaya','Zamora','Zaragoza'];
  String dropdownvalue = 'Cualquiera';
  String rangPuntos= 'Cualquiera';

  _MyDialogState dl = new _MyDialogState();
  _MyDialogStateP dlp = new _MyDialogStateP();
  String id;
  final _scaffoldKey = GlobalKey<ScaffoldState>();





  void _incrementCounter() {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(
      builder: (context) => CreateSolicitud(),
    )).whenComplete(() => _refresh());
  }

  void _refresh()  {
    getPuntos();
    SolicitudesCargadas = solicitud_provider.cargarSolicitudes();
    UsuarioCargado=usuario_provider.getUsuario(datosuser.email);
    //datosuser.puntos=usuario_provider.recuperaPuntos(datosuser.email);

    setState(() {});

  }


  void initState()  {
    super.initState();
    SolicitudesCargadas = solicitud_provider.cargarSolicitudes();
    getPuntos();



  }
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
   //var auxx=usuario_provider.cargaUsuarioChat(datosuser.email);




    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgetscar.
    return Scaffold(
      key: _scaffoldKey,

      backgroundColor: Colors.white70,


      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: customSearchBar,
          //automaticallyImplyLeading: false,
        actions: [
          IconButton(onPressed:(){
            setState(() {
            if (customIcon.icon == Icons.search) {
              // Perform set of instructions.
              customIcon = const Icon(Icons.cancel);
              customSearchBar =  ListTile(
              leading: Icon(
              Icons.search,
              color: Colors.white,
              size: 28,
              ),
              title: TextField(
                onChanged: (value) => SolicitudesBusqueda(value) ,
                controller: editingController,
                decoration: InputDecoration(
              hintText: 'introduce tu búsqueda...',

              hintStyle: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontStyle: FontStyle.italic,
              ),

              border: InputBorder.none,
              ),
              style: TextStyle(
              color: Colors.white,
              ),
              ),
              );
            } else {
              //_refresh();
              setState(() {});

              customIcon = const Icon(Icons.search);

              customSearchBar = const Text('Tablón de anuncios');


            }
    });


          }, icon: customIcon),
          IconButton(onPressed:(){_showMyDialog();}, icon:              customIcon2 = const Icon(Icons.edit_attributes_outlined)
          )
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
      ),


      // This trailing comma makes auto-formatting nicer for build methods.
    );


  }
  Widget _cargarDatos(BuildContext context, QueryDocumentSnapshot solicitud){

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
                                future: solicitud_provider.getImagen('${solicitud.get('Image')}'),
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

          if(solicitud.get("id")!=datosuser.email)
          {
            id=solicitud.id;
            _navigateDetallesAnuncio(id);
          }
          else{
            _navigateDetallesMiAnuncio(solicitud.id);

          }

        },
      );





  }




  SolicitudesBusqueda(String query) {
    print(dl.getdropdown());
    print(dlp.getrang());

    if(dl.getdropdown() == "Cualquiera" && dlp.getrang() == "Cualquiera" ){
      print("Al 1 llego easy");
      SolicitudesCargadas = solicitud_provider.cargarSolicitudesSearch(query);
      setState(() {});
    }
    if(dl.getdropdown() != "Cualquiera" && dlp.getrang() == "Cualquiera" ){
      print("Al 2 llego easy");

     SolicitudesCargadas=solicitud_provider.cargarSolicitudesSearchFiltrado(query, dl.getdropdown());
      setState(() {});
    }
    if(dl.getdropdown() == "Cualquiera" && dlp.getrang() != "Cualquiera" ){
      print("Al 3 llego easy");

      SolicitudesCargadas=solicitud_provider.cargarSolicitudesSearchPuntos(query, dlp.getrang());
      setState(() {});
    }

    if(dl.getdropdown() != "Cualquiera" && dlp.getrang() != "Cualquiera" ){
      print("Al 4 llego easy");

      SolicitudesCargadas=solicitud_provider.cargarSolicitudesSearchPuntosPobl(query, dl.getdropdown(), dlp.getrang());
      setState(() {});
    }

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

  void _navigateDetallesAnuncio(String email){
    Navigator.of(context)
        .push(MaterialPageRoute<void>(
      builder: (context) => DetallesAnuncios(email),
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

  void _navigateLogin(){
    Navigator.of(context)
        .push(MaterialPageRoute<void>(
      builder: (context) => LoginPage(),
    )).then( (var value) {
      //_refresh();
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

  void _navigateAviso(){
    Navigator.of(context)
        .push(MaterialPageRoute<void>(
      builder: (context) => Aviso(),
    )).then( (var value) {
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

  void _navigateRanking(){
    Navigator.of(context)
        .push(MaterialPageRoute<void>(
      builder: (context) => RankingPage(),
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

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamed(context, 'login');

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

   getPuntos()async{
    var pts=await usuario_provider.cargaUsuario(datosuser.email);
    datosuser.puntos=pts.docs.first["Puntos"];

  }


}

class MyDialog extends StatefulWidget {
  const MyDialog({Key key}) : super(key: key);


  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  List<String> ProvinciasSPN = <String>['Cualquiera','Álava','Albacete','Alicante','Almería','Asturias','Avila','Badajoz','Barcelona','Burgos','Cáceres',
    'Cádiz','Cantabria','Castellón','Ciudad Real','Córdoba','La Coruña','Cuenca','Girona','Granada','Guadalajara',
    'Guipúzcoa','Huelva','Huesca','Islas Baleares','Jaén','León','Lleida','Lugo','Madrid','Málaga','Murcia','Navarra',
    'Ourense','Palencia','Las Palmas','Pontevedra','La Rioja','Salamanca','Segovia','Sevilla','Soria','Tarragona',
    'Santa Cruz de Tenerife','Teruel','Toledo','Valencia','Valladolid','Vizcaya','Zamora','Zaragoza'];



  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButton(
          disabledHint: Text("Provincia"),
          style: TextStyle(color: Colors.lightBlue,fontSize: 15),
          items: ProvinciasSPN.map((String items) {
            return DropdownMenuItem(

              value: items,
              child: Text(items),
            );
          }).toList(),
          value: dropdownvalue,
          onChanged: (String newValue) {
            setdropdown(newValue);

            setState(() {
              setdropdown(newValue);
              dropdownvalue = newValue;
            });

          },

        )
      ],
    );


  }

  String getdropdown(){
    return dropdownvalue;
  }

  void setdropdown(String dropdown){
    dropdownvalue=dropdown;
  }
}

class MyDialogP extends StatefulWidget {
  const MyDialogP({Key key}) : super(key: key);


  @override
  _MyDialogStateP createState() => _MyDialogStateP();
}

class _MyDialogStateP extends State<MyDialogP> {
  List<String> RangosP = <String>['Cualquiera','50','100','150','200','250','300','350','400','450','500'];



  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButton(
          disabledHint: Text("Puntos Ofrecidos"),
          style: TextStyle(color: Colors.lightBlue,fontSize: 15),
          items: RangosP.map((String items) {
            return DropdownMenuItem(

              value: items,
              child: Text(items),
            );
          }).toList(),
          value: rangPuntos,
          onChanged: (String newValue) {
            setrang(newValue);

            setState(() {
              rangPuntos = newValue;
            });

          },

        )
      ],
    );


  }
  String getrang(){
    return rangPuntos;
  }

  void setrang(String rangg){
    rangPuntos=rangg;
  }

}




