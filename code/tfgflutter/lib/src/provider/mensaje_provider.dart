
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as fbst;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tfgflutter/src/model/chat_model.dart';
import 'package:tfgflutter/src/provider/user_provider.dart';
import 'package:tfgflutter/src/solicitud.dart';

import '../model/mensaje_model.dart';

class Mensaje_Provider{
  FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveMensaje(Mensaje mensaje) {
    _db.collection('Mensaje').add(mensaje.toJson()



    );
  }

  Future<void> updateIDMensaje(String id, Mensaje mensaje) {
    _db.collection("Mensaje").doc(id).update({
      'id': id,

    });
  }



  Stream<QuerySnapshot> getMensajes1(String us1,String us2, Mensaje mensaje) {
    FieldPath hlola=(new FieldPath(["Participantes","$us1"]));
    FieldPath hlola2=(new FieldPath(["Participantes","$us2"]));
    print(hlola);

    //return _db.collection("Mensaje").where('Participantes.$us1', isEqualTo: true).snapshots();
   return _db.collection("Mensaje").where(new FieldPath(["Participantes","$us1"]), isEqualTo: true).where(new FieldPath(["Participantes","$us2"]), isEqualTo: true).snapshots();

  }

  Stream<QuerySnapshot> getMensajes15(String us1,String us2, Mensaje mensaje) {
    
    String ayuda=us1+us2;
    return _db.collection("Mensaje").where("Claves", arrayContains: ayuda).orderBy("Time",descending: false).snapshots();
    //return _db.collection("Mensaje").where('Participantes.$us1', isEqualTo: true).snapshots();
    //return _db.collection("Mensaje").doc("id").collection("Participants").where(FieldPath([us1]), isEqualTo: "true").where(FieldPath([us2]), isEqualTo: "true").orderBy("tiempo",descending: true).snapshots();

  }

  Stream<QuerySnapshot> getMensajes1old(String us1,String us2) {
    return _db.collection("Mensaje").where('Emisor', whereIn: [us1,us2]).snapshots();
  }

  List<Future<QuerySnapshot<Object>>> getMensajes12(String us1,String us2) {
    List<Future<QuerySnapshot>> futures = [];

    var firstQuery= _db.collection("Mensaje").where(us1, isEqualTo: 'Emisor').where(us2,isEqualTo: 'Destinatario').get();
    var secondQuery= _db.collection("Mensaje").where(us2, isEqualTo: 'Emisor').where(us1,isEqualTo: 'Destinatario').get();

    futures.add(firstQuery);
    futures.add(secondQuery);

    return futures;


  }

  Future<QuerySnapshot<Map<String,dynamic>>> getIdMensaje(String aux) async {
    return await _db.collection("Mensaje").where('id',isEqualTo: aux).get();
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




}