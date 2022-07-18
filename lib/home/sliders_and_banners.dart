import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import '../common_widget/cached_image.dart';
import '../imageName.dart';
import '/networking/fetch.dart' as http;
import '/networking/urls.dart' as urls;

class SlidersAndBanners extends StatelessWidget {
  Future<BannersDto> _fetchSliderImages() async {
    dynamic response = await http.get(urls.slider, {});
    BannersDto bannersDto = BannersDto.fromJson(response['responseData']);
    return bannersDto;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child:Image.asset(ImageList.image[0]),
          height: (MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top -
              MediaQuery.of(context).padding.bottom) *
              0.15,
        ),
        Container(
          margin: EdgeInsets.only(top:10),
          height: (MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top -
              MediaQuery.of(context).padding.bottom) *
              0.30,
          child: Swiper(
            duration: 500,
            itemWidth: double.infinity,
            pagination: const SwiperPagination(
              builder: SwiperPagination.rect,
            ),
            itemCount: ImageList.image.length,
            itemBuilder:
                (BuildContext context, int index) =>
                Image.asset(
                    ImageList.image[index],
                ),
            autoplay: true,
          ),
        ),
      ],
    );
  }
}

class BannersDto {
  final List<dynamic> banners;
  final List<dynamic> sliders;

  BannersDto.fromJson(Map<String, dynamic> json)
      : banners = (json['banners'] as List<dynamic>).map((e) {
          return e['image'];
        }).toList(),
        sliders = (json['sliders'] as List<dynamic>).map((e) {
          return e['image'];
        }).toList();
}
