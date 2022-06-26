import 'package:flutter_test/flutter_test.dart';
import 'package:tfgflutter/src/model/solicitud_model.dart';
import 'package:tfgflutter/src/ranking.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:tfgflutter/src/mock/mock.dart';


void main() {
  setupFirebaseAuthMocks();
  setUpAll(() async {
    await Firebase.initializeApp();
  });


  testWidgets('editar anuncio test', (WidgetTester tester) async {
    final firestores = FakeFirebaseFirestore();
    await firestores.collection("Solicitud").add({
      'Titulo': 'Ayuda mascota',
      'Descripcion': "Esta tarde",
      'Puntos': '300',
      'Provincia': 'Girona',
      'id': '14',
    });

    var es = await firestores.collection("Solicitud").where(
        "id", isEqualTo: "14").get();


    await tester.pumpWidget(MaterialApp(home: Scaffold(
      body: Column(

          children: [


            Container(

                child: Form(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    TextFormField(
                      initialValue: es.docs.first["Titulo"],
                      decoration: InputDecoration(
                        icon: Icon(Icons.title),
                        labelText: "Título",
                      ),

                    ),
                    TextFormField(
                      maxLines: 4,
                      minLines: 4,
                      keyboardType: TextInputType.multiline,
                      initialValue:
                      es.docs.first["Descripcion"],
                      decoration: InputDecoration(
                        icon: Icon(Icons.textsms),

                        labelText: "Descripción",
                      ),

                    ),
                    TextFormField(
                      initialValue:
                      es.docs.first["Provincia"],
                      decoration: InputDecoration(
                        icon: Icon(Icons.roofing),

                        labelText: "Provincia",
                      ),

                    ),
                    Padding(
                        padding: const EdgeInsets.all(8.0)
                    ),
                    Row(
                      children: [
                        Icon(Icons.monetization_on, color: Colors.grey),
                        Padding(
                            padding: const EdgeInsets.all(8.0)
                        ),

                        //sol.Puntos=pd.getrang();


                      ],
                    ),


                    Padding(
                        padding: const EdgeInsets.all(6.0)
                    ),

                    Padding(
                        padding: const EdgeInsets.all(10.0)
                    ),

                  ],
                ),
                )
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              //Center Row contents horizontally,
              crossAxisAlignment: CrossAxisAlignment.center,
              //Center Row contents vertically,
              children: [
                ElevatedButton(


                    style: ButtonStyle(alignment: Alignment.center,
                      backgroundColor: MaterialStateProperty.all(
                          Colors.lightBlue),
                    ),
                    child: Text(
                      "Realizar cambios", textAlign: TextAlign
                        .center,),


                    onPressed: () {
                      //ud.DataUser datosuser1 = ud.DataUser();
                    }
                ),
              ],
            ),


          ]),)));


    //await tester.tap(find.text("Acepto los Términos de servicio y la Política de privacidad"));

    await tester.pump();
    //expect(find.byKey(Key("textuser")),true);
    expect(find.text('Ayuda mascota'), findsWidgets);
    expect(find.text('Esta tarde'), findsWidgets);
    expect(find.text('Girona'), findsWidgets);
    expect(find.byIcon(Icons.monetization_on), findsWidgets);
    expect(find.byIcon(Icons.roofing), findsWidgets);
    expect(find.byIcon(Icons.textsms), findsWidgets);
    expect(find.byIcon(Icons.title), findsWidgets);
    expect(find.text('Valencia'), findsNothing);



    expect(find.text('Realizar cambios'), findsWidgets);

    //expect(find.text("Términos legales y Política de privacidad"),findsOneWidget);


  });
}