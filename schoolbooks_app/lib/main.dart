import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'core/network/api_client.dart';
import 'core/theme/app_theme.dart';
import 'presentation/blocs/auth/auth_bloc.dart';
import 'presentation/blocs/auth/auth_event.dart';
import 'presentation/blocs/catalog/catalog_bloc.dart';
import 'presentation/blocs/cart/cart_bloc.dart';
import 'presentation/blocs/orders/orders_bloc.dart';
import 'presentation/router/app_router.dart';
import 'core/constants/app_constants.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SchoolBooksApp());
}

class SchoolBooksApp extends StatefulWidget {
  const SchoolBooksApp({super.key});

  @override
  State<SchoolBooksApp> createState() => _SchoolBooksAppState();
}

class _SchoolBooksAppState extends State<SchoolBooksApp> {
  late final FlutterSecureStorage _secureStorage;
  late final Dio _dio;
  late final ApiClient _apiClient;
  late final AuthBloc _authBloc;

  @override
  void initState() {
    super.initState();
    _secureStorage = const FlutterSecureStorage();
    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: ApiConstants.connectionTimeout,
      receiveTimeout: ApiConstants.receiveTimeout,
    ));
    _apiClient = ApiClient(dio: _dio, secureStorage: _secureStorage);
    _authBloc = AuthBloc(apiClient: _apiClient, secureStorage: _secureStorage);
    _authBloc.add(AuthCheckRequested());
  }

  @override
  void dispose() {
    _authBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ApiClient>.value(value: _apiClient),
        RepositoryProvider<FlutterSecureStorage>.value(value: _secureStorage),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>.value(value: _authBloc),
          BlocProvider<CatalogBloc>(
            create: (context) => CatalogBloc(apiClient: _apiClient),
          ),
          BlocProvider<CartBloc>(
            create: (context) => CartBloc(apiClient: _apiClient),
          ),
          BlocProvider<OrdersBloc>(
            create: (context) => OrdersBloc(apiClient: _apiClient),
          ),
        ],
        child: MaterialApp.router(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.light,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppConstants.supportedLocales
              .map((locale) => Locale(locale))
              .toList(),
          routerConfig: AppRouter.router(_authBloc),
        ),
      ),
    );
  }
}
