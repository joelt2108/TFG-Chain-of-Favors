import 'dart:convert';



Usuario UsuarioFromJson(String str) =>
    Usuario.fromJson(json.decode(str));

String UsuarioToJson(Usuario data) => json.encode(data.toJson());

class Usuario {
  Usuario({
    this.id,
    this.Nombre = '',
    this.Apellido = '',
    this.Poblacion = '',
    this.NUser = '',
    this.Image='',
    this.DNI='',
    this.NFavores=0,
    this.Puntos=100,
    this.Solicitudes,
    this.Chats,
    this.Cookies=false,
  }

  );

  String id;
  String Nombre;
  String Apellido;
  String Image;
  String NUser;
  String Poblacion;
  String DNI;
  int NFavores;
  int Puntos;
  List<String> Solicitudes;
  List<String> Chats;
  bool Cookies;
  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
    id: json["id"],
    Nombre: json["Nombre"],
    Apellido: json["Apellido"],
    Poblacion: json["Poblacion"],
    NUser: json["NUser"],
    Image: json["Image"],
    DNI: json["DNI"],
    NFavores: json["NFavores"],
    Puntos: json["Puntos"],
    Solicitudes: json["Solicitudes"],
    Chats: json["Chats"],
    Cookies: json["Cookies"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "Nombre": Nombre,
    "Apellido": Apellido,
    "Poblacion": Poblacion,
    "NUser": NUser,
    "Image": Image,
    "DNI": DNI,
    "NFavores": NFavores,
    "Puntos": Puntos,
    "Solicitudes": Solicitudes,
    "Chats": Chats,
    "Cookies": Cookies,
  };
}