import 'package:flutter_test/flutter_test.dart';
import 'package:tfgflutter/src/model/solicitud_model.dart';
import 'package:tfgflutter/src/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:tfgflutter/src/mock/mock.dart';
import 'package:network_image_mock/network_image_mock.dart';

Widget makeTestableWidget() => MaterialApp(home: Image.network('https://firebasestorage.googleapis.com/v0/b/tfg-cadena.appspot.com/o/biglogo.png?alt=media&token=5e788e35-c138-42b3-bf0a-40bf60e6a3f7'));



void main(){
  setupFirebaseAuthMocks();
  setUpAll(() async {
    await Firebase.initializeApp();
  });

  testWidgets(
    'Imagen logo',
        (WidgetTester tester) async {
      mockNetworkImagesFor(() => tester.pumpWidget(makeTestableWidget()));
    },
  );

  testWidgets('find solicitud elements', (WidgetTester tester) async {

    final LoginPage authService = LoginPage();
    var widget= authService;

    await tester.pumpWidget(MaterialApp(home:widget));
    expect(find.text("Email"),findsOneWidget);
    expect(find.text("Contraseña"),findsWidgets);
    expect(find.text("Iniciar Sesión"),findsOneWidget);


    expect(find.text("Password"),findsNothing);


    //await tester.tap(find.text("Acepto los Términos de servicio y la Política de privacidad"));

    await tester.pump();

    //expect(find.text("Términos legales y Política de privacidad"),findsOneWidget);


  });


}