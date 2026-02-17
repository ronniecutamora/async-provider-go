// state management

import 'package:async_provider_go/src/posts/data/posts.model.dart';
import 'package:async_provider_go/src/posts/data/posts.service.dart';
import 'package:flutter/material.dart';

sealed class PostState {}
class PostInitial extends PostState {}
class PostLoading extends PostState {}
class PostError extends PostState { final String message; PostError(this.message); }
class PostLoaded extends PostState { 
  final List<Post> posts; 
  PostLoaded(this.posts); 
}

class PostProvider extends ChangeNotifier {
  final PostService _service;
  PostProvider(this._service);

  PostState _state = PostInitial();
  PostState get state => _state;

  Future<void> loadPosts() async {
    _state = PostLoading();
    notifyListeners();
    try {
      final List<Post> results = await _service.fetchPosts();
      _state = PostLoaded(results);
    } catch (e) {
      _state = PostError("Could not load posts.");
    } finally {
      notifyListeners();
    }
  }
}
