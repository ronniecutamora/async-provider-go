import 'package:async_provider_go/src/posts/data/posts.service.dart';
import 'package:async_provider_go/src/posts/presentation/posts.provider.dart';
import 'package:async_provider_go/src/posts/presentation/posts.screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => PostProvider(PostService()),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PostScreen()
    );
  }
}

