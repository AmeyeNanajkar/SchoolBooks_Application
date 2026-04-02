import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/network/api_client.dart';
import '../../../data/models/order_model.dart';
import 'orders_event.dart';
import 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final ApiClient _apiClient;

  OrdersBloc({required ApiClient apiClient})
      : _apiClient = apiClient,
        super(const OrdersState()) {
    on<OrdersLoadRequested>(_onLoadRequested);
    on<OrdersLoadMoreRequested>(_onLoadMoreRequested);
    on<OrdersCreateRequested>(_onCreateRequested);
    on<OrdersCancelRequested>(_onCancelRequested);
    on<OrdersTrackRequested>(_onTrackRequested);
    on<OrdersRefreshRequested>(_onRefreshRequested);
  }

  Future<void> _onLoadRequested(
    OrdersLoadRequested event,
    Emitter<OrdersState> emit,
  ) async {
    emit(state.copyWith(status: OrdersStatus.loading));
    try {
      final response = await _apiClient.get(
        ApiConstants.orders,
        queryParameters: {'page': event.page, 'limit': event.limit},
      );
      final orders = (response.data['items'] as List)
          .map((e) => OrderModel.fromJson(e))
          .toList();
      emit(state.copyWith(
        status: OrdersStatus.loaded,
        orders: orders,
        currentPage: 1,
        hasReachedMax: orders.length < event.limit,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: OrdersStatus.error,
        errorMessage: 'Failed to load orders',
      ));
    }
  }

  Future<void> _onLoadMoreRequested(
    OrdersLoadMoreRequested event,
    Emitter<OrdersState> emit,
  ) async {
    if (state.hasReachedMax) return;
    emit(state.copyWith(status: OrdersStatus.loadingMore));
    try {
      final response = await _apiClient.get(
        ApiConstants.orders,
        queryParameters: {'page': state.currentPage + 1, 'limit': 20},
      );
      final newOrders = (response.data['items'] as List)
          .map((e) => OrderModel.fromJson(e))
          .toList();
      emit(state.copyWith(
        status: OrdersStatus.loaded,
        orders: [...state.orders, ...newOrders],
        currentPage: state.currentPage + 1,
        hasReachedMax: newOrders.length < 20,
      ));
    } catch (e) {
      emit(state.copyWith(status: OrdersStatus.loaded));
    }
  }

  Future<void> _onCreateRequested(
    OrdersCreateRequested event,
    Emitter<OrdersState> emit,
  ) async {
    emit(state.copyWith(status: OrdersStatus.creating));
    try {
      final response = await _apiClient.post(
        ApiConstants.orders,
        data: {
          'address_id': event.addressId,
          'payment_method': event.paymentMethod.name,
          'coupon_code': event.couponCode,
        },
      );
      final order = OrderModel.fromJson(response.data);
      emit(state.copyWith(
        status: OrdersStatus.created,
        selectedOrder: order,
        successMessage: 'Order placed successfully',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: OrdersStatus.error,
        errorMessage: 'Failed to create order',
      ));
    }
  }

  Future<void> _onCancelRequested(
    OrdersCancelRequested event,
    Emitter<OrdersState> emit,
  ) async {
    try {
      await _apiClient.put(
        '${ApiConstants.orders}/${event.orderId}/cancel',
        data: {'reason': event.reason},
      );
      add(const OrdersLoadRequested());
      emit(state.copyWith(successMessage: 'Order cancelled'));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Failed to cancel order'));
    }
  }

  Future<void> _onTrackRequested(
    OrdersTrackRequested event,
    Emitter<OrdersState> emit,
  ) async {
    emit(state.copyWith(status: OrdersStatus.loading));
    try {
      final response = await _apiClient.get('${ApiConstants.orders}/${event.orderId}/track');
      final order = OrderModel.fromJson(response.data);
      emit(state.copyWith(
        status: OrdersStatus.loaded,
        selectedOrder: order,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: OrdersStatus.error,
        errorMessage: 'Failed to track order',
      ));
    }
  }

  Future<void> _onRefreshRequested(
    OrdersRefreshRequested event,
    Emitter<OrdersState> emit,
  ) async {
    add(const OrdersLoadRequested());
  }
}
