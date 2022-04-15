import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tfgflutter/src/model/solicitud_model.dart';

class Solicitud_Provider{
  FirebaseFirestore _db = FirebaseFirestore.instance;


  Future<void> saveSolicitud(Solicitud solicitud) {
    _db.collection('Solicitud').add(solicitud.toJson());
  }
  Stream<QuerySnapshot> getSolicitud(String id) {
    return _db.collection("Solicitud").where('id', isEqualTo: id).snapshots();
  }

  Future<void> updateSolicitud(String id, Solicitud solicitud) {
    _db.collection("Solicitud").doc(id).update({
      'Titulo': solicitud.Titulo,
      'Descripcion': solicitud.Descripcion,
      'Poblacion': solicitud.Poblacion,
      'NUser': solicitud.NUser,
      'Puntos': solicitud.Puntos,
    });
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
    return _db.collection("Solicitud").snapshots();

  }

  Stream<QuerySnapshot> cargarSolicitudesSearch(String query) {

      return _db.collection("Solicitud").where('Titulo', isGreaterThanOrEqualTo: query, isLessThan: query.substring(0, query.length-1) + String.fromCharCode(query.codeUnitAt(query.length - 1) + 1)).snapshots();
  }

  Stream<QuerySnapshot> cargarMisAnuncios(String id) {
    //return _db.collection("Solicitud").where("hide",isEqualTo: false).snapshots();
    return _db.collection("Solicitud").where('id',isEqualTo: id).snapshots();

  }
  }