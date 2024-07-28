import 'package:equatable/equatable.dart';

class Menu extends Equatable {
  final int id;
  final String name, route, iconName;

  const Menu(
      {required this.id,
      required this.name,
      required this.route,
      required this.iconName});

  factory Menu.fromJson(Map<String, dynamic> json) => Menu(
      id: json['Id'] ?? 0,
      name: json['Name'] ?? '',
      route: json['Route'] ?? '',
      iconName: json['IconName'] ?? '');

  Map<String, dynamic> toJson() =>
      {'Id': id, 'Name': name, 'Route': route, 'IconName': iconName};

  @override
  // TODO: implement props
  List<Object?> get props => [id, name, route, iconName];
}
