import 'package:flutflix/screens/details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutflix/constants.dart';
import 'package:flutflix/models/movie.dart';
import 'package:flutflix/models/tv_show.dart';

class RecommendationWidget<T> extends StatelessWidget {
  final List<T> recommendations;

  const RecommendationWidget({Key? key, required this.recommendations})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Recommended",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (var recommendation in recommendations)
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: GestureDetector(
                    onTap: () {
                      if (recommendation is Movie) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MovieScreen(
                              movie: recommendation,
                              tvShow: null,
                              result: null,
                            ),
                          ),
                        );
                      } else if (recommendation is TvShow) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MovieScreen(
                              movie: null,
                              tvShow: recommendation,
                              result: null,
                            ),
                          ),
                        );
                      }
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        '${Constants.imagePath}${recommendation is Movie ? recommendation.posterPath : (recommendation as TvShow).posterPath}',
                        height: 130,
                        width: 120,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
