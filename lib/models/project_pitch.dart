import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
class ProjectIdea {
  late String id;
  late String name;
  late String description;
  late int askingPrice;
  late double equity;
  late String owner;

  ProjectIdea({
    required this.id,
    required this.name,
    required this.description,
    required this.askingPrice,
    required this.equity,
    required this.owner,
  });
}
