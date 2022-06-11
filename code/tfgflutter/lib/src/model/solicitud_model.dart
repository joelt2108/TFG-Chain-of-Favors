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
    this.Search,
    this.Image,
    this.Estado='',
    this.Solicitantes,
    this.NSol='',
  }

      );

  String id;
  String Titulo;
  String Descripcion;
  String Poblacion;
  String NUser;
  String Puntos;
  List<String> Search;
  String Image;
  String Estado;
  List<String> Solicitantes;
  String NSol;


  factory Solicitud.fromJson(Map<String, dynamic> json) => Solicitud(
    id: json["id"],
    Titulo: json["Titulo"],
    Descripcion: json["Descripcion"],
    Poblacion: json["Poblacion"],
    NUser: json["NUser"],
    Puntos: json["Puntos"],
    Search: json["Search"],
    Image: json["Image"],
    Estado: json["Estado"],
    Solicitantes: json["Solicitantes"].cast<String>(),
    NSol: json["NSol"],

  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "Titulo": Titulo,
    "Descripcion": Descripcion,
    "Poblacion": Poblacion,
    "NUser": NUser,
    "Puntos": Puntos,
    "Search": Search,
    "Image": Image,
    "Estado": Estado,
    "Solicitantes": Solicitantes,
    "NSol": NSol,

  };


}