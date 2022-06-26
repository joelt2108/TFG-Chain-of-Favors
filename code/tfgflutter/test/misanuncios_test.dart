import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tfgflutter/src/model/solicitud_model.dart';
import 'package:tfgflutter/src/ranking.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:tfgflutter/src/mock/mock.dart';


void main(){
  setupFirebaseAuthMocks();
  setUpAll(() async {
    await Firebase.initializeApp();
  });



  testWidgets('test ranking', (WidgetTester tester) async {
    final firestores = FakeFirebaseFirestore();
    await firestores.collection("Solicitud").add({
      'Titulo': 'Pasear Perros',
      'Descripcion': "Urgente",
      'Poblacion': 'Tarragona',
      'Puntos':'200',
      'id': '14',
    });

    var es = await firestores.collection("Solicitud").where(
        "id", isEqualTo: "14").get();



    await tester.pumpWidget(MaterialApp(home:Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.all(12.0)
        ),



        Container(
            margin: const EdgeInsets.only(left: 20.0),
            child:Text(es.docs.first["Titulo"],
              style: TextStyle(
                  fontSize:18.0,
                  fontWeight: FontWeight.bold),
            )
        ),
        //SizedBox(width: 1), // give it width





        Padding(
            padding: const EdgeInsets.all(1.0)
        ),
        Container(
            margin: const EdgeInsets.only(left: 20.0),
            child:Text(es.docs.first["Descripcion"],
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
            child:Text(es.docs.first["Poblacion"])
        ),
        Padding(
            padding: const EdgeInsets.all(1.0)
        ),
        Container(
            margin: const EdgeInsets.only(left: 20.0),
            child:Text(es.docs.first["Puntos"] +" Puntos")
        ),
        Padding(
            padding: const EdgeInsets.all(1.0)
        ),
        Row(children: [
          CupertinoButton(  padding: EdgeInsets.only(left:20),
              onPressed: (){

              }, child: Icon(Icons.edit,color: Colors.grey,size: 20,)),
          //SizedBox(width: 1), // give it width

          CupertinoButton(
              onPressed: (){

              }, child: Icon(Icons.delete,color: Colors.grey,size: 20,)),
        ],),
      ],
    ),));


    //await tester.tap(find.text("Acepto los Términos de servicio y la Política de privacidad"));

    await tester.pump();
    expect(find.text('Pasear Perros'), findsWidgets);
    expect(find.text('200 Puntos'), findsWidgets);
    expect(find.text('Urgente'), findsWidgets);
    expect(find.text('Tarragona'), findsWidgets);

    expect(find.text('100 Puntos'), findsNothing);
    expect(find.text('Barcelona'), findsNothing);
    expect(find.byIcon(Icons.edit),findsWidgets);
    expect(find.byIcon(Icons.delete),findsWidgets);


    //expect(find.text("Términos legales y Política de privacidad"),findsOneWidget);


  });


}