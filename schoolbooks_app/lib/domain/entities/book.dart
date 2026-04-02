import 'package:equatable/equatable.dart';

class Book extends Equatable {
  final String id;
  final String title;
  final String author;
  final String? publisher;
  final String board;
  final String grade;
  final String subject;
  final String? stateBoard;
  final String isbn;
  final double price;
  final double? discountedPrice;
  final String? imageUrl;
  final List<String> images;
  final String description;
  final int stockQuantity;
  final double rating;
  final int reviewCount;
  final bool isAvailable;
  final String? vendorId;
  final String? vendorName;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    this.publisher,
    required this.board,
    required this.grade,
    required this.subject,
    this.stateBoard,
    required this.isbn,
    required this.price,
    this.discountedPrice,
    this.imageUrl,
    this.images = const [],
    required this.description,
    this.stockQuantity = 0,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.isAvailable = true,
    this.vendorId,
    this.vendorName,
    required this.createdAt,
    this.updatedAt,
  });

  double get effectivePrice => discountedPrice ?? price;
  
  int get discountPercentage {
    if (discountedPrice == null || discountedPrice! >= price) return 0;
    return (((price - discountedPrice!) / price) * 100).round();
  }

  @override
  List<Object?> get props => [
        id,
        title,
        author,
        publisher,
        board,
        grade,
        subject,
        stateBoard,
        isbn,
        price,
        discountedPrice,
        imageUrl,
        images,
        description,
        stockQuantity,
        rating,
        reviewCount,
        isAvailable,
        vendorId,
        vendorName,
        createdAt,
        updatedAt,
      ];
}

class Category extends Equatable {
  final String id;
  final String name;
  final String type;
  final String? parentId;
  final String? icon;
  final int order;

  const Category({
    required this.id,
    required this.name,
    required this.type,
    this.parentId,
    this.icon,
    this.order = 0,
  });

  @override
  List<Object?> get props => [id, name, type, parentId, icon, order];
}

class Review extends Equatable {
  final String id;
  final String bookId;
  final String userId;
  final String userName;
  final String? userAvatar;
  final int rating;
  final String? comment;
  final DateTime createdAt;

  const Review({
    required this.id,
    required this.bookId,
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.rating,
    this.comment,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, bookId, userId, userName, userAvatar, rating, comment, createdAt];
}
