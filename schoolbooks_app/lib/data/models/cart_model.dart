import '../../domain/entities/cart.dart';
import 'book_model.dart';

class CartItemModel extends CartItem {
  const CartItemModel({
    required super.id,
    required super.bookId,
    super.quantity,
    super.book,
    required super.addedAt,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'] as String,
      bookId: json['book_id'] as String,
      quantity: json['quantity'] as int? ?? 1,
      book: json['book'] != null ? BookModel.fromJson(json['book']) : null,
      addedAt: DateTime.parse(json['added_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'book_id': bookId,
      'quantity': quantity,
      'added_at': addedAt.toIso8601String(),
    };
  }
}

class CartModel extends Cart {
  const CartModel({
    required super.id,
    required super.userId,
    super.items,
    super.appliedCouponCode,
    super.discountAmount,
    required super.updatedAt,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      appliedCouponCode: json['applied_coupon_code'] as String?,
      discountAmount: (json['discount_amount'] as num?)?.toDouble() ?? 0,
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'items': items.map((e) => (e as CartItemModel).toJson()).toList(),
      'applied_coupon_code': appliedCouponCode,
      'discount_amount': discountAmount,
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class WishlistItemModel extends WishlistItem {
  const WishlistItemModel({
    required super.id,
    required super.bookId,
    super.book,
    required super.addedAt,
  });

  factory WishlistItemModel.fromJson(Map<String, dynamic> json) {
    return WishlistItemModel(
      id: json['id'] as String,
      bookId: json['book_id'] as String,
      book: json['book'] != null ? BookModel.fromJson(json['book']) : null,
      addedAt: DateTime.parse(json['added_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'book_id': bookId,
      'added_at': addedAt.toIso8601String(),
    };
  }
}
