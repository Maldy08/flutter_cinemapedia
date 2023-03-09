import 'package:flutter_cinemapedia/domain/entities/movie.dart';
import 'package:flutter_cinemapedia/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchQueryProvider = StateProvider((ref) => '');

typedef SearchMovieCallback = Future<List<Movie>> Function(String query);
final searchedMoviesProvider =
    StateNotifierProvider<SearchedMoviesNotifier, List<Movie>>((ref) {
  final movieRepository = ref.read(movieRepositoryProvider);

  return SearchedMoviesNotifier(
    searchMovies: movieRepository.searchMovies,
    ref: ref,
  );
});

class SearchedMoviesNotifier extends StateNotifier<List<Movie>> {
  final SearchMovieCallback searchMovies;
  final Ref ref;

  SearchedMoviesNotifier({
    required this.searchMovies,
    required this.ref,
  }) : super([]);

  Future<List<Movie>> searchMovieByQuery(String query) async {
    final List<Movie> movies = await searchMovies(query);
    ref.read(searchQueryProvider.notifier).update((state) => query);
    state = movies;
    return movies;
  }
}
