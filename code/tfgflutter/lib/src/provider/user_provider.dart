import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tfgflutter/src/controller/userdata.dart';
import 'package:tfgflutter/src/detallesanuncio.dart';
import 'package:tfgflutter/src/model/user_model.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:tfgflutter/src/provider/solicitud_provider.dart';

Solicitud_Provider sol=Solicitud_Provider();

class Usuario_Provider{
  FirebaseFirestore _db = FirebaseFirestore.instance;


  Future<void> saveUsuario(Usuario usuario) {
    _db.collection('Usuario').add(usuario.toJson());
  }
  Stream<QuerySnapshot> getUsuario(String id) {
    return _db.collection("Usuario").where('id', isEqualTo: id).snapshots();
  }

  Future<QuerySnapshot<Map<String,dynamic>>> cargaUsuarioChat(String id) async{
    return await _db.collection("Usuario").where('id', isEqualTo: id).get();
  }

  Future<QuerySnapshot<Map<String,dynamic>>> cargaUsuario(String id) async{
    return await _db.collection("Usuario").where('id', isEqualTo: id).get();
  }

  Future<void> updateSolicitudUser(String id, String valor, Usuario usuario, List<String> lista ) {


    //solicitud.Solicitantes=[];

    //solicitud.Solicitantes.add(valor);
    _db.collection("Usuario").doc(id).update({
      "Solicitudes": FieldValue.arrayUnion(lista.cast<String>()),

    });


  }

  Future<void> updateChatsUser(String id, List<String> lista ) {


    //solicitud.Solicitantes=[];

    //solicitud.Solicitantes.add(valor);
    _db.collection("Usuario").doc(id).update({
      "Chats": FieldValue.arrayUnion(lista.cast<String>()),

    });


  }

  Future<void> generaSolicitud(String id, Usuario usuario) {
    _db.collection("Usuario").doc(id).update({
      'Nombre': usuario.Nombre,
      'Apellido': usuario.Apellido,
      'Poblacion': usuario.Poblacion,
      'NUser': usuario.NUser,
      'DNI': usuario.DNI,
      'Image':usuario.Image,
      'Solicitudes':usuario.Solicitudes,
    });
  }

  Future<void> updatePuntos(String id, int puntos) {
    _db.collection("Usuario").doc(id).update({
     'Puntos': puntos,
    });

    //datosuser.puntos=puntos;

  }

  Future<void> updateFavores(String id, int favores) {
    _db.collection("Usuario").doc(id).update({
      'NFavores': favores,
    });

    //datosuser.puntos=puntos;

  }
  Stream<QuerySnapshot> getAllUsers() {
    return _db.collection("Usuario").snapshots();
  }
  Stream<QuerySnapshot> getUsersChat(String us) {
    return _db.collection("Usuario").where("Chats",arrayContains: us).snapshots();
  }
  Stream<QuerySnapshot> getAllUsers2(List<String> lista)   {

  lista.forEach((element) {
    return  _db.collection("Usuario").where('id', isEqualTo: element).snapshots();
  });


  }

  Stream<QuerySnapshot> getUsersSol(String id) {
    return _db.collection("Usuario").where('Solicitudes', arrayContains: id).snapshots();
  }
  Future<void> borrarSolicitudUser(String id, List<String> lista ) {


    //solicitud.Solicitantes=[];

    //solicitud.Solicitantes.add(valor);
    _db.collection("Usuario").doc(id).update({
      "Solicitudes": FieldValue.arrayRemove(lista.cast<String>()),

    });


  }

  Stream<QuerySnapshot>  getAllUsers3(String lista)   {

      return  _db.collection("Usuario").where('id', isEqualTo: lista).snapshots();

  }
  Stream<QuerySnapshot> getUsuario2(String id) {

      return _db.collection("Usuario").where('id', isEqualTo: "joeltrujillo66@gmail.com").snapshots();


  }

  Stream<QuerySnapshot> getUsuariosSolicitantes(List<dynamic> id) {
    for(int i=0;i<id.length;i++)
      {
        return _db.collection("Usuario").where('id', isEqualTo: id[i]).snapshots();
      }

  }

