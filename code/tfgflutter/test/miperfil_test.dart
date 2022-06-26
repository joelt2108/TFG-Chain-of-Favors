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



  testWidgets('test profile', (WidgetTester tester) async {
    final firestores = FakeFirebaseFirestore();
    await firestores.collection("Usuario").add({
      'NUser': 'Usertest',
      'Nombre': "Juan",
      'Poblacion': 'Barcelona',
      'Apellidos': 'Lopez Lopez',
      'DNI': '12345678A',
      'id': '14',
    });

    var es = await firestores.collection("Usuario").where(
        "id", isEqualTo: "14").get();



    await tester.pumpWidget(MaterialApp(home:Scaffold(
      body: Column(

      children: [
        TextFormField(

            initialValue:
            es.docs.first["Nombre"],
            decoration: InputDecoration(
              icon: Icon(Icons.person),
            ),

        ),
        TextFormField(
          initialValue:
          es.docs.first["Apellidos"],
          decoration: InputDecoration(
            icon: Icon(Icons.person),
          ),

        ),
        TextFormField(
          initialValue:
          es.docs.first["Poblacion"],
          decoration: InputDecoration(
            icon: Icon(Icons.person),
          ),

        ),

        TextFormField(
          key: Key('textuser'),

          initialValue:
          es.docs.first["NUser"],
          decoration: InputDecoration(
            icon: Icon(Icons.person),
          ),

        ),

        TextFormField(
          initialValue:
          es.docs.first["DNI"],
          decoration: InputDecoration(
            icon: Icon(Icons.person),
          ),

        ),

            Text("Foto de perfil: ",
              style: TextStyle(fontSize: 12),),
            ElevatedButton(onPressed: () {

              //_openImagePicker();
              //usuario.Image=_image.toString();

            },
                child: Text("Subir foto de galería",
                    style: TextStyle(fontSize: 12))),
            Padding(padding: const EdgeInsets.symmetric(
                horizontal: 2.0)),
            ElevatedButton(onPressed: () {

              //usuario.Image=_image.toString();
            },
                child: Text("Realizar fotografía",
                    style: TextStyle(fontSize: 12))),



        Padding(
            padding: const EdgeInsets.all(10.0)
        ),

      ],
    ),)));


    //await tester.tap(find.text("Acepto los Términos de servicio y la Política de privacidad"));

    await tester.pump();
    //expect(find.byKey(Key("textuser")),true);
    expect(find.text('Barcelona'), findsWidgets);
    expect(find.text('Juan'), findsWidgets);
    expect(find.text('Usertest'), findsWidgets);
    expect(find.text('Lopez Lopez'), findsWidgets);
    expect(find.text('12345678A'), findsWidgets);
    expect(find.byIcon(Icons.person),findsWidgets);

    expect(find.text('Valencia'), findsNothing);


    expect(find.text('Subir foto de galería'), findsWidgets);

    expect(find.text('Realizar fotografía'), findsWidgets);

    //expect(find.text("Términos legales y Política de privacidad"),findsOneWidget);


  });





}