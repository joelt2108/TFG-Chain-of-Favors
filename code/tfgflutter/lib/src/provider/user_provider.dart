import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tfgflutter/src/model/user_model.dart';

class Usuario_Provider{
  FirebaseFirestore _db = FirebaseFirestore.instance;


  Future<void> saveUsuario(Usuario usuario) {
    _db.collection('Usuario').add(usuario.toJson());
  }
  Stream<QuerySnapshot> getUsuario(String id) {
    return _db.collection("Usuario").where('id', isEqualTo: id).snapshots();
  }


  Future<void> updateUsuario(String id, Usuario usuario) {
    _db.collection("Usuario").doc(id).update({
      'Nombre': usuario.Nombre,
      'Apellido': usuario.Apellido,
      'Poblacion': usuario.Poblacion,
      'NUser': usuario.NUser,
      'Image': usuario.Image,
      'DNI': usuario.DNI,
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

}