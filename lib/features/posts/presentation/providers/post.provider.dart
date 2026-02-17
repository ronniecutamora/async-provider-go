import 'package:async_provider_go/features/posts/domain/repositories/post.repository.dart';
import 'package:flutter/material.dart';
import '../../domain/models/post.model.dart';

sealed class PostState {}
class PostInitial extends PostState {}
class PostLoading extends PostState {}
class PostError extends PostState { final String message; PostError(this.message); }
class PostLoaded extends PostState { 
  final List<Post> posts; 
  PostLoaded(this.posts); 
}

class PostProvider extends ChangeNotifier {
  final PostRepository _repository;
  PostProvider(this._repository);

  PostState _state = PostInitial();
  PostState get state => _state;

  Future<void> loadPosts() async {
    _state = PostLoading();
    notifyListeners();
    try {
      final List<Post> results = await _repository.getPosts();
      _state = PostLoaded(results);
    } catch (e) {
      _state = PostError(e.toString());
    } finally {
      notifyListeners();
    }
  }
}