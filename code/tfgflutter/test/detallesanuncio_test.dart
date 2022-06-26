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



  testWidgets('vista detalles', (WidgetTester tester) async {
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



          ElevatedButton(onPressed: ()   async {


            //chats.Mensajes=[];




          },
              child: Icon(Icons.mail_outline)),

          ElevatedButton(onPressed: () {

            //sl.Solicitantes.add(datosuser.email);
          },

              child: Text("Realizar solicitud",
                  style: TextStyle(fontSize: 12))),


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
    expect(find.byIcon(Icons.mail_outline), findsWidgets);

    expect(find.text('Realizar solicitud'), findsWidgets);
    expect(find.text("Barcelona"),findsNothing);

    //expect(find.text("Términos legales y Política de privacidad"),findsOneWidget);


  });


}