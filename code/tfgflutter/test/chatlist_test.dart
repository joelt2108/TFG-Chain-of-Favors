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



  testWidgets('contactos test', (WidgetTester tester) async {
    final firestores = FakeFirebaseFirestore();
    await firestores.collection("Usuario").add({
      'NUser': 'Usertest',
      'Poblacion': 'Barcelona',
      'id': '14',
    });

    var es = await firestores.collection("Usuario").where(
        "id", isEqualTo: "14").get();



    await tester.pumpWidget(MaterialApp(home:Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,

      children: [


        Container(
            margin: const EdgeInsets.only(left: 10.0),
            child:Text(es.docs.first["NUser"],
              style: TextStyle(
                  fontSize:18.0,
                  fontWeight: FontWeight.bold),
            )
        ),
        Text(es.docs.first["Poblacion"],
            style: TextStyle(
              fontSize:18.0,)
          //fontWeight: FontWeight.bold),
        ) ,






      ],
    ),));


    //await tester.tap(find.text("Acepto los Términos de servicio y la Política de privacidad"));

    await tester.pump();
    expect(find.text('Usertest'), findsWidgets);
    expect(find.text('Barcelona'), findsWidgets);
    expect(find.text('User22'), findsNothing);

    //expect(find.text("Términos legales y Política de privacidad"),findsOneWidget);


  });


}