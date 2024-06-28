import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_netflix/common/utils.dart';
import 'package:flutter_application_netflix/models/movie_detailed_model.dart';
import 'package:flutter_application_netflix/models/movie_recommendation_model.dart';
import 'package:flutter_application_netflix/services/api_services.dart';

class MovieDetailScreen extends StatefulWidget {
  final int movieId;
  const MovieDetailScreen({super.key, required this.movieId});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  ApiServices apiServices = ApiServices();

  late Future<MovieDetailModel> movieDetail;
  late Future<MovieRecommendationsModel> movieRecommendations;

  @override
  void initState() {
    super.initState();
    fetchInitialData();
  }

  fetchInitialData() {
    movieDetail = apiServices.getMovieDetail(widget.movieId);
    movieRecommendations = apiServices.getMovieRecommendations(widget.movieId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print("hey movieid is ${widget.movieId}");
    return Scaffold(
      body: SingleChildScrollView(
        child: FutureBuilder(
            future: movieDetail,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final movie = snapshot.data;
                String genreText =
                    movie!.genres.map((genre) => genre.name).join(', ');
                return Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.4,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                "$imageUrl${movie.posterPath}",
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: SafeArea(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.arrow_back_ios,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movie.title,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Text(
                              movie.releaseDate.year.toString(),
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            Text(
                              genreText,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          movie.overview,
                          maxLines: 6,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 17),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    FutureBuilder(
                        future: movieRecommendations,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final movie = snapshot.data;

                            return movie!.results.isEmpty
                                ? const SizedBox()
                                : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text("More like this"),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      GridView.builder(
                                        padding: EdgeInsets.zero,
                                        itemCount: movie.results.length,
                                        shrinkWrap: true,
                                        physics:
                                        const NeverScrollableScrollPhysics(),
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 3,
                                                mainAxisSpacing: 15,
                                                crossAxisSpacing: 5,
                                                childAspectRatio: 1.5 / 2),
                                        itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              MovieDetailScreen(
                                            movieId: movie.results[index].id,
                                          ),
                                        ),
                                      );
                                    },
                                          child: CachedNetworkImage(
                                                imageUrl:
                                                    "$imageUrl${movie.results[index].posterPath}"),
                                        );
                                        },
                                      )
                                    ],
                                  );
                          }
                          return const Text("Somthing went wrong");
                        })
                  ],
                );
              } else {
                return const Text("error");
              }
            }),
      ),
    );
  }
}