  Stream<QuerySnapshot> getUsuariosSolicitantes2(List<dynamic> id) {
    id.forEach((element) {
      return _db.collection("Usuario").where('id', isEqualTo: element).snapshots();
    });
  }

  Future<QuerySnapshot<Map<String,dynamic>>> getSolicitantesDin(List<dynamic> lista){

  }

  Stream<QuerySnapshot> getRanking() {
    return _db.collection("Usuario").orderBy("NFavores", descending: true).limit(10).snapshots();

  }

  Future<String> getNUser2(String id) async {
    String nombre = "";
    await _db.collection("Usuario").where('id', isEqualTo: id).get()
        .then((value) =>
    {
      value.docs.forEach((element) {
        if(element.data()!=null){
          nombre=(element.data()["NUser"]);
        }
      })
    });
    return nombre;

  }
  String getNUser3(List<dynamic> id,int ist) {
    String nombre = "";
      _db.collection("Usuario").where('id', isEqualTo: id[ist]).get()
        .then((value) =>
    {
      value.docs.forEach((element) {
          nombre=(element.data()["NUser"]);

      })
    });
    return nombre;

  }


  Future<void> updateUsuario(String id, Usuario usuario) {
    _db.collection("Usuario").doc(id).update({
      'Nombre': usuario.Nombre,
      'Apellido': usuario.Apellido,
      'Poblacion': usuario.Poblacion,
      'NUser': usuario.NUser,
      'DNI': usuario.DNI,
      'Image':usuario.Image,
      'Solicitudes':usuario.Solicitudes,
    });
  }

  Future<void> restaPuntos(String id, int puntos) {
    _db.collection("Usuario").doc(id).update({
      'Puntos': usuario.Nombre,

    });
  }

  addToken(String token, String id) {
    _db.collection("Usuario").where('id', isEqualTo: id).get()
        .then((value) =>
    {
      value.docs.forEach((element) {
        _db.collection("Usuario").doc(element.id.toString()).update({
          "tokens": FieldValue.arrayUnion([token])
        });
      })
    });
  }

  Future<List<String>> getToken(String id) async {
    List<String> lista = [];
    await _db.collection("Usuario").where('id', isEqualTo: id).get()
        .then((value) =>
    {
      value.docs.forEach((element) {
        if(element.data()!=null){
          lista=(element.data()["tokens"].cast<String>());
        }
      })
    });
    return lista;
  }
  Future<String> getNUser(String id) async {
    String nombre = "";
    await _db.collection("Usuario").where('id', isEqualTo: id).get()
        .then((value) =>
    {
      value.docs.forEach((element) {
        if(element.data()!=null){
          nombre=(element.data()["NUser"]);
        }
      })
    });
    return nombre;
  }

  Future<void> savePhoto(Usuario  usuario, File image, bool hasImg) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat("yyyy-dd-M--HH-mm-ss").format(now);

      usuario.Image=usuario.Nombre+"_"+formattedDate;
      FirebaseStorage storage= FirebaseStorage.instance;
      Reference ref = storage.ref().child(usuario.Image);
      UploadTask uploadTask = ref.putFile(image);



    }
  Future<String> getImagen(String img)async{
    if(img!=''){
      var ref = FirebaseStorage.instance.ref().child(img);
      return ref.getDownloadURL();
    }else{
      var ref = FirebaseStorage.instance.ref().child('');
      return ref.getDownloadURL();
    }

  }

  Future<int> recuperaPuntos(String id)async{

      int nombre = 0;
      _db.collection("Usuario").where('id', isEqualTo: id).get()
          .then((value) =>
      {
        value.docs.forEach((element) {
          nombre=(element.data()["Puntos"]);

        })
      });
      return nombre;


  }

  Future<int> recuperaPuntos2(String id)async{

    var a = await _db
        .collection("Usuario")
        .where('id', isEqualTo:id ).get();

    return a.docs.first["Puntos"];


  }
  Future<String> recuperaNombre(String id)async{

    var a = await _db
        .collection("Usuario")
        .where('id', isEqualTo:id ).get();

    return a.docs.first["Nombre"];


  }Future<String> recuperaImagen(String id)async{

    var a = await _db
        .collection("Usuario")
        .where('id', isEqualTo:id ).get();

    return a.docs.first["Image"];


  }
  }

