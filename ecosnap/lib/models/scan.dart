class Scan {
  final int id;
  final String imageUrl;
  final String? result;
  final String? category;
  final bool? recyclable;
  final DateTime createdAt;

  Scan({
    required this.id,
    required this.imageUrl,
    required this.result,
    required this.category,
    required this.recyclable,
    required this.createdAt,
  });

  factory Scan.fromJson(Map<String, dynamic> json) {
    return Scan(
      id: json['id'],
      imageUrl: json['image'],
      result: json['result'],
      category: json['category'],
      recyclable: json['is_recyclable'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
