import 'package:flutter_test/flutter_test.dart';
import 'package:tfgflutter/src/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:tfgflutter/src/mock/mock.dart';


//final FakeFirebaseFirestore fakeFirebaseFirestore = FakeFirebaseFirestore();

void main(){
  setupFirebaseAuthMocks();
  setUpAll(() async {
    await Firebase.initializeApp();
  });


  MyHomePage mhp=MyHomePage();


    final _scaffoldKey = GlobalKey<ScaffoldState>();
    testWidgets('side menu', (WidgetTester tester1) async {
      await tester1.pumpWidget(
        MaterialApp(
          home: Scaffold(
            key: _scaffoldKey,
            drawer: Drawer(
              child: ListView(
                // Remove padding
                children: [

                  ListTile(
                    leading: Icon(Icons.library_books),
                    title: Text('Tablón de anuncios'),
                    //onTap: () => _navigateHome(),
                  ),
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text('Mis Anuncios'),
                    //onTap: () => _navigateMisAnuncios(),
                  ),
                  ListTile(
                    leading: Icon(Icons.share),
                    title: Text('Mis Solicitudes'),
                    //onTap: () => _navigateMisSolicitudes(),
                  ),
                  ListTile(
                    leading: Icon(Icons.notifications),
                    title: Text('Chats'),
                    //onTap: () => _navigateChat(),
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Mi Perfil'),
                    //onTap: () => _navigateMiPerfil(),
                  ),
                  ListTile(
                    leading: Icon(Icons.description),
                    title: Text('Ránking'),
                    //onTap: () => _navigateRanking(),
                  ),



                ],
              ),
            ),
               ),
          ),
      );


      _scaffoldKey.currentState.openDrawer();
      await tester1.pumpAndSettle();



      expect(find.text("Mi Perfil"), findsOneWidget);
      expect(find.text("Chats"), findsOneWidget);
      expect(find.text("Mis Solicitudes"), findsOneWidget);
      expect(find.byIcon(Icons.description),findsOneWidget);
      expect(find.byIcon(Icons.settings),findsOneWidget);



  });
  testWidgets('title', (WidgetTester tester) async {

  final MyHomePage authService = MyHomePage();
  var widget= authService;


    await tester.pumpWidget(MaterialApp(home:widget));
  expect(find.text("Tablón de anuncios"),findsWidgets);
  });

  testWidgets('list items home', (WidgetTester tester) async {


    final firestores = FakeFirebaseFirestore();
    await firestores.collection("Solicitud").add({
      'Titulo': 'Necesito ayuda',
      'Puntos': "200",
      'Poblacion':'Barcelona',
      'id':'11',
    });

    var es=await firestores.collection("Solicitud").where("id",isEqualTo: "11").get();
  
    

    await tester.pumpWidget(MaterialApp(home:
      Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(12.0)
            ),
            Container(
                margin: const EdgeInsets.only(left: 20.0),
                child:Text(es.docs.first["Titulo"].toString()
                )
            ),
            Padding(
                padding: const EdgeInsets.all(1.0)
            ),
            Container(
                margin: const EdgeInsets.only(left: 20.0),
                child:Text(es.docs.first["Poblacion"].toString()
                  //fontWeight: FontWeight.bold),
                )
            ),
            Container(
              margin: const EdgeInsets.only(left: 20.0),
              //child:Text(tipoC)
            ),
            Padding(
                padding: const EdgeInsets.all(1.0)
            ),
            Container(
                margin: const EdgeInsets.only(left: 20.0),
                child:Text(es.docs.first["Puntos"].toString())
            ),
            Padding(
                padding: const EdgeInsets.all(1.0)
            ),

            Padding(
                padding: const EdgeInsets.all(1.0)
            ),
          ],
        ),
    ),
    );
    // Re-render.
    await tester.pump();
    expect(find.text('Necesito ayuda'), findsWidgets);
    expect(find.text('200'), findsWidgets);
    expect(find.text('Barcelona'), findsWidgets);
    expect(find.text('100'), findsNothing);


  });
  }