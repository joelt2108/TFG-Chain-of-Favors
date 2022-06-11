import 'package:flutter_test/flutter_test.dart';
import 'package:tfgflutter/src/model/solicitud_model.dart';
import 'package:tfgflutter/src/register.dart';
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

    final RegistroPage authService = RegistroPage();
    var widget= authService;


    await tester.pumpWidget(MaterialApp(home:widget));
    expect(find.text("Nombre"),findsOneWidget);
    expect(find.text("Apellidos"),findsOneWidget);
    expect(find.text("DNI"),findsOneWidget);
    expect(find.text("Email"),findsOneWidget);
    expect(find.text("Nombre de Usuario"),findsOneWidget);
    expect(find.text("Fecha de nacimiento"),findsOneWidget);
    expect(find.text("Provincia"),findsOneWidget);
    expect(find.text("Acepto los Términos de servicio y la Política de privacidad"),findsOneWidget);

    expect(find.text("Términos legales y Política de privacidad"),findsNothing);


    //await tester.tap(find.text("Acepto los Términos de servicio y la Política de privacidad"));

    await tester.pump();

    //expect(find.text("Términos legales y Política de privacidad"),findsOneWidget);


  });


}