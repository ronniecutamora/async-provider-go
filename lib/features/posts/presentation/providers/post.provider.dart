import 'package:async_provider_go/features/posts/domain/models/post.model.dart';
import 'package:async_provider_go/features/posts/domain/repositories/post.repository.dart';
import 'package:flutter/material.dart';

// ── List states ─────────────────────────────────────────────────────────────
sealed class PostState {}
class PostInitial extends PostState {}
class PostLoading extends PostState {}
class PostError extends PostState {
  final String message;
  PostError(this.message);
}
class PostLoaded extends PostState {
  final List<Post> posts;
  PostLoaded(this.posts);
}

// ── Detail states ────────────────────────────────────────────────────────────
sealed class PostDetailState {}
class PostDetailInitial extends PostDetailState {}
class PostDetailLoading extends PostDetailState {}
class PostDetailError extends PostDetailState {
  final String message;
  PostDetailError(this.message);
}
class PostDetailLoaded extends PostDetailState {
  final Post post;
  PostDetailLoaded(this.post);
}

/// ViewModel for the Posts feature.
///
/// Owns both the list state and the detail state so a single
/// [ChangeNotifierProxyProvider] in main.dart covers the entire feature.
class PostProvider extends ChangeNotifier {
  final PostRepository _repository;
  PostProvider(this._repository);

  // ── List ──────────────────────────────────────────────────────────────────
  PostState _state = PostInitial();
  PostState get state => _state;

  Future<void> loadPosts() async {
    _state = PostLoading();
    notifyListeners();
    try {
      final posts = await _repository.getPosts();
      _state = PostLoaded(posts);
    } catch (e) {
      _state = PostError(e.toString());
    } finally {
      notifyListeners();
    }
  }

  // ── Detail ────────────────────────────────────────────────────────────────
  PostDetailState _detailState = PostDetailInitial();
  PostDetailState get detailState => _detailState;

  Future<void> loadPost(int id) async {
    _detailState = PostDetailLoading();
    notifyListeners();
    try {
      final post = await _repository.getPostById(id);
      _detailState = PostDetailLoaded(post);
    } catch (e) {
      _detailState = PostDetailError(e.toString());
    } finally {
      notifyListeners();
    }
  }
}