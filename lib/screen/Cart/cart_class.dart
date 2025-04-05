class CartItem {
  final int id, quantity, itemPrice;
  final String username, itemImage, itemName, itemSold;

  CartItem({
    required this.id,
    required this.quantity,
    required this.itemPrice,
    required this.username,
    required this.itemImage,
    required this.itemName,
    required this.itemSold,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: int.parse(json['id']),
      quantity: int.parse(json['quantity']),
      itemPrice: int.parse(json['itemPrice']),
      username: json['username'],
      itemImage: json['itemImage'],
      itemName: json['itemName'],
      itemSold: json['itemSold'],
    );
  }
}
