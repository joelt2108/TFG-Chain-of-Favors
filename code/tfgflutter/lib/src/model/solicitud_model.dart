import 'dart:convert';



Solicitud SolicitudFromJson(String str) =>
    Solicitud.fromJson(json.decode(str));

String SolicitudToJson(Solicitud data) => json.encode(data.toJson());

class Solicitud {
  Solicitud({
    this.id,
    this.Titulo = '',
    this.Descripcion = '',
    this.Poblacion = '',
    this.NUser = '',
    this.Puntos='',

  }

      );

  String id;
  String Titulo;
  String Descripcion;
  String Poblacion;
  String NUser;
  String Puntos;


  factory Solicitud.fromJson(Map<String, dynamic> json) => Solicitud(
    id: json["id"],
    Titulo: json["Titulo"],
    Descripcion: json["Descripcion"],
    Poblacion: json["Poblacion"],
    NUser: json["NUser"],
    Puntos: json["Puntos"],

  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "Titulo": Titulo,
    "Descripcion": Descripcion,
    "Poblacion": Poblacion,
    "NUser": NUser,
    "Puntos": Puntos,

  };
}