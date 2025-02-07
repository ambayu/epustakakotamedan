class Instansi {
  final int id;
  final String name;

  Instansi({required this.id, required this.name});

  factory Instansi.fromJson(Map<String, dynamic> json) {
    return Instansi(
      id: json['id'],
      name: json['name'],
    );
  }
}
