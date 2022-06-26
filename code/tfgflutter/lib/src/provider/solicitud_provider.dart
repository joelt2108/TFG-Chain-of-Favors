import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tfgflutter/src/model/solicitud_model.dart';
import 'package:tfgflutter/src/provider/user_provider.dart';
import 'package:tfgflutter/src/solicitud.dart';

class Solicitud_Provider{
  FirebaseFirestore _db = FirebaseFirestore.instance;


  Future<void> saveSolicitud(Solicitud solicitud) {
    _db.collection('Solicitud').add(solicitud.toJson());
  }
  Stream<QuerySnapshot> getSolicitud(String id) {
    return _db.collection("Solicitud").where('id', isEqualTo: id).snapshots();
  }
  Stream<DocumentSnapshot> cargaSolicitud(String id){
  return _db.collection("Solicitud").doc(id).snapshots();
  }

  Future<void> updateSolicitud(String id, Solicitud solicitud) {
    _db.collection("Solicitud").doc(id).update({
      'Titulo': solicitud.Titulo,
      'Descripcion': solicitud.Descripcion,
      'Poblacion': solicitud.Poblacion,
      'Puntos': solicitud.Puntos,
      'Solicitantes': solicitud.Solicitantes,
      'NSol': solicitud.NSol,

    });
  }

  Future<void> updateSolicitud2Titulo(String id, Solicitud solicitud) {
    _db.collection("Solicitud").doc(id).update({
      'Titulo': solicitud.Titulo,
      'Descripcion': solicitud.Descripcion,
      'Poblacion': solicitud.Poblacion,
      'Puntos': solicitud.Puntos,

    });
  }


  Future<void> updateok(String id, Solicitud solicitud) {
    _db.collection("Solicitud").doc(id).update({
      'NSol':solicitud.NSol,
      'Estado':solicitud.Estado,

    });
  }

Future<List>  getData(String id) async {
    // initialize your list here
    var items = List<dynamic>();

    await _db.collection("Solicitud").doc('id').collection("Solicitantes").get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach(
        // add data to your list

            (f) => items.add(f.data()),
      );
    });
    return items;
  }

  Future<void> updateSolicitudSolicitante(String id, String valor, Solicitud solicitud, List<String> lista ) {


    //solicitud.Solicitantes=[];

    //solicitud.Solicitantes.add(valor);
    _db.collection("Solicitud").doc(id).update({
      "Solicitantes": FieldValue.arrayUnion(lista.cast<String>()),

    });


  }

  Future<void> borrarSolicitud(String id, List<String> lista ) {


    //solicitud.Solicitantes=[];

    //solicitud.Solicitantes.add(valor);
    _db.collection("Solicitud").doc(id).update({
      "Solicitantes": FieldValue.arrayRemove(lista.cast<String>()),

    });


  }


  Future<void> updateSolicitudAsignada(String id) {


    //solicitud.Solicitantes=[];

    //solicitud.Solicitantes.add(valor);
    _db.collection("Solicitud").doc(id).update({
      "Solicitantes":id,

    }
      );


  }

  Future<void> FinalizarFavor(String id, String estado) {


    //solicitud.Solicitantes=[];

    //solicitud.Solicitantes.add(valor);
    _db.collection("Solicitud").doc(id).update({
      "Estado":estado,

    }
    );


  }
  addToken(String token, String id) {
    _db.collection("Solicitud").where('id', isEqualTo: id).get()
        .then((value) =>
    {
      value.docs.forEach((element) {
        _db.collection("Solicitud").doc(element.id.toString()).update({
          "tokens": FieldValue.arrayUnion([token])
        });
      })
    });
  }

  Future<List<String>> getToken(String id) async {
    List<String> lista = [];
    await _db.collection("Solicitud").where('id', isEqualTo: id).get()
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

  Stream<QuerySnapshot> cargarSolicitudes() {
    //return _db.collection("Solicitud").where("hide",isEqualTo: false).snapshots();
    return _db.collection("Solicitud").where("Estado", isEqualTo: "Sin asignar").snapshots();

  }

  Stream<QuerySnapshot> cargarSolicitantes() {
    //return _db.collection("Solicitud").where("hide",isEqualTo: false).snapshots();
    return _db.collection("Solicitantes").snapshots();

  }

  Stream<QuerySnapshot> cargarSolicitudesAsignadas(String us) {
    //return _db.collection("Solicitud").where("hide",isEqualTo: false).snapshots();
    return _db.collection("Solicitud").where("NSol", isEqualTo: us).where("Estado", isEqualTo: "Asignada").snapshots();

  }
  Stream<QuerySnapshot> cargarSolicitudesPendientes(String us) {
    //return _db.collection("Solicitud").where("hide",isEqualTo: false).snapshots();
    return _db.collection("Solicitud").where("Solicitantes", arrayContains: us).where("NSol", isNotEqualTo: us).snapshots();

  }

  Stream<QuerySnapshot> cargarSolicitudesFinalizadas(String us) {
    //return _db.collection("Solicitud").where("hide",isEqualTo: false).snapshots();
    return _db.collection("Solicitud").where("NSol", isEqualTo: us).where("Estado", isEqualTo: "Finalizado").snapshots();

  }
  Stream<QuerySnapshot> cargarSolicitudesSearch(String query) {

      return _db.collection("Solicitud").where('Titulo', isGreaterThanOrEqualTo: query, isLessThan: query.substring(0, query.length-1) + String.fromCharCode(query.codeUnitAt(query.length - 1) + 1)).snapshots();
  }

  Stream<QuerySnapshot> cargarSolicitudesSearchFiltrado(String query, String Poblacion) {

    return _db.collection("Solicitud").where('Titulo', isGreaterThanOrEqualTo: query, isLessThan: query.substring(0, query.length-1) + String.fromCharCode(query.codeUnitAt(query.length - 1) + 1) ).where("Poblacion",isEqualTo:Poblacion).snapshots();
  }
  Stream<QuerySnapshot> cargarSolicitudesSearchPuntos(String query, String Puntos) {

    return _db.collection("Solicitud").where('Titulo', isGreaterThanOrEqualTo: query, isLessThan: query.substring(0, query.length-1) + String.fromCharCode(query.codeUnitAt(query.length - 1) + 1) ).where("Puntos",isEqualTo:Puntos).snapshots();
  }
  Stream<QuerySnapshot> cargarSolicitudesSearchPuntosPobl(String query,String Poblacion, String Puntos) {

    return _db.collection("Solicitud").where('Titulo', isGreaterThanOrEqualTo: query, isLessThan: query.substring(0, query.length-1) + String.fromCharCode(query.codeUnitAt(query.length - 1) + 1) ).where("Poblacion",isEqualTo:Poblacion).where("Puntos",isEqualTo:Puntos).snapshots();
  }

  Stream<QuerySnapshot> cargarMisAnuncios(String id) {
    //return _db.collection("Solicitud").where("hide",isEqualTo: false).snapshots();
    return _db.collection("Solicitud").where('id',isEqualTo: id).where('Estado',isNotEqualTo: 'Finalizado').snapshots();

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
Stream<QuerySnapshot> eliminarAnuncio(String id){
  _db.collection("Solicitud").doc(id).delete();
}

  }