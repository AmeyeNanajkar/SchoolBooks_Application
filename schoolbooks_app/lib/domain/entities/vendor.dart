import 'package:equatable/equatable.dart';

enum VendorStatus {
  pending,
  approved,
  rejected,
  suspended,
}

class Vendor extends Equatable {
  final String id;
  final String userId;
  final String businessName;
  final String? businessLogo;
  final String contactPerson;
  final String email;
  final String phone;
  final String? gstin;
  final String? pan;
  final String? bankName;
  final String? accountNumber;
  final String? ifscCode;
  final String address;
  final VendorStatus status;
  final double rating;
  final int totalOrders;
  final double totalSales;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Vendor({
    required this.id,
    required this.userId,
    required this.businessName,
    this.businessLogo,
    required this.contactPerson,
    required this.email,
    required this.phone,
    this.gstin,
    this.pan,
    this.bankName,
    this.accountNumber,
    this.ifscCode,
    required this.address,
    this.status = VendorStatus.pending,
    this.rating = 0.0,
    this.totalOrders = 0,
    this.totalSales = 0.0,
    required this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        businessName,
        businessLogo,
        contactPerson,
        email,
        phone,
        gstin,
        pan,
        bankName,
        accountNumber,
        ifscCode,
        address,
        status,
        rating,
        totalOrders,
        totalSales,
        createdAt,
        updatedAt,
      ];
}

class VendorInventoryItem extends Equatable {
  final String id;
  final String vendorId;
  final String bookId;
  final String bookTitle;
  final String? bookImage;
  final int stockQuantity;
  final double price;
  final double? discountedPrice;
  final bool isAvailable;
  final DateTime updatedAt;

  const VendorInventoryItem({
    required this.id,
    required this.vendorId,
    required this.bookId,
    required this.bookTitle,
    this.bookImage,
    required this.stockQuantity,
    required this.price,
    this.discountedPrice,
    this.isAvailable = true,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        vendorId,
        bookId,
        bookTitle,
        bookImage,
        stockQuantity,
        price,
        discountedPrice,
        isAvailable,
        updatedAt,
      ];
}

class VendorOrder extends Equatable {
  final String id;
  final String orderId;
  final String orderNumber;
  final String vendorId;
  final String buyerName;
  final String shippingAddress;
  final List<OrderItem> items;
  final double totalAmount;
  final OrderStatus status;
  final DateTime createdAt;

  const VendorOrder({
    required this.id,
    required this.orderId,
    required this.orderNumber,
    required this.vendorId,
    required this.buyerName,
    required this.shippingAddress,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, orderId, orderNumber, vendorId, buyerName, shippingAddress, items, totalAmount, status, createdAt];
}

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

class OrderItem {
  final String bookId;
  final String bookTitle;
  final int quantity;
  final double price;
  final double? discountedPrice;

  const OrderItem({
    required this.bookId,
    required this.bookTitle,
    required this.quantity,
    required this.price,
    this.discountedPrice,
  });
}
