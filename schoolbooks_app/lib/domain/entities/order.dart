import 'package:equatable/equatable.dart';
import 'user.dart';

enum OrderStatus {
  pending,
  confirmed,
  processing,
  shipped,
  outForDelivery,
  delivered,
  cancelled,
  returned,
}

enum PaymentStatus {
  pending,
  paid,
  failed,
  refunded,
  partiallyRefunded,
}

enum PaymentMethod {
  upi,
  netBanking,
  creditCard,
  debitCard,
  wallet,
  cod,
}

class OrderItem extends Equatable {
  final String id;
  final String bookId;
  final String bookTitle;
  final String? bookImage;
  final int quantity;
  final double price;
  final double? discountedPrice;
  final String? vendorId;

  const OrderItem({
    required this.id,
    required this.bookId,
    required this.bookTitle,
    this.bookImage,
    required this.quantity,
    required this.price,
    this.discountedPrice,
    this.vendorId,
  });

  double get totalPrice => (discountedPrice ?? price) * quantity;

  @override
  List<Object?> get props => [id, bookId, bookTitle, bookImage, quantity, price, discountedPrice, vendorId];
}

class Order extends Equatable {
  final String id;
  final String orderNumber;
  final String userId;
  final User? user;
  final List<OrderItem> items;
  final Address shippingAddress;
  final OrderStatus status;
  final PaymentStatus paymentStatus;
  final PaymentMethod paymentMethod;
  final double subtotal;
  final double discountAmount;
  final double shippingCost;
  final double taxAmount;
  final double totalAmount;
  final String? couponCode;
  final String? trackingNumber;
  final String? trackingUrl;
  final String? invoiceUrl;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deliveredAt;
  final List<OrderStatusUpdate> statusHistory;

  const Order({
    required this.id,
    required this.orderNumber,
    required this.userId,
    this.user,
    required this.items,
    required this.shippingAddress,
    this.status = OrderStatus.pending,
    this.paymentStatus = PaymentStatus.pending,
    this.paymentMethod = PaymentMethod.upi,
    required this.subtotal,
    this.discountAmount = 0,
    this.shippingCost = 0,
    this.taxAmount = 0,
    required this.totalAmount,
    this.couponCode,
    this.trackingNumber,
    this.trackingUrl,
    this.invoiceUrl,
    required this.createdAt,
    this.updatedAt,
    this.deliveredAt,
    this.statusHistory = const [],
  });

  @override
  List<Object?> get props => [
        id,
        orderNumber,
        userId,
        user,
        items,
        shippingAddress,
        status,
        paymentStatus,
        paymentMethod,
        subtotal,
        discountAmount,
        shippingCost,
        taxAmount,
        totalAmount,
        couponCode,
        trackingNumber,
        trackingUrl,
        invoiceUrl,
        createdAt,
        updatedAt,
        deliveredAt,
        statusHistory,
      ];
}

class OrderStatusUpdate extends Equatable {
  final OrderStatus status;
  final String? message;
  final DateTime timestamp;

  const OrderStatusUpdate({
    required this.status,
    this.message,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [status, message, timestamp];
}

class Coupon extends Equatable {
  final String id;
  final String code;
  final String description;
  final String discountType;
  final double discountValue;
  final double? minOrderAmount;
  final double? maxDiscountAmount;
  final DateTime validFrom;
  final DateTime validUntil;
  final bool isActive;
  final int? usageLimit;
  final int usedCount;

  const Coupon({
    required this.id,
    required this.code,
    required this.description,
    required this.discountType,
    required this.discountValue,
    this.minOrderAmount,
    this.maxDiscountAmount,
    required this.validFrom,
    required this.validUntil,
    this.isActive = true,
    this.usageLimit,
    this.usedCount = 0,
  });

  bool get isValid {
    final now = DateTime.now();
    return isActive && now.isAfter(validFrom) && now.isBefore(validUntil) && (usageLimit == null || usedCount < usageLimit!);
  }

  double calculateDiscount(double orderAmount) {
    if (!isValid || (minOrderAmount != null && orderAmount < minOrderAmount!)) return 0;
    double discount;
    if (discountType == 'percentage') {
      discount = (orderAmount * discountValue) / 100;
    } else {
      discount = discountValue;
    }
    if (maxDiscountAmount != null && discount > maxDiscountAmount!) {
      discount = maxDiscountAmount!;
    }
    return discount;
  }

  @override
  List<Object?> get props => [
        id,
        code,
        description,
        discountType,
        discountValue,
        minOrderAmount,
        maxDiscountAmount,
        validFrom,
        validUntil,
        isActive,
        usageLimit,
        usedCount,
      ];
}
