class Doctor {
  final String id;
  final String name;
  final String specialty;
  final String description;
  final String iconPath;
  final bool isAvailable;
  final List<String> tags;
  final String availabilityText;

  const Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.description,
    required this.iconPath,
    this.isAvailable = true,
    this.tags = const [],
    this.availabilityText = "Available Now",
  });

  // Backend-ready: Easy to convert from/to JSON
  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'],
      name: json['name'],
      specialty: json['specialty'],
      description: json['description'],
      iconPath: json['iconPath'],
      isAvailable: json['isAvailable'] ?? true,
      tags: List<String>.from(json['tags'] ?? []),
      availabilityText: json['availabilityText'] ?? "Available Now",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialty': specialty,
      'description': description,
      'iconPath': iconPath,
      'isAvailable': isAvailable,
      'tags': tags,
      'availabilityText': availabilityText,
    };
  }

  // Utility methods
  bool matchesSearch(String query) {
    final searchLower = query.toLowerCase();
    return name.toLowerCase().contains(searchLower) ||
           specialty.toLowerCase().contains(searchLower) ||
           tags.any((tag) => tag.toLowerCase().contains(searchLower));
  }
}
