import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  final double rating;
  final double starSize;
  final Color color;

  RatingStars(
      {required this.rating, this.starSize = 20, this.color = Colors.yellow});

  @override
  Widget build(BuildContext context) {
    int numberOfFullStars = rating ~/ 2;
    double halfStarPercentage = (rating / 2) - numberOfFullStars;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < numberOfFullStars) {
          return Icon(Icons.star, color: color, size: starSize);
        } else if (index == numberOfFullStars && halfStarPercentage != 0) {
          return Icon(Icons.star_half, color: color, size: starSize);
        } else {
          return Icon(Icons.star_border, color: color, size: starSize);
        }
      }),
    );
  }
}
