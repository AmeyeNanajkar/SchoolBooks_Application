import 'package:equatable/equatable.dart';
import '../../../domain/entities/cart.dart';

enum CartStatus {
  initial,
  loading,
  loaded,
  error,
}

class CartState extends Equatable {
  final CartStatus status;
  final Cart? cart;
  final List<WishlistItem> wishlist;
  final String? errorMessage;
  final String? successMessage;
  final bool isApplyingCoupon;

  const CartState({
    this.status = CartStatus.initial,
    this.cart,
    this.wishlist = const [],
    this.errorMessage,
    this.successMessage,
    this.isApplyingCoupon = false,
  });

  CartState copyWith({
    CartStatus? status,
    Cart? cart,
    List<WishlistItem>? wishlist,
    String? errorMessage,
    String? successMessage,
    bool? isApplyingCoupon,
  }) {
    return CartState(
      status: status ?? this.status,
      cart: cart ?? this.cart,
      wishlist: wishlist ?? this.wishlist,
      errorMessage: errorMessage,
      successMessage: successMessage,
      isApplyingCoupon: isApplyingCoupon ?? this.isApplyingCoupon,
    );
  }

  @override
  List<Object?> get props => [status, cart, wishlist, errorMessage, successMessage, isApplyingCoupon];
}
