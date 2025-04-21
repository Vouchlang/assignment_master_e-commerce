class CartItem {
  final int id, quantity, itemPrice, productId;
  final String username, itemImage, itemName, itemSold;

  CartItem({
    required this.id,
    required this.quantity,
    required this.itemPrice,
    required this.productId,
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
      productId: int.parse(json['productId']),
      username: json['username'],
      itemImage: json['itemImage'],
      itemName: json['itemName'],
      itemSold: json['itemSold'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quantity': quantity,
      'itemPrice': itemPrice,
      'productId': productId,
      'username': username,
      'itemImage': itemImage,
      'itemName': itemName,
      'itemSold': itemSold,
    };
  }
}
