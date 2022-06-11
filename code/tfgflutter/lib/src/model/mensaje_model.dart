import 'dart:convert';



Mensaje MensajeFromJson(String str) =>
    Mensaje.fromJson(json.decode(str));

String MensajeToJson(Mensaje data) => json.encode(data.toJson());

class Mensaje {
  Mensaje({
    this.id,
    this.Texto,
    this.Emisor,
    this.Destinatario,
    this.Time,
    this.Participantes,
    this.ImgEmisor,
    this.ImgDestinatario,
    this.ArrayAux,
    this.Claves,

  }

      );

  String id;
  String Texto;
  String Emisor;
  String Destinatario;
  String Time;
  Map Participantes;
  String ImgEmisor;
  String ImgDestinatario;
  List<String> ArrayAux;
  List<String> Claves;


  factory Mensaje.fromJson(Map<String, dynamic> json) => Mensaje(
    id: json["id"],
    Texto: json["Texto"],
    Emisor: json["Emisor"],
    Destinatario: json["Destinatario"],
    Time: json["Time"],
    Participantes: json["Participantes"],
    ImgDestinatario: json["ImgDestinatario"],
    ImgEmisor: json["ImgEmisor"],
    ArrayAux: json["ArrayAux"],
    Claves: json["Claves"],



  );
  Map<String, dynamic> toJson() => {
    "id": id,
    "Texto": Texto,
    "Emisor": Emisor,
    "Destinatario": Destinatario,
    "Time": Time,
    "Participantes": Participantes,
    "ImgEmisor": ImgEmisor,
    "ImgDestinatario": ImgDestinatario,
    "ArrayAux": ArrayAux,
    "Claves": Claves

  };
}