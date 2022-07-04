import 'package:flutter/material.dart';

import '../common_widget/side_drawer.dart';


class OurStory extends StatelessWidget {
  static const routeName = '/our-story';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        iconTheme: new IconThemeData(color: Theme.of(context).primaryColor),
        title: Text(
          'Our Story',
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
                  'Kamyavan is non-profit organization focusing in developing sustainable Holistic Natural Farming. We have model farm communities close to Hyderabad and Bangalore where we train thousands of farmers in Natural Farming.',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Kamyavan Naturals is developing authentic natural farming techniques, also collaborating with established farmers to encourage growth and intake of organic products. As many farmers who are doing contemporary farming are in fact getting aware of the importance of Organic cultivation and Natural farming, but are hesitant to adapt those methods, we wanted to go in aid of them. We wanted to provide those farmers who are producing organic food or following ZBNF or natural methods of cultivation without using chemical fertilizers and pesticides, a market place to sell their products for fair enough prices.',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'When we had an interaction with such farmers, they helplessly said that they had to sell organic products at normal market price those it took them lot of efforts to get the crop out. Also the consumers complained that the cost of organic and natural products which they are getting in the markets is too high and hence can’t afford to buy, also they say that they can’t be sure of the authenticity of the products which are available in the market, claiming to be organic.',
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
                  'We harvest the natural grown vegetables & other products from these farmer farms every week and place them in Kamyavan Naturals for sale in the farm of Vegetable, Fruit and Millet baskets. We display the information of the farmer who is cultivating the particular product for every item that is placed in our application. This is to assure the consumers that all the products are 100% naturally grown or organic certified.',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'We invite you all to join our Kamyavan Naturals family to benefit yourself with a healthy life and for the benefit of farmers who wish to grow chemical free food. Let us together work towards a healthy and better society and save ourselves and our planet Earth from the jaws of harmful chemical.',
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
