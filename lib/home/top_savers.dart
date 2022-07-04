import 'package:flutter/material.dart';
import 'package:veggies_app/home/savers_dto.dart';
import 'package:veggies_app/home/top_savers_block.dart';
import '../networking/fetch.dart' as http;
import '../networking/urls.dart' as urls;


class TopSavers extends StatelessWidget {
  Future<SaversDto> _fetchProducts() async {
    dynamic response = await http.get(urls.savers, {});
    SaversDto savers = SaversDto.fromJson(response['responseData']['savers']);
    return savers;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fetchProducts(),
      builder: (BuildContext context, AsyncSnapshot<SaversDto> snapshot) =>
          (!snapshot.hasData)
              ? SizedBox()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TopSaversBlock(snapshot.data!.daily, 'Day'),
                    TopSaversBlock(snapshot.data!.weekly, 'Week'),
                  ],
                ),
    );
  }
}
