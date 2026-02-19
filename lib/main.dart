import 'package:async_provider_go/core/constants/app_constants.dart';
import 'package:async_provider_go/core/router/app_router.dart';
import 'package:async_provider_go/core/theme/app_theme.dart';
import 'package:async_provider_go/core/theme/theme.provider.dart';
import 'package:async_provider_go/features/auth/data/data_sources/auth.service.dart';
import 'package:async_provider_go/features/auth/data/repositories/auth.repository_impl.dart';
import 'package:async_provider_go/features/auth/presentation/providers/auth.provider.dart';
import 'package:async_provider_go/features/posts/data/data_sources/post.service.dart';
import 'package:async_provider_go/features/posts/data/repositories/post.repository_impl.dart';
import 'package:async_provider_go/features/posts/domain/repositories/post.repository.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'features/posts/presentation/providers/post.provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: AppConstants.supabaseUrl,
    anonKey: AppConstants.supabaseAnonKey,
  );
  runApp(const MyApp());
}

/// [MyApp] is a [StatefulWidget] so [AuthProvider] and [GoRouter] are
/// created once and held in state. This prevents the router from being
/// recreated on every build, which would break navigation state.
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AuthProvider _authProvider;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    // Build the auth DI chain manually here so AuthProvider is available
    // before the widget tree is built — required for the router redirect.
    final client = Supabase.instance.client;
    final authService = AuthService(client);
    final authRepository = AuthRepositoryImpl(authService);
    _authProvider = AuthProvider(authRepository);
    _router = buildAppRouter(_authProvider);
  }

  @override
  void dispose() {
    _authProvider.dispose();
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Auth — created in initState, exposed to entire widget tree
        ChangeNotifierProvider.value(value: _authProvider),

        // Theme
        ChangeNotifierProvider(create: (_) => ThemeProvider()),

        // Supabase client
        Provider<SupabaseClient>(
          create: (_) => Supabase.instance.client,
        ),

        // Posts DI chain
        Provider(create: (_) => PostService()),
        ProxyProvider<PostService, PostRepository>(
          update: (_, service, __) => PostRepositoryImpl(service),
        ),
        ChangeNotifierProxyProvider<PostRepository, PostProvider>(
          create: (context) => PostProvider(context.read<PostRepository>()),
          update: (_, repo, previous) => previous ?? PostProvider(repo),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (_, themeProvider, __) => MaterialApp.router(
          title: 'Production Pattern',
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeProvider.themeMode,
          routerConfig: _router,
        ),
      ),
    );
  }
}