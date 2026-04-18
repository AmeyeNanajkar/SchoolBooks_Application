import '../../domain/entities/book.dart';

class BookModel extends Book {
  const BookModel({
    required super.id,
    required super.title,
    required super.author,
    super.publisher,
    required super.board,
    required super.grade,
    required super.subject,
    super.stateBoard,
    required super.isbn,
    required super.price,
    super.discountedPrice,
    super.imageUrl,
    super.images,
    required super.description,
    super.stockQuantity,
    super.rating,
    super.reviewCount,
    super.isAvailable,
    super.vendorId,
    super.vendorName,
    required super.createdAt,
    super.updatedAt,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['id'] as String,
      title: json['title'] as String,
      author: json['author'] as String,
      publisher: json['publisher'] as String?,
      board: json['board'] as String,
      grade: json['grade'] as String,
      subject: json['subject'] as String,
      stateBoard: json['state_board'] as String?,
      isbn: json['isbn'] as String,
      price: (json['price'] as num).toDouble(),
      discountedPrice: json['discounted_price'] != null
          ? (json['discounted_price'] as num).toDouble()
          : null,
      imageUrl: json['image_url'] as String?,
      images: (json['images'] as List<dynamic>?)?.cast<String>() ?? [],
      description: json['description'] as String? ?? '',
      stockQuantity: json['stock_quantity'] as int? ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['review_count'] as int? ?? 0,
      isAvailable: json['is_available'] as bool? ?? true,
      vendorId: json['vendor_id'] as String?,
      vendorName: json['vendor_name'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'publisher': publisher,
      'board': board,
      'grade': grade,
      'subject': subject,
      'state_board': stateBoard,
      'isbn': isbn,
      'price': price,
      'discounted_price': discountedPrice,
      'image_url': imageUrl,
      'images': images,
      'description': description,
      'stock_quantity': stockQuantity,
      'rating': rating,
      'review_count': reviewCount,
      'is_available': isAvailable,
      'vendor_id': vendorId,
      'vendor_name': vendorName,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

class CategoryModel extends Category {
  const CategoryModel({
    required super.id,
    required super.name,
    required super.type,
    super.parentId,
    super.icon,
    super.order,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      parentId: json['parent_id'] as String?,
      icon: json['icon'] as String?,
      order: json['order'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'parent_id': parentId,
      'icon': icon,
      'order': order,
    };
  }
}

class ReviewModel extends Review {
  const ReviewModel({
    required super.id,
    required super.bookId,
    required super.userId,
    required super.userName,
    super.userAvatar,
    required super.rating,
    super.comment,
    required super.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] as String,
      bookId: json['book_id'] as String,
      userId: json['user_id'] as String,
      userName: json['user_name'] as String,
      userAvatar: json['user_avatar'] as String?,
      rating: json['rating'] as int,
      comment: json['comment'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'book_id': bookId,
      'user_id': userId,
      'user_name': userName,
      'user_avatar': userAvatar,
      'rating': rating,
      'comment': comment,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
