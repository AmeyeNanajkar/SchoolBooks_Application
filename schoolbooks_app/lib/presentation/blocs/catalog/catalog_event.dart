import 'package:equatable/equatable.dart';

abstract class CatalogEvent extends Equatable {
  const CatalogEvent();

  @override
  List<Object?> get props => [];
}

class CatalogLoadRequested extends CatalogEvent {}

class CatalogSearchRequested extends CatalogEvent {
  final String query;
  final String? board;
  final String? grade;
  final String? subject;
  final String? publisher;
  final int page;
  final int limit;

  const CatalogSearchRequested({
    required this.query,
    this.board,
    this.grade,
    this.subject,
    this.publisher,
    this.page = 1,
    this.limit = 20,
  });

  @override
  List<Object?> get props => [query, board, grade, subject, publisher, page, limit];
}

class CatalogLoadMoreRequested extends CatalogEvent {}

class CatalogRefreshRequested extends CatalogEvent {}

class CatalogBookDetailsRequested extends CatalogEvent {
  final String bookId;

  const CatalogBookDetailsRequested({required this.bookId});

  @override
  List<Object?> get props => [bookId];
}

class CatalogRecommendationsRequested extends CatalogEvent {
  final String bookId;

  const CatalogRecommendationsRequested({required this.bookId});

  @override
  List<Object?> get props => [bookId];
}

class CatalogCategoriesLoadRequested extends CatalogEvent {}

class CatalogReviewsRequested extends CatalogEvent {
  final String bookId;

  const CatalogReviewsRequested({required this.bookId});

  @override
  List<Object?> get props => [bookId];
}
