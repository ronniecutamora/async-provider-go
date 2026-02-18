import 'package:async_provider_go/core/router/app_router.dart';
import 'package:async_provider_go/core/theme/app_theme.dart';
import 'package:async_provider_go/core/theme/theme.provider.dart';
import 'package:async_provider_go/features/posts/data/data_sources/post.service.dart';
import 'package:async_provider_go/features/posts/data/repositories/post.repository_impl.dart';
import 'package:async_provider_go/features/posts/domain/repositories/post.repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/posts/presentation/providers/post.provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Theme
        ChangeNotifierProvider(create: (_) => ThemeProvider()),

        // 1. Data Source
        Provider(create: (_) => PostService()),

        // 2. Repository (Inject Data Source into Implementation)
        ProxyProvider<PostService, PostRepository>(
          update: (_, service, __) => PostRepositoryImpl(service),
        ),

        // 3. Provider (Inject Repository Interface)
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
          routerConfig: appRouter,
        ),
      ),
    );
  }
}