class Evento {
  int id;
  String tipo;
  String entidade;
  String local;
  String data;
  String hora;

  Evento({this.id, this.tipo, this.entidade, this.local, this.data, this.hora});

  factory Evento.fromJson(Map<String, dynamic> json) => Evento(
        id: json['id'],
        tipo: json['tipo'],
        entidade: json['entidade'],
        local: json['local'],
      );
}
