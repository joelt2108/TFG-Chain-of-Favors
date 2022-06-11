import 'package:flutter_test/flutter_test.dart';
import 'package:tfgflutter/src/model/solicitud_model.dart';
import 'package:tfgflutter/src/login.dart';
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

    final LoginPage authService = LoginPage();
    var widget= authService;


    await tester.pumpWidget(MaterialApp(home:widget));
    expect(find.text("Email"),findsOneWidget);
    expect(find.text("Password"),findsOneWidget);
    expect(find.text("Iniciar Sesión"),findsOneWidget);


    expect(find.text("Contraseña"),findsNothing);


    //await tester.tap(find.text("Acepto los Términos de servicio y la Política de privacidad"));

    await tester.pump();

    //expect(find.text("Términos legales y Política de privacidad"),findsOneWidget);


  });


}