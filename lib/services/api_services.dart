import 'dart:convert';
import 'dart:developer';

import 'package:flutter_application_netflix/common/utils.dart';
import 'package:flutter_application_netflix/models/movie_detailed_model.dart';
import 'package:flutter_application_netflix/models/movie_recommendation_model.dart';
import 'package:flutter_application_netflix/models/search_model.dart';
import 'package:flutter_application_netflix/models/tv_series_model.dart';
import 'package:flutter_application_netflix/models/upcoming_model.dart';

import 'package:http/http.dart' as http;

const baseUrl = "https://api.themoviedb.org/3/";
var key = "?api_key=$apiKey";
late String endPoint;

class ApiServices {
  Future<UpcomingMovieModel> getUpcomingMovies() async {
    endPoint = "movie/upcoming";
    final url = "$baseUrl$endPoint$key";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      log("success response: ${response.body}");

      return UpcomingMovieModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to load upcoming movies");
  }

  Future<UpcomingMovieModel> getNowPlayingMovies() async {
    endPoint = "movie/now_playing";
    final url = "$baseUrl$endPoint$key";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      log("success response: ${response.body}");

      return UpcomingMovieModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to load now playing movies");
  }

  Future<TvSeriesModel> getTopRatedSeries() async {
    endPoint = "tv/top_rated";
    final url = "$baseUrl$endPoint$key";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      log("success response: ${response.body}");

      return TvSeriesModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to load top rated tvseries");
  }

  Future<SearchModel> getSearchedMovies(String searchText) async {
    endPoint = "search/movie?query=$searchText";
    final url = "$baseUrl$endPoint";
    print("search url is $url");

    final response = await http.get(Uri.parse(url), headers: {
      'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI0MjMwODY3MjIwMjY1ODdkNmZlZmQwNzc0Y2VlMmZkYyIsInN1YiI6IjY2NTE2M2IyYmYwNzI3ODAxMTk2MDIxOSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.B4QIEGvJrVHWJFDLAo4z1XRJ8LIBcLhDv91CyKkBry8'
    });

    if (response.statusCode == 200) {
      log("Success");
      log(response.body);

      return SearchModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to load searched movie");
  }

  Future<MovieRecommendationsModel> getPopularMovies() async {
    endPoint = "movie/popular";
    final url = "$baseUrl$endPoint$key";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      log("success response: ${response.body}");

      return MovieRecommendationsModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to load popular movies");
  }

  Future<MovieDetailModel> getMovieDetail(int movieId) async {
    endPoint = "movie/$movieId";
    final url = "$baseUrl$endPoint$key";
    print("movie details url is $url");

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      log("Success");

      return MovieDetailModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to load movie details");
  }

  Future<MovieRecommendationsModel> getMovieRecommendations(int movieId) async {
    endPoint = "movie/$movieId/recommendations";
    final url = "$baseUrl$endPoint$key";
    print("recommendations url is $url");

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      log("Success");

      return MovieRecommendationsModel.fromJson(jsonDecode(response.body));
    }
    throw Exception("Failed to load more like this");
  }
}
