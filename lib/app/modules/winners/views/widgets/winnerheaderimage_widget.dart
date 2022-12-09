import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reel_ro/utils/assets.dart';
import 'package:reel_ro/utils/colors.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shimmer/shimmer.dart';

class WinnerHeaderImage extends StatelessWidget {
  WinnerHeaderImage(
    this.images, {
    Key? key,
  }) : super(key: key);
  List<String> images;
  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;
    final style = theme.textTheme;
    return CarouselSlider.builder(
      itemCount: images.length,
      options: CarouselOptions(
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 4),
        aspectRatio: 1.5,
        enlargeCenterPage: true,
      ),
      itemBuilder: (context, index, realIdx) {
        return Center(
          child:
              // Image.asset(Assets.winnerHeaderImage)

              CachedNetworkImage(
            fit: BoxFit.cover,
            width: 1500,
            imageUrl: images[index].toString(),
            placeholder: (context, url) => Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              enabled: true,
              child: Container(
                height: 300,
                width: 1500,
                color: Colors.white,
              ),
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        );
      },
    );

    //  Container(
    //   padding: const EdgeInsets.only(
    //     bottom: 12,
    //   ),
    //   margin: const EdgeInsets.all(8.0),
    //   height: 223,
    //   width: double.infinity,
    //   alignment: Alignment.bottomCenter,
    //   decoration: const BoxDecoration(
    //     borderRadius: BorderRadius.all(
    //       Radius.circular(1),
    //     ),
    //     image: DecorationImage(
    //       image: AssetImage(Assets.winnerHeaderImage),
    //     ),
    //   ),
    //   child: Text(
    //     'Mega Prize Winner',
    //     style: style.headline5!.copyWith(
    //       color: AppColors.whiteappbar,
    //       fontWeight: FontWeight.bold,
    //     ),
    //   ),
    // );
  }
}
