class Item {
  late bool isLiked;
  late int id, price;
  late String image, name, sold;
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
      id: int.parse(json['id'].toString()),
      price: int.parse(json['itemPrice'].toString()),
      image: json['itemImage'],
      name: json['itemName'],
      sold: json['itemSold'],
    );
  }
}

// List<Item> itemList = [
//   Item(price: 450, image: 'assets/addidas.jpg', name: 'Addidas', sold: '1500'),
//   Item(price: 100, image: 'assets/af1.jpg', name: 'Air Force 1', sold: '110'),
//   Item(price: 125, image: 'assets/boot1.jpg', name: 'Nike Emm', sold: '650'),
//   Item(price: 123, image: 'assets/boot2.jpg', name: 'Nike Tempo', sold: '899'),
//   Item(price: 300, image: 'assets/boot3.jpg', name: 'Nike Hike', sold: '152'),
//   Item(price: 220, image: 'assets/samba.jpg', name: 'Samba', sold: '2100'),
// ];
