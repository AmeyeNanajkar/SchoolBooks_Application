import 'package:equatable/equatable.dart';
import '../../../domain/entities/order.dart';

abstract class OrdersEvent extends Equatable {
  const OrdersEvent();

  @override
  List<Object?> get props => [];
}

class OrdersLoadRequested extends OrdersEvent {
  final int page;
  final int limit;

  const OrdersLoadRequested({this.page = 1, this.limit = 20});

  @override
  List<Object?> get props => [page, limit];
}

class OrdersLoadMoreRequested extends OrdersEvent {}

class OrdersCreateRequested extends OrdersEvent {
  final String addressId;
  final PaymentMethod paymentMethod;
  final String? couponCode;

  const OrdersCreateRequested({
    required this.addressId,
    required this.paymentMethod,
    this.couponCode,
  });

  @override
  List<Object?> get props => [addressId, paymentMethod, couponCode];
}

class OrdersCancelRequested extends OrdersEvent {
  final String orderId;
  final String? reason;

  const OrdersCancelRequested({required this.orderId, this.reason});

  @override
  List<Object?> get props => [orderId, reason];
}

class OrdersTrackRequested extends OrdersEvent {
  final String orderId;

  const OrdersTrackRequested({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

class OrdersRefreshRequested extends OrdersEvent {}
