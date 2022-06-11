import 'dart:async';
import 'package:intl/date_symbol_data_local.dart';
import 'package:rxdart/rxdart.dart';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tfgflutter/src/detallesanuncio.dart';
import 'package:tfgflutter/src/model/mensaje_model.dart';
import 'package:tfgflutter/src/model/chat_model.dart';
import 'package:tfgflutter/src/provider/chat_provider.dart';
import 'package:chat_bubbles/chat_bubbles.dart';


import 'package:tfgflutter/src/provider/mensaje_provider.dart';
import 'controller/userdata.dart' as ud;
import 'package:tfgflutter/main.dart';
import 'package:tfgflutter/src/provider/user_provider.dart';
import 'package:tfgflutter/src/provider/solicitud_provider.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'model/user_model.dart';
import 'model/solicitud_model.dart';


class Chat extends StatefulWidget {
  Chat(this.email,this.email2 ,this.nuser2,{Key key, this.title}) : super(key: key);
  final String title;
  final String email;
final String email2;
final String nuser2;


// This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {

  String _selectedItem;
  Solicitud solicitud= new Solicitud();
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descipcionController = TextEditingController();
  final TextEditingController _puntosController = TextEditingController();
  final TextEditingController _nuserController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final usuarioProvider = new Usuario_Provider();
  //user.PreferenciasUsuario datosUser = user.PreferenciasUsuario();
  ud.DataUser datosuser = ud.DataUser();
  List<dynamic> listaFinal;
  final FocusNode focusNode = FocusNode();
  final TextEditingController textEditingController = TextEditingController();
  Chats_Provider chprov=Chats_Provider();
  Mensaje_Provider msjprov=Mensaje_Provider();
  Stream<QuerySnapshot> ChatsLoad;
  String groupChatId = '';
  List<QueryDocumentSnapshot> listMessages = [];
  final ScrollController scrollController = ScrollController();
  Usuario_Provider uprovi=new Usuario_Provider();



  String help;
  List<QueryDocumentSnapshot> helpi;
  Mensaje mensajess=new Mensaje();

  List<QueryDocumentSnapshot> helpi2;


