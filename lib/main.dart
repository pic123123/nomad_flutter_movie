import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MovieResponse {
  final int page;
  final List<Movie> results;

  MovieResponse({required this.page, required this.results});

  factory MovieResponse.fromJson(Map<String, dynamic> json) {
    return MovieResponse(
        page: json['page'],
        results: List<Movie>.from(
            json['results'].map((item) => Movie.fromJson(item))));
  }
}

class Movie {
  final bool adult;
  final String backdropPath;
  final List<int> genreIds;
  final int id;
  final String originalLanguage;
  final String originalTitle;
  final String overview;
  final double popularity;
  final String posterPath;
  final String releaseDate;
  final String title;
  final bool video;
  final double voteAverage;
  final int voteCount;

  Movie({
    required this.adult,
    required this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.releaseDate,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
        adult: json['adult'],
        backdropPath: json['backdrop_path'],
        genreIds: List<int>.from(json['genre_ids']),
        id: json['id'],
        originalLanguage: json['original_language'],
        originalTitle: json['original_title'],
        overview: json['overview'],
        popularity: json['popularity'].toDouble(),
        posterPath: json['poster_path'],
        releaseDate: json['release_date'],
        title: json['title'],
        video: json['video'],
        voteAverage: json['vote_average'].toDouble(),
        voteCount: json['vote_count']);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Movie',
      home: MyHomePage(title: 'Movie'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //데이터 가져와서 json에 담음
  Future<MovieResponse> fetchPopularMovies() async {
    final response = await http
        .get(Uri.parse('https://movies-api.nomadcoders.workers.dev/popular'));

    if (response.statusCode == 200) {
      return MovieResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch movies');
    }
  }

  Future<MovieResponse> fetchNowPlayingMovies() async {
    final response = await http.get(
        Uri.parse('https://movies-api.nomadcoders.workers.dev/now-playing'));

    if (response.statusCode == 200) {
      return MovieResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch movies');
    }
  }

  Future<MovieResponse> fetchComingSoonMovies() async {
    final response = await http.get(
        Uri.parse('https://movies-api.nomadcoders.workers.dev/coming-soon'));

    if (response.statusCode == 200) {
      return MovieResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch movies');
    }
  }

  late Future<MovieResponse> futurePopularMovies;
  late Future<MovieResponse> futureNowPlayingMovies;
  late Future<MovieResponse> futureComingSoonMovies;

  @override
  void initState() {
    super.initState();
    futurePopularMovies = fetchPopularMovies();
    futureNowPlayingMovies = fetchNowPlayingMovies();
    futureComingSoonMovies = fetchComingSoonMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.grey[900],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            // 이 부분 추가
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              "Popular Movies",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Center(
              child: FutureBuilder<MovieResponse>(
                future: futurePopularMovies,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.results.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.network(
                            'https://image.tmdb.org/t/p/w500${snapshot.data!.results[index].posterPath}',
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }

                  return const CircularProgressIndicator();
                },
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Now in cinemas",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: FutureBuilder<MovieResponse>(
                    future: futureNowPlayingMovies,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.results.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: 100, // 이미지와 텍스트의 최대 너비를 설정합니다.
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    AspectRatio(
                                      aspectRatio: 0.7,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image.network(
                                          'https://image.tmdb.org/t/p/w500${snapshot.data!.results[index].posterPath}',
                                          fit: BoxFit.fitHeight,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                        height: 8.0), // 제목과 이미지 사이의 간격을 추가
                                    Flexible(
                                      child: Text(
                                        snapshot.data!.results[index].title,
                                        style: const TextStyle(fontSize: 16),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }

                      return const CircularProgressIndicator();
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            // 이 부분 추가
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              "Comming Soon",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Center(
              child: FutureBuilder<MovieResponse>(
                future: futureComingSoonMovies,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.results.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.network(
                            'https://image.tmdb.org/t/p/w500${snapshot.data!.results[index].posterPath}',
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }

                  return const CircularProgressIndicator();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
