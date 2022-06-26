import 'package:flutter_test/flutter_test.dart';
import 'package:tfgflutter/src/model/solicitud_model.dart';
import 'package:tfgflutter/src/solicitud.dart';
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



  testWidgets('find solicitud elements', (WidgetTester tester) async {

    final CreateSolicitud authService = CreateSolicitud();
    var widget= authService;


    await tester.pumpWidget(MaterialApp(home:widget));
    expect(find.text("Crear Solicitud"),findsOneWidget);
    expect(find.text("Descripción"),findsOneWidget);
    expect(find.text("Puntos ofrecidos"),findsOneWidget);
    expect(find.text("Publicar solicitud"),findsOneWidget);
    expect(find.text("Contraseña"),findsNothing);

    expect(find.text("Tablón de anuncios"),findsNothing);


  });


}