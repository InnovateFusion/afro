import 'package:equatable/equatable.dart';

class RoleEntity extends Equatable {
  final String id;
  final String name;
  final String description;

  const RoleEntity({
    required this.id,
    required this.name,
    required this.description,
  });

  @override
  List<Object?> get props => [id, name, description];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }

  RoleEntity copyWith({
    String? id,
    String? name,
    String? description,
  }) {
    return RoleEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }

  String toJson() {
    return '''
    {
      "id": "$id",
      "name": "$name",
      "description": "$description"
    }
    ''';
  }
}
