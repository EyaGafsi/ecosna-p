class Feed {
  final int id;
  final String title;
  final String description;
  final String? imageUrl;

  Feed({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
  });

  factory Feed.fromJson(Map<String, dynamic> json) {
    return Feed(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image_url': imageUrl,
    };
  }
}
