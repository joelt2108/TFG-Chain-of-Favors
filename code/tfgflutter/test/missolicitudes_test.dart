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



  testWidgets('test mis solicitudes', (WidgetTester tester) async {
    final firestores = FakeFirebaseFirestore();
    await firestores.collection("Solicitud").add({
      'Titulo': 'Ayuda plantas',
      'Estado': "Asignada",
      'NSol': 'user1',
      'NUser': 'user2',
      'Puntos':'150',
      'id':'10',
    });
    await firestores.collection("Solicitud").add({
      'Titulo': 'Ayuda perro',
      'Estado': "Sin asignar",
      'NSol': '',
      'NUser': 'user23',
      'Puntos':'250',
      'id':'11',
    });
    await firestores.collection("Solicitud").add({
      'Titulo': 'Ayuda rueda',
      'Estado': "Finalizado",
      'NSol': 'user2',
      'NUser': 'user12',
      'Puntos':'350',
      'id':'12',
    });
    var es1 = await firestores.collection("Solicitud").where(
        "Estado", isEqualTo: "Asignada").get();

    var es2 = await firestores.collection("Solicitud").where(
        "Estado", isEqualTo: "Sin asignar").get();

    var es3 = await firestores.collection("Solicitud").where(
        "Estado", isEqualTo: "Finalizado").get();

    await tester.pumpWidget(MaterialApp(home:Row(
        children: <Widget>[
          Column(
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(4.0)
              ),

            ],
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.all(2.0)
                ),
                Row(
                  children: [
                    Flexible(
                      child:Text("El usuario "+ es1.docs.first["NUser"]+ " ha aceptado tu solicitud por el favor: "+ es1.docs.first["Titulo"],
                        style: TextStyle(
                            fontSize:18.0,
                            fontStyle: FontStyle.italic),
                      ),
                    ) ,


                  ],
                ),

              ],
            ),
          )
        ]
    ),));


    //await tester.tap(find.text("Acepto los Términos de servicio y la Política de privacidad"));

    await tester.pump();
    expect(find.text('El usuario user2 ha aceptado tu solicitud por el favor: Ayuda plantas'), findsWidgets);
    //expect(find.text('12'), findsWidgets);
    expect(find.text('100'), findsNothing);



    await tester.pumpWidget(MaterialApp(home:Column(
      children: <Widget>[

        Row(
          children: [

            Flexible(
              child:Text( es2.docs.first["Titulo"] ,
                style: TextStyle(
                  fontSize:18.0,
                ),
              ),
            ) ,

          ],
        ),


        //SizedBox(width: 1), // give it width






        Padding(
            padding: const EdgeInsets.all(1.0)
        ),

      ],
    ),));


    //await tester.tap(find.text("Acepto los Términos de servicio y la Política de privacidad"));

    await tester.pump();
    expect(find.text('Ayuda perro'), findsWidgets);
    //expect(find.text('12'), findsWidgets);
    expect(find.text('100'), findsNothing);

    //expect(find.text("Términos legales y Política de privacidad"),findsOneWidget);

    await tester.pumpWidget(MaterialApp(home:
      Column(
      children: <Widget>[

        Row(
          children: [

            Flexible(
              child:Text("¡Felicidades! Has completado el favor "+ es3.docs.first["Titulo"]+", obteniendo "+ es3.docs.first["Puntos"] +" puntos.",
                style: TextStyle(
                    fontSize:18.0,
                    fontStyle: FontStyle.italic),
              ),
            ) ,

          ],
        ),


      ],
    )
  ));
    print("¡Felicidades! Has completado el favor "+ es3.docs.first["Titulo"]+", obteniendo "+ es3.docs.first["Puntos"] +" puntos.");
    await tester.pump();
    expect(find.text('¡Felicidades! Has completado el favor Ayuda rueda, obteniendo 350 puntos.'), findsWidgets);
    //expect(find.text('12'), findsWidgets);
    expect(find.text('100'), findsNothing);

  });







}