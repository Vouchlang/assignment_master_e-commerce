class Item {
  late bool isLiked;
  late String image, name, price, sold;
  Item({
    required this.image,
    required this.name,
    required this.price,
    required this.sold,
    this.isLiked = false,
  });
}

List<Item> itemList = [
  Item(image: 'assets/addidas.jpg', name: 'Addidas', price: '\$450', sold: '1500'),
  Item(image: 'assets/af1.jpg', name: 'Air Force 1', price: '\$100', sold: '110'),
  Item(image: 'assets/boot1.jpg', name: 'Nike Emm', price: '\$125', sold: '650'),
  Item(image: 'assets/boot2.jpg', name: 'Nike Tempo', price: '\$123', sold: '899'),
  Item(image: 'assets/boot3.jpg', name: 'Nike Hike', price: '\$300', sold: '152'),
  Item(image: 'assets/samba.jpg', name: 'Samba', price: '\$220', sold: '2100'),
];
