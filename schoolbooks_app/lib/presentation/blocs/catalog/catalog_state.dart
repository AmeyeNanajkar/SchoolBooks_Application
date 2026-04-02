import 'package:equatable/equatable.dart';
import '../../../domain/entities/book.dart';

enum CatalogStatus {
  initial,
  loading,
  loaded,
  loadingMore,
  error,
}

class CatalogState extends Equatable {
  final CatalogStatus status;
  final List<Book> books;
  final List<Category> boards;
  final List<Category> grades;
  final List<Category> subjects;
  final Book? selectedBook;
  final List<Book> recommendations;
  final List<Review> reviews;
  final String? errorMessage;
  final int currentPage;
  final bool hasReachedMax;
  final String? currentQuery;
  final String? selectedBoard;
  final String? selectedGrade;
  final String? selectedSubject;

  const CatalogState({
    this.status = CatalogStatus.initial,
    this.books = const [],
    this.boards = const [],
    this.grades = const [],
    this.subjects = const [],
    this.selectedBook,
    this.recommendations = const [],
    this.reviews = const [],
    this.errorMessage,
    this.currentPage = 1,
    this.hasReachedMax = false,
    this.currentQuery,
    this.selectedBoard,
    this.selectedGrade,
    this.selectedSubject,
  });

  CatalogState copyWith({
    CatalogStatus? status,
    List<Book>? books,
    List<Category>? boards,
    List<Category>? grades,
    List<Category>? subjects,
    Book? selectedBook,
    List<Book>? recommendations,
    List<Review>? reviews,
    String? errorMessage,
    int? currentPage,
    bool? hasReachedMax,
    String? currentQuery,
    String? selectedBoard,
    String? selectedGrade,
    String? selectedSubject,
  }) {
    return CatalogState(
      status: status ?? this.status,
      books: books ?? this.books,
      boards: boards ?? this.boards,
      grades: grades ?? this.grades,
      subjects: subjects ?? this.subjects,
      selectedBook: selectedBook ?? this.selectedBook,
      recommendations: recommendations ?? this.recommendations,
      reviews: reviews ?? this.reviews,
      errorMessage: errorMessage,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentQuery: currentQuery ?? this.currentQuery,
      selectedBoard: selectedBoard ?? this.selectedBoard,
      selectedGrade: selectedGrade ?? this.selectedGrade,
      selectedSubject: selectedSubject ?? this.selectedSubject,
    );
  }

  @override
  List<Object?> get props => [
        status,
        books,
        boards,
        grades,
        subjects,
        selectedBook,
        recommendations,
        reviews,
        errorMessage,
        currentPage,
        hasReachedMax,
        currentQuery,
        selectedBoard,
        selectedGrade,
        selectedSubject,
      ];
}
