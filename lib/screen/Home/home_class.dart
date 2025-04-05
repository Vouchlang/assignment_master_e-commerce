class Item {
  late bool isLiked;
  late int id, price, sold;
  late String image, name;
  Item({
    required this.id,
    required this.price,
    required this.image,
    required this.name,
    required this.sold,
    this.isLiked = false,
  });

  factory Item.fromJson(Map<dynamic, dynamic> json) {
    return Item(
      id: int.parse((json['itemID'] ?? json['id']).toString()), // Safe fallback: use itemID if available, else id
      price: int.parse(json['itemPrice'].toString()),
      image: json['itemImage'],
      name: json['itemName'],
      sold: int.parse(json['itemSold'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'itemPrice': price,
      'itemImage': image,
      'itemName': name,
      'itemSold': sold,
    };
  }
}
