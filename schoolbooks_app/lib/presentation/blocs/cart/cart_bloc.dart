import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/network/api_client.dart';
import '../../../data/models/cart_model.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final ApiClient _apiClient;

  CartBloc({required ApiClient apiClient})
      : _apiClient = apiClient,
        super(const CartState()) {
    on<CartLoadRequested>(_onLoadRequested);
    on<CartAddItemRequested>(_onAddItemRequested);
    on<CartUpdateItemRequested>(_onUpdateItemRequested);
    on<CartRemoveItemRequested>(_onRemoveItemRequested);
    on<CartApplyCouponRequested>(_onApplyCouponRequested);
    on<CartRemoveCouponRequested>(_onRemoveCouponRequested);
    on<CartClearRequested>(_onClearRequested);
    on<CartWishlistAddRequested>(_onWishlistAddRequested);
    on<CartWishlistRemoveRequested>(_onWishlistRemoveRequested);
    on<CartWishlistLoadRequested>(_onWishlistLoadRequested);
  }

  Future<void> _onLoadRequested(
    CartLoadRequested event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(status: CartStatus.loading));
    try {
      final response = await _apiClient.get(ApiConstants.cart);
      final cart = CartModel.fromJson(response.data);
      emit(state.copyWith(status: CartStatus.loaded, cart: cart));
    } catch (e) {
      emit(state.copyWith(status: CartStatus.error, errorMessage: 'Failed to load cart'));
    }
  }

  Future<void> _onAddItemRequested(
    CartAddItemRequested event,
    Emitter<CartState> emit,
  ) async {
    try {
      await _apiClient.post(
        ApiConstants.cartItems,
        data: {
          'book_id': event.bookId,
          'quantity': event.quantity,
        },
      );
      add(CartLoadRequested());
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Failed to add item to cart'));
    }
  }

  Future<void> _onUpdateItemRequested(
    CartUpdateItemRequested event,
    Emitter<CartState> emit,
  ) async {
    try {
      await _apiClient.put(
        '${ApiConstants.cartItems}/${event.itemId}',
        data: {'quantity': event.quantity},
      );
      add(CartLoadRequested());
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Failed to update item'));
    }
  }

  Future<void> _onRemoveItemRequested(
    CartRemoveItemRequested event,
    Emitter<CartState> emit,
  ) async {
    try {
      await _apiClient.delete('${ApiConstants.cartItems}/${event.itemId}');
      add(CartLoadRequested());
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Failed to remove item'));
    }
  }

  Future<void> _onApplyCouponRequested(
    CartApplyCouponRequested event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(isApplyingCoupon: true));
    try {
      await _apiClient.post(
        ApiConstants.couponsValidate,
        data: {'code': event.couponCode},
      );
      add(CartLoadRequested());
      emit(state.copyWith(
        isApplyingCoupon: false,
        successMessage: 'Coupon applied successfully',
      ));
    } catch (e) {
      emit(state.copyWith(
        isApplyingCoupon: false,
        errorMessage: 'Invalid coupon code',
      ));
    }
  }

  Future<void> _onRemoveCouponRequested(
    CartRemoveCouponRequested event,
    Emitter<CartState> emit,
  ) async {
    add(CartLoadRequested());
  }

  Future<void> _onClearRequested(
    CartClearRequested event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(status: CartStatus.loading));
    try {
      await _apiClient.delete(ApiConstants.cart);
      emit(state.copyWith(
        status: CartStatus.loaded,
        cart: null,
        successMessage: 'Cart cleared',
      ));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Failed to clear cart'));
    }
  }

  Future<void> _onWishlistAddRequested(
    CartWishlistAddRequested event,
    Emitter<CartState> emit,
  ) async {
    try {
      await _apiClient.post(
        ApiConstants.wishlist,
        data: {'book_id': event.bookId},
      );
      emit(state.copyWith(successMessage: 'Added to wishlist'));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Failed to add to wishlist'));
    }
  }

  Future<void> _onWishlistRemoveRequested(
    CartWishlistRemoveRequested event,
    Emitter<CartState> emit,
  ) async {
    try {
      await _apiClient.delete('${ApiConstants.wishlist}/${event.itemId}');
      add(CartWishlistLoadRequested());
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Failed to remove from wishlist'));
    }
  }

  Future<void> _onWishlistLoadRequested(
    CartWishlistLoadRequested event,
    Emitter<CartState> emit,
  ) async {
    try {
      final response = await _apiClient.get(ApiConstants.wishlist);
      final wishlist = (response.data['items'] as List)
          .map((e) => WishlistItemModel.fromJson(e))
          .toList();
      emit(state.copyWith(wishlist: wishlist));
    } catch (e) {
      // Silently fail
    }
  }
}
