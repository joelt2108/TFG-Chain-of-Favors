import 'package:chat_bubbles/bubbles/bubble_normal.dart';
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



  testWidgets('test chat', (WidgetTester tester) async {
    final firestores = FakeFirebaseFirestore();
    await firestores.collection("Mensaje").add({
      'Emisor': 'Usertest1',
      'Contenido': "Hola, que tal",
      'Fecha': '12/06/2022, 12:10',
      'id': '17',
    });

    var es = await firestores.collection("Mensaje").where(
        "id", isEqualTo: "17").get();



    await tester.pumpWidget(MaterialApp(home: Column(

        children: [
          Padding(
            padding: EdgeInsets.all(3.0),
          ),


          Container(

            child: Column(


              children: [

                Row(
                  children: [

                  ],
                ),

                BubbleNormal(
                    text: es.docs.first["Contenido"].toString(),
                    color: Colors.lightBlue,
                    textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 20
                    )


                ),



                //Text(mensa.get("Texto").toString()
                //usuario.Nombre = solicitud.get('Nombre'),
                //onChanged: (value) => usuario.Nombre = value,





                Padding(
                    padding: const EdgeInsets.all(5.0)
                ),



                Row(
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(left: 245)
                    ),

                    Text(es.docs.first["Fecha"],style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 13,
                    ),),
                  ],
                ),
                //buildMessageInput(chat.docs.first.id),

              ],

            ),

          ),


        ]),));


    //await tester.tap(find.text("Acepto los Términos de servicio y la Política de privacidad"));

    await tester.pump();
    expect(find.text('Hola, que tal'), findsWidgets);
    expect(find.text('12/06/2022, 12:10'), findsWidgets);
    expect(find.text('Usertest1'), findsNothing);

    //expect(find.text("Términos legales y Política de privacidad"),findsOneWidget);


  });


}