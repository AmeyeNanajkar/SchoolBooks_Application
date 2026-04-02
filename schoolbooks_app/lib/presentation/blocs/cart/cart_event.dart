import 'package:equatable/equatable.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class CartLoadRequested extends CartEvent {}

class CartAddItemRequested extends CartEvent {
  final String bookId;
  final int quantity;

  const CartAddItemRequested({
    required this.bookId,
    this.quantity = 1,
  });

  @override
  List<Object?> get props => [bookId, quantity];
}

class CartUpdateItemRequested extends CartEvent {
  final String itemId;
  final int quantity;

  const CartUpdateItemRequested({
    required this.itemId,
    required this.quantity,
  });

  @override
  List<Object?> get props => [itemId, quantity];
}

class CartRemoveItemRequested extends CartEvent {
  final String itemId;

  const CartRemoveItemRequested({required this.itemId});

  @override
  List<Object?> get props => [itemId];
}

class CartApplyCouponRequested extends CartEvent {
  final String couponCode;

  const CartApplyCouponRequested({required this.couponCode});

  @override
  List<Object?> get props => [couponCode];
}

class CartRemoveCouponRequested extends CartEvent {}

class CartClearRequested extends CartEvent {}

class CartWishlistAddRequested extends CartEvent {
  final String bookId;

  const CartWishlistAddRequested({required this.bookId});

  @override
  List<Object?> get props => [bookId];
}

class CartWishlistRemoveRequested extends CartEvent {
  final String itemId;

  const CartWishlistRemoveRequested({required this.itemId});

  @override
  List<Object?> get props => [itemId];
}

class CartWishlistLoadRequested extends CartEvent {}
