import 'package:equatable/equatable.dart';
import '../../../domain/entities/order.dart';

enum OrdersStatus {
  initial,
  loading,
  loaded,
  loadingMore,
  creating,
  created,
  error,
}

class OrdersState extends Equatable {
  final OrdersStatus status;
  final List<Order> orders;
  final Order? selectedOrder;
  final String? errorMessage;
  final String? successMessage;
  final int currentPage;
  final bool hasReachedMax;

  const OrdersState({
    this.status = OrdersStatus.initial,
    this.orders = const [],
    this.selectedOrder,
    this.errorMessage,
    this.successMessage,
    this.currentPage = 1,
    this.hasReachedMax = false,
  });

  OrdersState copyWith({
    OrdersStatus? status,
    List<Order>? orders,
    Order? selectedOrder,
    String? errorMessage,
    String? successMessage,
    int? currentPage,
    bool? hasReachedMax,
  }) {
    return OrdersState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      selectedOrder: selectedOrder ?? this.selectedOrder,
      errorMessage: errorMessage,
      successMessage: successMessage,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [
        status,
        orders,
        selectedOrder,
        errorMessage,
        successMessage,
        currentPage,
        hasReachedMax,
      ];
}
