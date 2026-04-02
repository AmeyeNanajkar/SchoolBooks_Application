import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../blocs/catalog/catalog_bloc.dart';
import '../../blocs/catalog/catalog_event.dart';
import '../../blocs/catalog/catalog_state.dart';
import '../../widgets/book_card.dart';
import '../../widgets/filter_bottom_sheet.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  String? _selectedBoard;
  String? _selectedGrade;
  String? _selectedSubject;

  @override
  void initState() {
    super.initState();
    context.read<CatalogBloc>().add(CatalogCategoriesLoadRequested());
    context.read<CatalogBloc>().add(CatalogLoadRequested());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<CatalogBloc>().add(CatalogLoadMoreRequested());
    }
  }

  void _search() {
    context.read<CatalogBloc>().add(CatalogSearchRequested(
          query: _searchController.text,
          board: _selectedBoard,
          grade: _selectedGrade,
          subject: _selectedSubject,
        ));
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => FilterBottomSheet(
        selectedBoard: _selectedBoard,
        selectedGrade: _selectedGrade,
        selectedSubject: _selectedSubject,
        boards: AppConstants.boards,
        grades: AppConstants.grades,
        subjects: AppConstants.subjects,
        onApply: (board, grade, subject) {
          setState(() {
            _selectedBoard = board;
            _selectedGrade = grade;
            _selectedSubject = subject;
          });
          _search();
          Navigator.pop(context);
        },
        onClear: () {
          setState(() {
            _selectedBoard = null;
            _selectedGrade = null;
            _selectedSubject = null;
          });
          _search();
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catalog'),
        actions: [
          IconButton(
            icon: Badge(
              isLabelVisible: _selectedBoard != null || 
                  _selectedGrade != null || 
                  _selectedSubject != null,
              child: const Icon(Icons.filter_list),
            ),
            onPressed: _showFilterSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          if (_selectedBoard != null || _selectedGrade != null || _selectedSubject != null)
            _buildActiveFilters(),
          Expanded(child: _buildBookGrid()),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search books...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _search();
                        },
                      )
                    : null,
              ),
              onSubmitted: (_) => _search(),
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filled(
            onPressed: _search,
            icon: const Icon(Icons.search),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveFilters() {
    return Container(
      height: 40,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          if (_selectedBoard != null)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Chip(
                label: Text(_selectedBoard!),
                deleteIcon: const Icon(Icons.close, size: 18),
                onDeleted: () {
                  setState(() => _selectedBoard = null);
                  _search();
                },
              ),
            ),
          if (_selectedGrade != null)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Chip(
                label: Text(_selectedGrade!),
                deleteIcon: const Icon(Icons.close, size: 18),
                onDeleted: () {
                  setState(() => _selectedGrade = null);
                  _search();
                },
              ),
            ),
          if (_selectedSubject != null)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Chip(
                label: Text(_selectedSubject!),
                deleteIcon: const Icon(Icons.close, size: 18),
                onDeleted: () {
                  setState(() => _selectedSubject = null);
                  _search();
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBookGrid() {
    return BlocBuilder<CatalogBloc, CatalogState>(
      builder: (context, state) {
        if (state.status == CatalogStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.status == CatalogStatus.error) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.grey),
                const SizedBox(height: 16),
                Text(state.errorMessage ?? 'An error occurred'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<CatalogBloc>().add(CatalogLoadRequested());
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        if (state.books.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.menu_book_outlined, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                const Text('No books found'),
                const SizedBox(height: 8),
                Text(
                  'Try adjusting your search or filters',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: () async {
            context.read<CatalogBloc>().add(CatalogRefreshRequested());
          },
          child: GridView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.65,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: state.books.length + (state.hasReachedMax ? 0 : 1),
            itemBuilder: (context, index) {
              if (index >= state.books.length) {
                return const Center(child: CircularProgressIndicator());
              }
              final book = state.books[index];
              return BookCard(
                book: book,
                onTap: () => context.push('/book/${book.id}'),
                isGridView: true,
              );
            },
          ),
        );
      },
    );
  }
}
