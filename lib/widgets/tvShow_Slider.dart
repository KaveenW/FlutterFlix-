import 'package:flutter/material.dart';
import 'package:flutflix/models/tv_show.dart';
import '../screens/details_screen.dart';

class TvShowSlider extends StatelessWidget {
  final AsyncSnapshot<List<TvShow>> snapshot;

  const TvShowSlider({
    required this.snapshot,
  });

  @override
  Widget build(BuildContext context) {
    final tvShows = snapshot.data;

    if (tvShows == null || tvShows.isEmpty) {
      return const Center(child: Text('No TV shows available'));
    }

    return SizedBox(
      height: 200,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: tvShows.length,
        itemBuilder: (context, index) {
          final tvShow = tvShows[index];

          // ignore: unnecessary_null_comparison
          final imageUrl = tvShow.posterPath != null
              ? 'https://image.tmdb.org/t/p/w500${tvShow.posterPath}'
              : 'https://image.tmdb.org/t/p/w500${tvShow.backdropPath}';

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MovieScreen(
                      movie: null,
                      result: null,
                      tvShow: tvShow, // Pass the TvShow object
                    ),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  height: 200,
                  width: 150,
                  child: Image.network(
                    imageUrl,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.movie);
                    },
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
