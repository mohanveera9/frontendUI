class SosParentModel {
  final String id;
  final String phno;
  final String name;
  final String email;
  final String? type; // Optional since it's not in all entries
  final List<SosChildModel>? parentArray;

  SosParentModel({
    required this.id,
    required this.phno,
    required this.name,
    required this.email,
    this.type,
    this.parentArray,
  });

  factory SosParentModel.fromJson(Map<String, dynamic> json) {
    return SosParentModel(
      id: json['_id'],
      phno: json['phno'],
      name: json['name'],
      email: json['email'],
      type: json['type'],
      parentArray: json['__parentArray'] != null
          ? (json['__parentArray'] as List)
              .map((child) => SosChildModel.fromJson(child))
              .toList()
          : null,
    );
  }
}

class SosChildModel {
  final String id;
  final String name;
  final String phno;
  final String email;

  SosChildModel({
    required this.id,
    required this.name,
    required this.phno,
    required this.email,
  });

  factory SosChildModel.fromJson(Map<String, dynamic> json) {
    return SosChildModel(
      id: json['_id'],
      name: json['name'],
      phno: json['phno'],
      email: json['email'],
    );
  }
}
