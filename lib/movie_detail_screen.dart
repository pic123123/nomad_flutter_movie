import 'package:flutter/material.dart';

class MovieDetail {
  final String title;
  final String posterPath;
  final double voteAverage;
  final String overview;
  final List<Genre> genres;

  MovieDetail({
    required this.title,
    required this.posterPath,
    required this.voteAverage,
    required this.overview,
    required this.genres,
  });

  factory MovieDetail.fromJson(Map<String, dynamic> json) {
    return MovieDetail(
      title: json['title'],
      posterPath: json['poster_path'],
      voteAverage: json['vote_average'].toDouble(),
      overview: json['overview'],
      genres: (json['genres'] as List<dynamic>)
          .map((genreJson) => Genre.fromJson(genreJson))
          .toList(),
    );
  }
}

class Genre {
  final int id;
  final String name;

  Genre({
    required this.id,
    required this.name,
  });

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      id: json['id'],
      name: json['name'],
    );
  }
}

// 별표로 등급 표시하는 함수
Widget buildRatingStars(double rating) {
  int fullStars = (rating / 2).floor();
  bool hasHalfStar = rating % 2 >= 0.5;
  int emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);

  return Row(
    children: [
      for (int i = 0; i < fullStars; i++)
        const Icon(Icons.star, color: Colors.yellow),
      if (hasHalfStar) const Icon(Icons.star_half, color: Colors.yellow),
      for (int i = 0; i < emptyStars; i++)
        const Icon(Icons.star_border, color: Colors.yellow),
    ],
  );
}

class MovieDetailScreen extends StatelessWidget {
  final MovieDetail detail;

  const MovieDetailScreen({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Opacity(
            opacity: 0.6,
            child: Image.network(
              'https://image.tmdb.org/t/p/w500${detail.posterPath}',
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
              alignment: Alignment.center,
            ),
          ),
          Column(
            children: [
              // 상단 뒤로 가기 버튼과 제목
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "Back to list",
                        // 제목 스타일 설정
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 중간 영화 세부정보
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        detail.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      buildRatingStars(detail.voteAverage),
                      // Text(
                      //   '${detail.voteAverage}',
                      //   style: const TextStyle(
                      //     color: Colors.black,
                      //   ),
                      // ),
                      const SizedBox(height: 20),
                      Text(
                        detail.genres.map((genre) => genre.name).join(', '),
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 50),
                      const Text(
                        "Storyline",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        detail.overview,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // 하단 가운데 Buy Ticket 버튼
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // 버튼 동작 코드 작성
                    },
                    child: const Text('Buy Ticket'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
