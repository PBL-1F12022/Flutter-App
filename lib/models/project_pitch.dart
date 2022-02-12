import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class ProjectIdea {
  final String id;
  final String name;
  final String description;
  final int askingPrice;
  final double equity;
  final String owner;

  ProjectIdea({
    required this.id,
    required this.name,
    required this.description,
    required this.askingPrice,
    required this.equity,
    required this.owner,
  });
}
