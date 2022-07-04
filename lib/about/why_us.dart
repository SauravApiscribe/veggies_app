import 'package:flutter/material.dart';

import '../common_widget/side_drawer.dart';


class WhyUs extends StatelessWidget {
  static const routeName = '/why-us';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).accentColor,
        iconTheme: new IconThemeData(color: Theme.of(context).primaryColor),
        title: Text(
          'Why Us?',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      drawer: SideDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  'We believe in holistic approach. Nature, Cow, Farmer and You – all are distinct parts of a common ecosystem.',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  '\u2022  Nature should be protected from being polluted. Solution: Cow/ZBNF based Natural farming',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  '\u2022  Cows should be protected from discrimination & pain. Solution: Cows should be with Farmers',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  '\u2022  Farmers should be protected from current day crisis. Solution: You must support Farmers economically, financially and morally',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  '\u2022  Human should be protected from unhealthy food. Kamyavan Naturals is trying to do its part to fix this.',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'The organic farmers, who we interacted with, were facing different problem in producing and selling the naturally grown products with the same cost as conventional ones.',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'We started collaborating with farmers who are following organic, Natural or ZBNF practices of cultivation after checking the authenticity by visiting their farms and making sure that they are 100% genuine.',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'It takes a lot of effort and dedication to follow the natural farming practices and the returns they are getting from the produce is not matching their efforts. This is discouraging the farmers to continue natural cultivation and is tending towards making them shift to conventional methods again.',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'To increase the demand, the cost is to be reduced for the consumers and to increase the production the farmer should be given a reasonable price for his supplies.',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'This would surely encourage the consumers to switch to organic or naturally grown products as they are able to get them at almost at the same price as conventional products. This would in turn increase the demand and hence the farmers would get ready to produce more without any inhibitions of their crop being sold for small pennies.',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'We welcome interested farmers who are following natural, zbnf or organic farming, to collaborate with us and share your produce as we offer reasonable price for your products.',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
