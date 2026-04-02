import '../../domain/entities/order.dart';
import 'user_model.dart';

class OrderItemModel extends OrderItem {
  const OrderItemModel({
    required super.id,
    required super.bookId,
    required super.bookTitle,
    super.bookImage,
    required super.quantity,
    required super.price,
    super.discountedPrice,
    super.vendorId,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] as String,
      bookId: json['book_id'] as String,
      bookTitle: json['book_title'] as String,
      bookImage: json['book_image'] as String?,
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(),
      discountedPrice: json['discounted_price'] != null
          ? (json['discounted_price'] as num).toDouble()
          : null,
      vendorId: json['vendor_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'book_id': bookId,
      'book_title': bookTitle,
      'book_image': bookImage,
      'quantity': quantity,
      'price': price,
      'discounted_price': discountedPrice,
      'vendor_id': vendorId,
    };
  }
}

class OrderModel extends Order {
  const OrderModel({
    required super.id,
    required super.orderNumber,
    required super.userId,
    super.user,
    required super.items,
    required super.shippingAddress,
    super.status,
    super.paymentStatus,
    super.paymentMethod,
    required super.subtotal,
    super.discountAmount,
    super.shippingCost,
    super.taxAmount,
    required super.totalAmount,
    super.couponCode,
    super.trackingNumber,
    super.trackingUrl,
    super.invoiceUrl,
    required super.createdAt,
    super.updatedAt,
    super.deliveredAt,
    super.statusHistory,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      orderNumber: json['order_number'] as String,
      userId: json['user_id'] as String,
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      items: (json['items'] as List<dynamic>)
          .map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      shippingAddress: AddressModel.fromJson(json['shipping_address']),
      status: OrderStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => OrderStatus.pending,
      ),
      paymentStatus: PaymentStatus.values.firstWhere(
        (e) => e.name == json['payment_status'],
        orElse: () => PaymentStatus.pending,
      ),
      paymentMethod: PaymentMethod.values.firstWhere(
        (e) => e.name == json['payment_method'],
        orElse: () => PaymentMethod.upi,
      ),
      subtotal: (json['subtotal'] as num).toDouble(),
      discountAmount: (json['discount_amount'] as num?)?.toDouble() ?? 0,
      shippingCost: (json['shipping_cost'] as num?)?.toDouble() ?? 0,
      taxAmount: (json['tax_amount'] as num?)?.toDouble() ?? 0,
      totalAmount: (json['total_amount'] as num).toDouble(),
      couponCode: json['coupon_code'] as String?,
      trackingNumber: json['tracking_number'] as String?,
      trackingUrl: json['tracking_url'] as String?,
      invoiceUrl: json['invoice_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      deliveredAt: json['delivered_at'] != null
          ? DateTime.parse(json['delivered_at'] as String)
          : null,
      statusHistory: (json['status_history'] as List<dynamic>?)
              ?.map((e) => OrderStatusUpdateModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_number': orderNumber,
      'user_id': userId,
      'items': items.map((e) => (e as OrderItemModel).toJson()).toList(),
      'shipping_address': (shippingAddress as AddressModel).toJson(),
      'status': status.name,
      'payment_status': paymentStatus.name,
      'payment_method': paymentMethod.name,
      'subtotal': subtotal,
      'discount_amount': discountAmount,
      'shipping_cost': shippingCost,
      'tax_amount': taxAmount,
      'total_amount': totalAmount,
      'coupon_code': couponCode,
      'tracking_number': trackingNumber,
      'tracking_url': trackingUrl,
      'invoice_url': invoiceUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'delivered_at': deliveredAt?.toIso8601String(),
    };
  }
}

class OrderStatusUpdateModel extends OrderStatusUpdate {
  const OrderStatusUpdateModel({
    required super.status,
    super.message,
    required super.timestamp,
  });

  factory OrderStatusUpdateModel.fromJson(Map<String, dynamic> json) {
    return OrderStatusUpdateModel(
      status: OrderStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => OrderStatus.pending,
      ),
      message: json['message'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
}

class CouponModel extends Coupon {
  const CouponModel({
    required super.id,
    required super.code,
    required super.description,
    required super.discountType,
    required super.discountValue,
    super.minOrderAmount,
    super.maxDiscountAmount,
    required super.validFrom,
    required super.validUntil,
    super.isActive,
    super.usageLimit,
    super.usedCount,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      id: json['id'] as String,
      code: json['code'] as String,
      description: json['description'] as String? ?? '',
      discountType: json['discount_type'] as String,
      discountValue: (json['discount_value'] as num).toDouble(),
      minOrderAmount: json['min_order_amount'] != null
          ? (json['min_order_amount'] as num).toDouble()
          : null,
      maxDiscountAmount: json['max_discount_amount'] != null
          ? (json['max_discount_amount'] as num).toDouble()
          : null,
      validFrom: DateTime.parse(json['valid_from'] as String),
      validUntil: DateTime.parse(json['valid_until'] as String),
      isActive: json['is_active'] as bool? ?? true,
      usageLimit: json['usage_limit'] as int?,
      usedCount: json['used_count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'description': description,
      'discount_type': discountType,
      'discount_value': discountValue,
      'min_order_amount': minOrderAmount,
      'max_discount_amount': maxDiscountAmount,
      'valid_from': validFrom.toIso8601String(),
      'valid_until': validUntil.toIso8601String(),
      'is_active': isActive,
      'usage_limit': usageLimit,
      'used_count': usedCount,
    };
  }
}
