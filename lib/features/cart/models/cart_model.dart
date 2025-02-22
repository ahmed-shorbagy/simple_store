import 'package:equatable/equatable.dart';
import 'package:simple_store/features/home/models/product_model.dart';

class CartModel extends Equatable {
  final int id;
  final int userId;
  final DateTime date;
  final List<CartItem> products;
  final double total;

  const CartModel({
    required this.id,
    required this.userId,
    required this.date,
    required this.products,
    required this.total,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'] as int,
      userId: json['userId'] as int,
      date: DateTime.parse(json['date'] as String),
      products: (json['products'] as List<dynamic>)
          .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['products'] as List<dynamic>).fold(
        0.0,
        (sum, item) => sum + (item['price'] as num) * (item['quantity'] as num),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'date': date.toIso8601String(),
      'products': products.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [id, userId, date, products, total];
}

class CartItem extends Equatable {
  final ProductModel product;
  final int quantity;

  const CartItem({
    required this.product,
    required this.quantity,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: ProductModel.fromJson(json['product'] as Map<String, dynamic>),
      quantity: json['quantity'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': product.id,
      'quantity': quantity,
    };
  }

  double get total => product.price * quantity;

  @override
  List<Object?> get props => [product, quantity];
}
