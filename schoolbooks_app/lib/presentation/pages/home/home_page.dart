import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_state.dart';
import '../../blocs/catalog/catalog_bloc.dart';
import '../../blocs/catalog/catalog_event.dart';
import '../../blocs/catalog/catalog_state.dart';
import '../../widgets/book_card.dart';
import '../../widgets/category_chip.dart';
import '../../widgets/shimmer_loading.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<CatalogBloc>().add(CatalogLoadRequested());
    context.read<CatalogBloc>().add(CatalogCategoriesLoadRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              Icons.menu_book,
              color: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(width: 8),
            const Text('SchoolBooks'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.push('/catalog'),
          ),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state.user?.role.name == 'vendor') {
                return IconButton(
                  icon: const Icon(Icons.storefront),
                  onPressed: () => context.push('/vendor'),
                );
              }
              if (state.user?.role.name == 'admin') {
                return IconButton(
                  icon: const Icon(Icons.admin_panel_settings),
                  onPressed: () => context.push('/admin'),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<CatalogBloc>().add(CatalogRefreshRequested());
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeBanner(),
              _buildBoardCategories(),
              _buildFeaturedBooks(),
              _buildPopularBooks(),
              _buildNewArrivals(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeBanner() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome to SchoolBooks!',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Find the best books for CBSE, ICSE & State Boards',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withOpacity(0.9),
                ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () => context.push('/catalog'),
            child: const Text('Browse Catalog'),
          ),
        ],
      ),
    );
  }

  Widget _buildBoardCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Browse by Board',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: AppConstants.boards.length,
            itemBuilder: (context, index) {
              final board = AppConstants.boards[index];
              return CategoryChip(
                title: board,
                icon: _getBoardIcon(board),
                onTap: () => context.push('/catalog?board=$board'),
              );
            },
          ),
        ),
      ],
    );
  }

  IconData _getBoardIcon(String board) {
    switch (board) {
      case 'CBSE':
        return Icons.school;
      case 'ICSE':
        return Icons.account_balance;
      default:
        return Icons.map;
    }
  }

  Widget _buildFeaturedBooks() {
    return BlocBuilder<CatalogBloc, CatalogState>(
      builder: (context, state) {
        if (state.status == CatalogStatus.loading) {
          return const ShimmerBookList();
        }
        if (state.books.isEmpty) {
          return const SizedBox.shrink();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Featured Books',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  TextButton(
                    onPressed: () => context.push('/catalog'),
                    child: const Text('See All'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 280,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: state.books.take(10).length,
                itemBuilder: (context, index) {
                  final book = state.books[index];
                  return BookCard(
                    book: book,
                    onTap: () => context.push('/book/${book.id}'),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPopularBooks() {
    return BlocBuilder<CatalogBloc, CatalogState>(
      builder: (context, state) {
        if (state.books.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Popular This Week',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 280,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: state.books.take(5).length,
                itemBuilder: (context, index) {
                  final book = state.books[index];
                  return BookCard(
                    book: book,
                    onTap: () => context.push('/book/${book.id}'),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildNewArrivals() {
    return BlocBuilder<CatalogBloc, CatalogState>(
      builder: (context, state) {
        if (state.books.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'New Arrivals',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 280,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: state.books.take(8).length,
                itemBuilder: (context, index) {
                  final book = state.books[index];
                  return BookCard(
                    book: book,
                    onTap: () => context.push('/book/${book.id}'),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
