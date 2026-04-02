import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_state.dart';
import '../pages/auth/login_page.dart';
import '../pages/auth/register_page.dart';
import '../pages/auth/otp_page.dart';
import '../pages/home/home_page.dart';
import '../pages/catalog/catalog_page.dart';
import '../pages/catalog/book_detail_page.dart';
import '../pages/cart/cart_page.dart';
import '../pages/cart/checkout_page.dart';
import '../pages/orders/orders_page.dart';
import '../pages/orders/order_detail_page.dart';
import '../pages/orders/order_tracking_page.dart';
import '../pages/profile/profile_page.dart';
import '../pages/profile/addresses_page.dart';
import '../pages/profile/add_address_page.dart';
import '../pages/profile/wishlist_page.dart';
import '../pages/vendor/vendor_dashboard_page.dart';
import '../pages/vendor/vendor_inventory_page.dart';
import '../pages/admin/admin_dashboard_page.dart';
import '../pages/admin/admin_vendors_page.dart';
import '../pages/admin/admin_books_page.dart';
import '../pages/main_shell.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static GoRouter router(AuthBloc authBloc) {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: '/',
      debugLogDiagnostics: true,
      refreshListenable: GoRouterRefreshStream(authBloc.stream),
      redirect: (context, state) {
        final authState = authBloc.state;
        final isAuthRoute = state.matchedLocation == '/login' ||
            state.matchedLocation == '/register' ||
            state.matchedLocation == '/otp';

        if (authState.status == AuthStatus.unauthenticated && !isAuthRoute) {
          return '/login';
        }
        if (authState.status == AuthStatus.authenticated && isAuthRoute) {
          return '/';
        }
        return null;
      },
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterPage(),
        ),
        GoRoute(
          path: '/otp',
          builder: (context, state) {
            final email = state.extra as String?;
            return OtpPage(email: email);
          },
        ),
        ShellRoute(
          navigatorKey: _shellNavigatorKey,
          builder: (context, state, child) => MainShell(child: child),
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const HomePage(),
            ),
            GoRoute(
              path: '/catalog',
              builder: (context, state) => const CatalogPage(),
            ),
            GoRoute(
              path: '/book/:id',
              builder: (context, state) {
                final bookId = state.pathParameters['id']!;
                return BookDetailPage(bookId: bookId);
              },
            ),
            GoRoute(
              path: '/cart',
              builder: (context, state) => const CartPage(),
            ),
            GoRoute(
              path: '/orders',
              builder: (context, state) => const OrdersPage(),
            ),
            GoRoute(
              path: '/order/:id',
              builder: (context, state) {
                final orderId = state.pathParameters['id']!;
                return OrderDetailPage(orderId: orderId);
              },
            ),
            GoRoute(
              path: '/order/:id/track',
              builder: (context, state) {
                final orderId = state.pathParameters['id']!;
                return OrderTrackingPage(orderId: orderId);
              },
            ),
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfilePage(),
            ),
            GoRoute(
              path: '/addresses',
              builder: (context, state) => const AddressesPage(),
            ),
            GoRoute(
              path: '/addresses/add',
              builder: (context, state) => const AddAddressPage(),
            ),
            GoRoute(
              path: '/wishlist',
              builder: (context, state) => const WishlistPage(),
            ),
            GoRoute(
              path: '/checkout',
              builder: (context, state) => const CheckoutPage(),
            ),
          ],
        ),
        GoRoute(
          path: '/vendor',
          builder: (context, state) => const VendorDashboardPage(),
        ),
        GoRoute(
          path: '/vendor/inventory',
          builder: (context, state) => const VendorInventoryPage(),
        ),
        GoRoute(
          path: '/admin',
          builder: (context, state) => const AdminDashboardPage(),
        ),
        GoRoute(
          path: '/admin/vendors',
          builder: (context, state) => const AdminVendorsPage(),
        ),
        GoRoute(
          path: '/admin/books',
          builder: (context, state) => const AdminBooksPage(),
        ),
      ],
    );
  }
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final dynamic _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
