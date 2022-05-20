import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:verdhale/src/models/free_service_model.dart';
import 'package:verdhale/src/screens/freeservice_screen.dart';
import 'package:verdhale/src/utils/constant.dart';

class CustomCarouselSlider {
  static getCarouselSlider({required List<FreeServiceModel> carouselItems}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: CarouselSlider(
        options: CarouselOptions(
          height: 180,
          scrollDirection: Axis.horizontal,
          viewportFraction: 0.8,
          autoPlay: true,
          enlargeCenterPage: true,
        ),
        items: carouselItems
            .map(
              (service) => Builder(
                builder: (BuildContext context) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => FreeServiceScreen(
                            url: service.url,
                          ),
                        ),
                      );
                    },
                    child: CachedNetworkImage(
                      imageUrl: service.image,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 30,
                              color: Colors.black54.withOpacity(.09),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(15),
                          color: kGreenColor.withOpacity(.5),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => const Center(
                          child: Icon(Icons.error, color: Colors.red)),
                    ),
                  );
                },
              ),
            )
            .toList(),
      ),
    );
  }
}
