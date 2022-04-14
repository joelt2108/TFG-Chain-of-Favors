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
  }

  );

  String id;
  String Nombre;
  String Apellido;
  String Image;
  String NUser;
  String Poblacion;
  String DNI;

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
    id: json["id"],
    Nombre: json["Nombre"],
    Apellido: json["Apellido"],
    Poblacion: json["Poblacion"],
    NUser: json["NUser"],
    Image: json["Image"],
    DNI: json["DNI"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "Nombre": Nombre,
    "Apellido": Apellido,
    "Poblacion": Poblacion,
    "NUser": NUser,
    "Image": Image,
    "DNI": DNI,
  };
}