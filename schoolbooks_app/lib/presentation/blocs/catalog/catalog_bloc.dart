import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/network/api_client.dart';
import '../../../data/models/book_model.dart';
import 'catalog_event.dart';
import 'catalog_state.dart';

class CatalogBloc extends Bloc<CatalogEvent, CatalogState> {
  final ApiClient _apiClient;

  CatalogBloc({required ApiClient apiClient})
      : _apiClient = apiClient,
        super(const CatalogState()) {
    on<CatalogLoadRequested>(_onLoadRequested);
    on<CatalogSearchRequested>(_onSearchRequested);
    on<CatalogLoadMoreRequested>(_onLoadMoreRequested);
    on<CatalogRefreshRequested>(_onRefreshRequested);
    on<CatalogBookDetailsRequested>(_onBookDetailsRequested);
    on<CatalogRecommendationsRequested>(_onRecommendationsRequested);
    on<CatalogCategoriesLoadRequested>(_onCategoriesLoadRequested);
    on<CatalogReviewsRequested>(_onReviewsRequested);
  }

  Future<void> _onLoadRequested(
    CatalogLoadRequested event,
    Emitter<CatalogState> emit,
  ) async {
    emit(state.copyWith(status: CatalogStatus.loading));
    try {
      final response = await _apiClient.get(
        ApiConstants.books,
        queryParameters: {'page': 1, 'limit': 20},
      );
      final books = (response.data['items'] as List)
          .map((e) => BookModel.fromJson(e))
          .toList();
      emit(state.copyWith(
        status: CatalogStatus.loaded,
        books: books,
        currentPage: 1,
        hasReachedMax: books.length < 20,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CatalogStatus.error,
        errorMessage: 'Failed to load books',
      ));
    }
  }

  Future<void> _onSearchRequested(
    CatalogSearchRequested event,
    Emitter<CatalogState> emit,
  ) async {
    emit(state.copyWith(
      status: CatalogStatus.loading,
      currentQuery: event.query,
      selectedBoard: event.board,
      selectedGrade: event.grade,
      selectedSubject: event.subject,
    ));
    try {
      final queryParams = <String, dynamic>{
        'q': event.query,
        'page': event.page,
        'limit': event.limit,
      };
      if (event.board != null) queryParams['board'] = event.board;
      if (event.grade != null) queryParams['grade'] = event.grade;
      if (event.subject != null) queryParams['subject'] = event.subject;
      if (event.publisher != null) queryParams['publisher'] = event.publisher;

      final response = await _apiClient.get(
        ApiConstants.booksSearch,
        queryParameters: queryParams,
      );
      final books = (response.data['items'] as List)
          .map((e) => BookModel.fromJson(e))
          .toList();
      emit(state.copyWith(
        status: CatalogStatus.loaded,
        books: books,
        currentPage: 1,
        hasReachedMax: books.length < event.limit,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CatalogStatus.error,
        errorMessage: 'Search failed',
      ));
    }
  }

  Future<void> _onLoadMoreRequested(
    CatalogLoadMoreRequested event,
    Emitter<CatalogState> emit,
  ) async {
    if (state.hasReachedMax) return;
    emit(state.copyWith(status: CatalogStatus.loadingMore));
    try {
      final queryParams = <String, dynamic>{
        'q': state.currentQuery ?? '',
        'page': state.currentPage + 1,
        'limit': 20,
      };
      if (state.selectedBoard != null) queryParams['board'] = state.selectedBoard;
      if (state.selectedGrade != null) queryParams['grade'] = state.selectedGrade;
      if (state.selectedSubject != null) queryParams['subject'] = state.selectedSubject;

      final response = await _apiClient.get(
        ApiConstants.booksSearch,
        queryParameters: queryParams,
      );
      final newBooks = (response.data['items'] as List)
          .map((e) => BookModel.fromJson(e))
          .toList();
      emit(state.copyWith(
        status: CatalogStatus.loaded,
        books: [...state.books, ...newBooks],
        currentPage: state.currentPage + 1,
        hasReachedMax: newBooks.length < 20,
      ));
    } catch (e) {
      emit(state.copyWith(status: CatalogStatus.loaded));
    }
  }

  Future<void> _onRefreshRequested(
    CatalogRefreshRequested event,
    Emitter<CatalogState> emit,
  ) async {
    if (state.currentQuery != null) {
      add(CatalogSearchRequested(
        query: state.currentQuery!,
        board: state.selectedBoard,
        grade: state.selectedGrade,
        subject: state.selectedSubject,
      ));
    } else {
      add(CatalogLoadRequested());
    }
  }

  Future<void> _onBookDetailsRequested(
    CatalogBookDetailsRequested event,
    Emitter<CatalogState> emit,
  ) async {
    emit(state.copyWith(status: CatalogStatus.loading));
    try {
      final response = await _apiClient.get('${ApiConstants.books}/${event.bookId}');
      final book = BookModel.fromJson(response.data);
      emit(state.copyWith(
        status: CatalogStatus.loaded,
        selectedBook: book,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CatalogStatus.error,
        errorMessage: 'Failed to load book details',
      ));
    }
  }

  Future<void> _onRecommendationsRequested(
    CatalogRecommendationsRequested event,
    Emitter<CatalogState> emit,
  ) async {
    try {
      final response = await _apiClient.get(
        ApiConstants.booksRecommendations,
        queryParameters: {'book_id': event.bookId},
      );
      final recommendations = (response.data['items'] as List)
          .map((e) => BookModel.fromJson(e))
          .toList();
      emit(state.copyWith(recommendations: recommendations));
    } catch (e) {
      // Silently fail for recommendations
    }
  }

  Future<void> _onCategoriesLoadRequested(
    CatalogCategoriesLoadRequested event,
    Emitter<CatalogState> emit,
  ) async {
    try {
      final boardsResponse = await _apiClient.get(ApiConstants.categoriesBoards);
      final gradesResponse = await _apiClient.get(ApiConstants.categoriesGrades);
      final subjectsResponse = await _apiClient.get(ApiConstants.categoriesSubjects);

      final boards = (boardsResponse.data as List)
          .map((e) => CategoryModel.fromJson(e))
          .toList();
      final grades = (gradesResponse.data as List)
          .map((e) => CategoryModel.fromJson(e))
          .toList();
      final subjects = (subjectsResponse.data as List)
          .map((e) => CategoryModel.fromJson(e))
          .toList();

      emit(state.copyWith(
        boards: boards,
        grades: grades,
        subjects: subjects,
      ));
    } catch (e) {
      // Silently fail for categories
    }
  }

  Future<void> _onReviewsRequested(
    CatalogReviewsRequested event,
    Emitter<CatalogState> emit,
  ) async {
    try {
      final response = await _apiClient.get(
        '${ApiConstants.books}/${event.bookId}/reviews',
      );
      final reviews = (response.data['items'] as List)
          .map((e) => ReviewModel.fromJson(e))
          .toList();
      emit(state.copyWith(reviews: reviews));
    } catch (e) {
      // Silently fail for reviews
    }
  }
}
