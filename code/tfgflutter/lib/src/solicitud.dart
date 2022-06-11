import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tfgflutter/src/detallesanuncio.dart';
import 'controller/userdata.dart' as ud;
import 'package:tfgflutter/main.dart';
import 'package:tfgflutter/src/provider/user_provider.dart';
import 'package:tfgflutter/src/provider/solicitud_provider.dart';

import 'login.dart';
import 'model/user_model.dart';
import 'model/solicitud_model.dart';


class CreateSolicitud extends StatefulWidget {


  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _CreateSolicitudState createState() => _CreateSolicitudState();
}

class _CreateSolicitudState extends State<CreateSolicitud> {
  String _selectedItem;
  Solicitud solicitud= new Solicitud();
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descipcionController = TextEditingController();
  final TextEditingController _puntosController = TextEditingController();
  final TextEditingController _nuserController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final usuarioProvider = new Usuario_Provider();
  //user.PreferenciasUsuario datosUser = user.PreferenciasUsuario();
  ud.DataUser datosuser = ud.DataUser();  
  List<dynamic> listaFinal;


  void initState() {
    super.initState();
    setState(() {});
    GlobalKey<FormState> keyForm= new GlobalKey();


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

          title: Row(
            children: [
              Container(
                 child: Text('Crear Solicitud' , style: TextStyle(
                  color: Colors.white
              ),), ),
            ],
          ),
          actions: <Widget>[


          ],
        ),
        body:SingleChildScrollView(

            child:Container(


                child:Form(child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 25),
                      child: Text("Título", style:  const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: TextField(
                        controller: _tituloController,
                        onChanged: (value) => solicitud.Titulo = value,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Introduce un título...',
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 25),
                      child: Text("Descripción", style:  const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: TextField(
                        maxLines: 4,
                        minLines: 4,
                        controller: _descipcionController,
                        onChanged: (value) => solicitud.Descripcion = value,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Cuéntanos que necesitas...',


                        ),
                        keyboardType: TextInputType.multiline,

                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 25),
                      child: Text("Puntos ofrecidos", style:  const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                    child:TextField(
                      controller: _puntosController,
                      keyboardType: TextInputType.number,
                      onChanged: (value) => solicitud.Puntos = value,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Introduce los puntos...',
                      ),
                    ),

            ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 120, vertical: 40),
                child: RaisedButton(
                  onPressed: (){
                      _uploadSolicitud();

                  } ,
                  child: new Text("Publicar solicitud", textAlign: TextAlign.center,
                      ),
                  color: Colors.lightBlue,
                  textColor: Colors.white,
                )
              ),
                  ],
                ),
                )),


        ));
  }

  void _uploadSolicitud () async
  {
    _rellenarItems();
    ud.DataUser datosuser = ud.DataUser();

    Solicitud_Provider pr = new Solicitud_Provider();
    Usuario_Provider upr = new Usuario_Provider();
    //upr.getUsuario(datosuser.email);
    solicitud.id=datosuser.email;
 
    solicitud.NUser=listaFinal[0].get("NUser").toString();
    solicitud.Poblacion=listaFinal[0].get("Poblacion").toString();
    solicitud.Estado="Sin asignar";
    solicitud.Search=parametersSearch(solicitud.Titulo);
    solicitud.Image=listaFinal[0].get("Image").toString();
    solicitud.Solicitantes=new List();

    pr.saveSolicitud(solicitud);
    Navigator.pop(context);

  }

  Future<List> _rellenarItems() async {
    Stream<QuerySnapshot> usuario = await usuarioProvider.getUsuario(datosuser.email);
    Future<List> lista = recuperarNUser(usuario);
    final lista2 = await recuperarPoblacion(usuario);
    final lista3 = await recuperarImagen(usuario);

    return lista;
  }

  Future<List> recuperarNUser(Stream<QuerySnapshot> usuario) async {
    int i=1;
    int j=0;
    List<dynamic> lista = new List();
    usuario.forEach((element) {
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
  Future<List> recuperarPoblacion(Stream<QuerySnapshot> usuario) async {
    int i=1;
    int j=0;
    List<dynamic> lista = new List();
    usuario.forEach((element) {
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
  Future<List> recuperarImagen(Stream<QuerySnapshot> usuario) async {
    int i=1;
    int j=0;
    List<dynamic> lista = new List();
    usuario.forEach((element) {
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
  parametersSearch(String sol) {
    List<String> caseSearchList = List();
    String temp = "";
    for (int i = 0; i < sol.length; i++) {
      temp = temp + sol[i];
      caseSearchList.add(temp);
    }
    return caseSearchList;
  }
}

List<String> getSolicitantes(){
  return solicitud.Solicitantes;
}

void setSolicitantes(List<String> sol){
  solicitud.Solicitantes=sol;
  for(int i=0; i<sol.length;i++){
    solicitud.Solicitantes.add(sol[i]);
  }
}