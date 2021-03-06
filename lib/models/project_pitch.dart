

class ProjectIdea {
  final String id;
  final String name;
  final String description;
  final int askingPrice;
  final double equity;
  final String owner;
  final String ownerName;
  final double sectorAccuracy;
  final String sector;

  ProjectIdea({
    required this.id,
    required this.name,
    required this.description,
    required this.askingPrice,
    required this.equity,
    required this.owner,
    required this.ownerName,
    required this.sector,
    required this.sectorAccuracy,
  });

  factory ProjectIdea.fromJson(Map<String, dynamic> json) {
    return ProjectIdea(
      owner: json['owner'],
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      askingPrice: json['askingPrice'],
      equity: json['equity'],
      ownerName: json['ownerName'],
      sector: json['sector'],
      sectorAccuracy: json['sectorAccuracy'],
    );
  }
}
