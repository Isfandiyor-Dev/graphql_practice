class Product {
  String id;
  String title;
  double price;
  String description;
  Map<String, dynamic> category;
  List<String>? images;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    this.images,
  });

  // JSON'dan Product ob'ektiga o'tkazish metodi
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      title: json['title'],
      price: json['price'].toDouble(),
      description: json['description'],
      category: json['category'],
      images: json['images'] != null ? List<String>.from(json['images']) : null,
    );
  }

  // Product ob'ektidan JSON'ga o'tkazish metodi
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'images': images,
    };
  }
}
