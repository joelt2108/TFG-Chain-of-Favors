import 'dart:convert';



Chats ChatsFromJson(String str) =>
    Chats.fromJson(json.decode(str));

String ChatsToJson(Chats data) => json.encode(data.toJson());

class Chats {
  Chats({
    this.id,
    this.Usuario1,
    this.Usuario2,
    this.Mensajes,


  }

      );

  String id;
  String Usuario1;
  String Usuario2;
  List<String> Mensajes;

  factory Chats.fromJson(Map<String, dynamic> json) => Chats(
    id: json["id"],
    Usuario1: json["Usuario1"],
    Usuario2: json["Usuario2"],
    Mensajes: json["Mensajes"],



  );
  Map<String, dynamic> toJson() => {
    "id": id,
    "Usuario1": Usuario1,
    "Usuario2": Usuario2,
    "Mensajes": Mensajes,

  };
}