
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as fbst;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tfgflutter/src/model/chat_model.dart';
import 'package:tfgflutter/src/provider/user_provider.dart';
import 'package:tfgflutter/src/solicitud.dart';

import '../model/mensaje_model.dart';

class Chats_Provider{
  FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveChat(Chats chats) {
    _db.collection('Chats').add(chats.toJson());
  }

  Future<int> verificaChat(String aux)  {

    var myMapQuery = (_db
        .collection("Chats")
        .where('id', isEqualTo: aux)
        ).snapshots().length;

    return myMapQuery;
  }

  Future<QuerySnapshot<Map<String,dynamic>>> validaChat(String aux) async {
    return await _db.collection("Chats").where('id',isEqualTo: aux).get();
  }

  Future<QuerySnapshot<Map<String,dynamic>>> validaChat2(String aux) async {
    return await _db.collection("Chats").where('id',isEqualTo: aux).get();
  }

  Stream<QuerySnapshot> getChat1(String us1,String us2) {
    return _db.collection("Chats").where('Usuario1', isEqualTo: us1).where('Usuario2',isEqualTo: us2).snapshots();
  }
  Stream<QuerySnapshot> getChat2(String us1,String us2) {
    return _db.collection("Chats").where('Usuario1', isEqualTo: us2).where('Usuario2',isEqualTo: us1).snapshots();
  }


  Future<void> addMessatgeToChat(String id,List<dynamic> mensaje) {
    _db.collection("Chats").doc(id).update({
      "Mensajes": FieldValue.arrayUnion(mensaje)
  });
        }






}