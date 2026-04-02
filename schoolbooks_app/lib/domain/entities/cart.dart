import 'package:equatable/equatable.dart';
import 'book.dart';

class CartItem extends Equatable {
  final String id;
  final String bookId;
  final int quantity;
  final Book? book;
  final DateTime addedAt;

  const CartItem({
    required this.id,
    required this.bookId,
    this.quantity = 1,
    this.book,
    required this.addedAt,
  });

  double get totalPrice => (book?.effectivePrice ?? 0) * quantity;

  @override
  List<Object?> get props => [id, bookId, quantity, book, addedAt];
}

class Cart extends Equatable {
  final String id;
  final String userId;
  final List<CartItem> items;
  final String? appliedCouponCode;
  final double discountAmount;
  final DateTime updatedAt;

  const Cart({
    required this.id,
    required this.userId,
    this.items = const [],
    this.appliedCouponCode,
    this.discountAmount = 0,
    required this.updatedAt,
  });

  double get subtotal => items.fold(0, (sum, item) => sum + item.totalPrice);
  double get total => subtotal - discountAmount;
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  @override
  List<Object?> get props => [id, userId, items, appliedCouponCode, discountAmount, updatedAt];
}

class WishlistItem extends Equatable {
  final String id;
  final String bookId;
  final Book? book;
  final DateTime addedAt;

  const WishlistItem({
    required this.id,
    required this.bookId,
    this.book,
    required this.addedAt,
  });

  @override
  List<Object?> get props => [id, bookId, book, addedAt];
}
