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



  testWidgets('test mis anuncios', (WidgetTester tester) async {
    final firestores = FakeFirebaseFirestore();
    await firestores.collection("Solicitud").add({
      'Titulo': 'Necesito ayuda con el perro',
      'Descripcion': "Es urgente",
      'Poblacion': 'Valencia',
      'Puntos': '250',
      'NUser': 'usertest2',
      'id': '15',
    });

    var es = await firestores.collection("Solicitud").where(
        "id", isEqualTo: "15").get();



    await tester.pumpWidget(MaterialApp(home:Column(

      children: [


        Text(es.docs.first["Titulo"],style: TextStyle( fontSize: 10, fontWeight: FontWeight.bold
        )
          //usuario.Nombre = solicitud.get('Nombre'),
          //onChanged: (value) => usuario.Nombre = value,

        ),


        Text(es.docs.first["Descripcion"]),

        Text("Provincia: " + es.docs.first["Poblacion"]),

        Text("Puntos ofrecidos: " + es.docs.first["Puntos"]),
        Icon(Icons.monetization_on),




        Text("Solicitante: "),

        Text(" "+ es.docs.first["NUser"],style: TextStyle(fontStyle: FontStyle.italic)),





      ],
    ),

    ));


    //await tester.tap(find.text("Acepto los Términos de servicio y la Política de privacidad"));

    await tester.pump();
    expect(find.text('Necesito ayuda con el perro'), findsWidgets);
    expect(find.text('Puntos ofrecidos: 250'), findsWidgets);
    expect(find.text('Provincia: Valencia'), findsWidgets);
    expect(find.text('Es urgente'), findsWidgets);
    expect(find.text(' usertest2'), findsWidgets);
    expect(find.byIcon(Icons.monetization_on), findsWidgets);
    expect(find.text("Barcelona"),findsNothing);

    //expect(find.text("Términos legales y Política de privacidad"),findsOneWidget);
    await firestores.collection("Usuario").add({
      'Poblacion': 'Sevilla',

      'NUser': 'usertest2',
      'id': '16',
    });

    var es1 = await firestores.collection("Usuario").where(
        "id", isEqualTo: "16").get();


    await tester.pumpWidget(MaterialApp(home:Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,

      children: [

        Container(
            margin: const EdgeInsets.only(left: 20.0),
            child:Text(es1.docs.first["NUser"],
              style: TextStyle(
                  fontSize:18.0,
                  fontWeight: FontWeight.bold),
            )
        ),
        Padding(
            padding: const EdgeInsets.all(1.0)
        ),
        Container(
            margin: const EdgeInsets.only(left: 20.0),
            child:Text(es1.docs.first["Poblacion"],
                style: TextStyle(
                  fontSize:18.0,)
              //fontWeight: FontWeight.bold),
            )
        ),
        Padding(
          padding: EdgeInsets.only(right: 35.0),
        ),
        Container(
          alignment: Alignment.topRight,


        ),
        CupertinoButton(
            onPressed: (){

            }, child: Icon(Icons.check_circle,color: Colors.green,size: 18,)),
        //SizedBox(width: 1), // give it width

        CupertinoButton(
            onPressed: (){


              // _refresh();
            }, child: Icon(Icons.cancel,color: Colors.red,size: 18,)),

      ],
    ),

    ));

    await tester.pump();
    expect(find.text('usertest2'), findsWidgets);
    expect(find.text('Sevilla'), findsWidgets);

    expect(find.text(' Málaga'), findsNothing);
    expect(find.byIcon(Icons.cancel), findsWidgets);
    expect(find.byIcon(Icons.check_circle), findsWidgets);

  });




}