 void initState()  {
    super.initState();
    setState(() {});
    GlobalKey<FormState> keyForm= new GlobalKey();
    //var he= await uprovi.cargaUsuarioChat(widget.email2);



  }


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [


              Container(

                child:
                Row(
                //

            children: [

                Text(widget.nuser2 , style: TextStyle(
                    color: Colors.white
                ),),
            ],
          )

                 ),
            ],
          ),

        ),
        body: SafeArea(


            child: Column(
              children: [
                buildListMessage(),

                buildMessageInput(),
              ],
            ),
          ),


        );
  }

  void _uploadSolicitud () async
  {
    //_rellenarItems();
    ud.DataUser datosuser = ud.DataUser();

    Solicitud_Provider pr = new Solicitud_Provider();
    Usuario_Provider upr = new Usuario_Provider();
    //upr.getUsuario(datosuser.email);
    solicitud.id=datosuser.email;

    solicitud.NUser=listaFinal[0].get("NUser").toString();
    solicitud.Poblacion=listaFinal[0].get("Poblacion").toString();
    solicitud.Estado="Sin asignar";
    //solicitud.Search=parametersSearch(solicitud.Titulo);
    solicitud.Image=listaFinal[0].get("Image").toString();
    solicitud.Solicitantes=new List();

    pr.saveSolicitud(solicitud);
    Navigator.pop(context);

  }
  Widget buildListMessage() {
    return Flexible(
      child: StreamBuilder (
        stream: msjprov.getMensajes15(widget.email, widget.email2,mensajess),
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot1) {
          if (snapshot1.hasData) {
            helpi= snapshot1.data.docs;


                  return ListView.builder(
                    itemCount: snapshot1.data.size,
                    itemBuilder: (context, index) =>

                        buildItem(index, snapshot1.data.docs[index]),


                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),




    );
  }
  Widget _cargarDatosChat(BuildContext context, QuerySnapshot chat){

    return GestureDetector(
      key: UniqueKey(),

      child:
      Container(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(2.0),
                      ),


                      Container(

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Padding(
                                padding: const EdgeInsets.all(6.0)
                            ),

                            Text(chat.docs.first["Usuario1"]
                              //usuario.Nombre = solicitud.get('Nombre'),
                              //onChanged: (value) => usuario.Nombre = value,

                            ),


                            Padding(
                                padding: const EdgeInsets.all(15.0)
                            ),

                            Padding(
                                padding: const EdgeInsets.all(200.0)
                            ),

                            //buildMessageInput(),

                          ],

                        ),

                      )




                    ]),

              ),
            ],),

        ),),);

  }

  Widget buildItem(int index, DocumentSnapshot mensa) {

        if (mensa.get("Emisor") == widget.email) {
          // right side (my message)
          return GestureDetector(
            key: UniqueKey(),

            child:
            Container(
              padding: const EdgeInsets.all(1.0),
              child: Container(
                decoration: BoxDecoration(
                  //color: Colors.lightBlueAccent,

                  borderRadius: BorderRadius.circular(1.0),
                ),


                child: Row(


                  children: <Widget>[

                    Column(
                      children: <Widget>[


                      ],
                    ),

                    Flexible(
                      child: Column(

                          children: [
                            Padding(
                              padding: EdgeInsets.all(3.0),
                            ),


                            Container(

                              child: Column(


                                children: [

                                  Row(
                                    children: [

                                    ],
                                  ),

                                  BubbleNormal(
                                      text: mensa.get("Texto").toString(),
                                    color: Colors.lightBlue,
                                      textStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20
                                      )


                                  ),



                                  //Text(mensa.get("Texto").toString()
                                    //usuario.Nombre = solicitud.get('Nombre'),
                                    //onChanged: (value) => usuario.Nombre = value,





                                  Padding(
                                      padding: const EdgeInsets.all(5.0)
                                  ),



                                  Row(
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.only(left: 245)
                                      ),

                                      Text(DateFormat('dd MMM yyyy, hh:mm a').format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              int.parse(mensa.get("Time")))),style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontSize: 13,
                                      ),),
                                    ],
                                  ),
                                  //buildMessageInput(chat.docs.first.id),

                                ],

                              ),

                            ),


                          ]),


                    ),

                  ],),


              ),),


          );
        }
        else{
          return GestureDetector(
            key: UniqueKey(),

            child:
            Container(
              padding: const EdgeInsets.all(1.0),
              child: Container(
                decoration: BoxDecoration(
                  //color: Colors.lightBlueAccent,

                  borderRadius: BorderRadius.circular(1.0),
                ),


                child: Row(



                  children: <Widget>[

                    Column(
                      children: <Widget>[


                      ],
                    ),

                    Flexible(
                      child: Column(

                          children: [
                            Padding(
                              padding: EdgeInsets.all(1.0),
                            ),


                            Container(


                              child: Column(


                                children: [

                                  BubbleNormal(
                                    
                                      text: mensa.get("Texto").toString(),
                                      color: Colors.grey,
                                      isSender: false,
                                      textStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20
                                      ),

                                  ),
                                  

                                  //Text(mensa.get("Texto").toString()
                                  //usuario.Nombre = solicitud.get('Nombre'),
                                  //onChanged: (value) => usuario.Nombre = value,





                                  Padding(
                                      padding: const EdgeInsets.all(5.0)
                                  ),


                                Row(
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.only(left: 15)
                                    ),

                                    Text(DateFormat('dd MMM yyyy, hh:mm a').format(
                                        DateTime.fromMillisecondsSinceEpoch(
                                            int.parse(mensa.get("Time")))),style: TextStyle(
                                      fontStyle: FontStyle.italic,fontSize: 13,
                                    ),),
                                  ],
                                ),




                                  //buildMessageInput(chat.docs.first.id),

                                ],

                              ),

                            ),


                          ]),


                    ),

                  ],),


              ),),


          );
        }

  }


  Widget buildMessageInput() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 2.0),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(1.0,
            )),

          ),
          Flexible(
              child: TextField(
                focusNode: focusNode,
                textInputAction: TextInputAction.send,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.sentences,
                controller: textEditingController,
                decoration:
                InputDecoration(
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (value) {
                  value='';
                  //String ayuda=value;
                  
                  //onSendMessage(textEditingController.text, MessageType.text);
                },
              )),
          Container(
            margin: const EdgeInsets.only(left:4.0),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: IconButton(
              onPressed: () async {
                Mensaje mensaje=new Mensaje();

                List<String> particio=[];
                List<String> claves=[];
                mensaje.Texto=textEditingController.text;
                mensaje.Emisor=datosuser.email;
                mensaje.Destinatario=widget.email2;
                mensaje.Time=DateTime.now().millisecondsSinceEpoch.toString();
                particio.add(datosuser.email);
                mensaje.ArrayAux=particio;
                Usuario_Provider uprov=new Usuario_Provider();
                var res=await uprov.cargaUsuarioChat(widget.email);
                var res2=await uprov.cargaUsuarioChat(widget.email2);
                mensaje.ImgDestinatario=res2.docs.first["Image"];
                mensaje.ImgEmisor=res.docs.first["Image"];
                claves.add(widget.email+widget.email2);
                claves.add(widget.email2+widget.email);
                mensaje.Claves=claves;
                DocumentReference documentReference=FirebaseFirestore.instance.collection('Mensaje').doc();
                mensaje.id=documentReference.id;
                Map partici = {
                  widget.email:true,
                  widget.email2:true,
                  "tiempo":DateTime.now().millisecondsSinceEpoch.toString(),
                };
                //partici.add(mensaje.Emisor);
                //partici.add(mensaje.Destinatario);
                mensaje.Participantes=partici;

                


                Mensaje_Provider mepr=new Mensaje_Provider();
                //Chats chats=new Chats();

                mepr.saveMensaje(mensaje);


                QuerySnapshot querySnap = await FirebaseFirestore.instance.collection('Mensaje').where('Time',isEqualTo: mensaje.Time).get();
                QueryDocumentSnapshot doc = querySnap.docs[0];
                DocumentReference docRef = doc.reference;
                msjprov.updateIDMensaje(docRef.id, mensaje);


              FirebaseFirestore.instance.collection('Mensaje').doc(docRef.id).collection('Participants').add({
               widget.email: 'true',
                widget.email2: 'true',
                "tiempo": mensaje.Time,
              });




                //onSendMessage(textEditingController.text, MessageType.text);
                textEditingController.clear();
              },
              icon: const Icon(Icons.send_rounded),
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }






}

