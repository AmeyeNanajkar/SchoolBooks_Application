import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../blocs/catalog/catalog_bloc.dart';
import '../../blocs/catalog/catalog_event.dart';
import '../../blocs/catalog/catalog_state.dart';
import '../../blocs/cart/cart_bloc.dart';
import '../../blocs/cart/cart_event.dart';
import '../../blocs/cart/cart_state.dart';
import '../../widgets/book_card.dart';

class BookDetailPage extends StatefulWidget {
  final String bookId;

  const BookDetailPage({super.key, required this.bookId});

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    context.read<CatalogBloc>().add(CatalogBookDetailsRequested(bookId: widget.bookId));
    context.read<CatalogBloc>().add(CatalogRecommendationsRequested(bookId: widget.bookId));
    context.read<CatalogBloc>().add(CatalogReviewsRequested(bookId: widget.bookId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<CatalogBloc, CatalogState>(
        builder: (context, state) {
          if (state.status == CatalogStatus.loading && state.selectedBook == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final book = state.selectedBook;
          if (book == null) {
            return const Center(child: Text('Book not found'));
          }
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      _buildMainImage(book.imageUrl ?? book.images.firstOrNull),
                      if (book.discountPercentage > 0)
                        Positioned(
                          top: 16,
                          left: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${book.discountPercentage}% OFF',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.favorite_border),
                    onPressed: () {
                      context.read<CartBloc>().add(CartWishlistAddRequested(bookId: book.id));
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.share),
                    onPressed: () {},
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book.title,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'by ${book.author}',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          RatingBarIndicator(
                            rating: book.rating,
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            itemCount: 5,
                            itemSize: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${book.rating.toStringAsFixed(1)} (${book.reviewCount} reviews)',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildPriceSection(book),
                      const SizedBox(height: 16),
                      _buildInfoChips(book),
                      const SizedBox(height: 24),
                      _buildQuantitySelector(),
                      const SizedBox(height: 24),
                      _buildDescription(book),
                      const SizedBox(height: 24),
                      _buildReviewsSection(state),
                      const SizedBox(height: 24),
                      _buildRecommendationsSection(state),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomSheet: BlocBuilder<CatalogBloc, CatalogState>(
        builder: (context, state) {
          if (state.selectedBook == null) return const SizedBox.shrink();
          return _buildBottomBar(state.selectedBook!);
        },
      ),
    );
  }

  Widget _buildMainImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return Container(
        color: Colors.grey[200],
        child: const Icon(Icons.menu_book, size: 100, color: Colors.grey),
      );
    }
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.contain,
      placeholder: (context, url) => Container(
        color: Colors.grey[200],
        child: const Center(child: CircularProgressIndicator()),
      ),
      errorWidget: (context, url, error) => Container(
        color: Colors.grey[200],
        child: const Icon(Icons.error, color: Colors.grey),
      ),
    );
  }

  Widget _buildPriceSection(book) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '₹${book.effectivePrice.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        if (book.discountedPrice != null) ...[
          const SizedBox(width: 8),
          Text(
            '₹${book.price.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  decoration: TextDecoration.lineThrough,
                  color: Colors.grey,
                ),
          ),
        ],
      ],
    );
  }

  Widget _buildInfoChips(book) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        Chip(
          avatar: const Icon(Icons.school, size: 18),
          label: Text(book.board),
        ),
        Chip(
          avatar: const Icon(Icons.grade, size: 18),
          label: Text(book.grade),
        ),
        Chip(
          avatar: const Icon(Icons.book, size: 18),
          label: Text(book.subject),
        ),
        if (book.publisher != null)
          Chip(
            avatar: const Icon(Icons.business, size: 18),
            label: Text(book.publisher!),
          ),
      ],
    );
  }

  Widget _buildQuantitySelector() {
    return Row(
      children: [
        Text(
          'Quantity:',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(width: 16),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: _quantity > 1
                    ? () => setState(() => _quantity--)
                    : null,
              ),
              Text(
                _quantity.toString(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => setState(() => _quantity++),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescription(book) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          book.description.isNotEmpty ? book.description : 'No description available.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 8),
        Text(
          'ISBN: ${book.isbn}',
          style: TextStyle(color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildReviewsSection(CatalogState state) {
    if (state.reviews.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reviews',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        ...state.reviews.take(5).map((review) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          child: Text(review.userName[0].toUpperCase()),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                review.userName,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              RatingBarIndicator(
                                rating: review.rating.toDouble(),
                                itemBuilder: (context, _) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                itemCount: 5,
                                itemSize: 16,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (review.comment != null) ...[
                      const SizedBox(height: 8),
                      Text(review.comment!),
                    ],
                  ],
                ),
              ),
            )),
      ],
    );
  }

  Widget _buildRecommendationsSection(CatalogState state) {
    if (state.recommendations.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'You May Also Like',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 260,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: state.recommendations.length,
            itemBuilder: (context, index) {
              final book = state.recommendations[index];
              return BookCard(
                book: book,
                onTap: () => context.push('/book/${book.id}'),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(book) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  Text(
                    '₹${(book.effectivePrice * _quantity).toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: BlocConsumer<CartBloc, CartState>(
                listener: (context, state) {
                  if (state.successMessage != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.successMessage!),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  return ElevatedButton.icon(
                    onPressed: () {
                      context.read<CartBloc>().add(CartAddItemRequested(
                            bookId: book.id,
                            quantity: _quantity,
                          ));
                    },
                    icon: const Icon(Icons.shopping_cart),
                    label: const Text('Add to Cart'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
