
import 'package:fancy_on_boarding/fancy_on_boarding.dart';
import 'package:flutter/material.dart';


import '../helpers/shared_preferences_helper.dart';
import 'login.dart';

class OnboardingScreen extends StatelessWidget {
  final pageList = [
    PageModel(
        color: const Color(0xFF678FB4),

        heroImagePath: 'assets/images/placeholder.png',
        title: const Text(
          'NATURAL PRODUCTS',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        body: const Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
          ),
          child:  Text(
              'Our products are procured from farmers who practice natural farming methods without pesticides and harmful chemicals.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              )),
        ),
        iconImagePath: 'assets/images/placeholder_icon.png'),
    PageModel(
        color: const Color(0xFF65B0B4),
        heroImagePath: 'assets/images/placeholder.png',
        title: const Text('TOP QUALITY',
            style:  TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 20,
            )),
        body: const Padding(
          padding:  EdgeInsets.only(
            left: 20,
            right: 20,
          ),
          child:  Text(
              'Our products undergo various quality checks before it is available to out customers.',
              textAlign: TextAlign.center,
              style:  TextStyle(
                color: Colors.black,
                fontSize: 16,
              )),
        ),
        iconImagePath: 'assets/images/placeholder_icon.png'),
    PageModel(
      color: const Color(0xFF9B90BC),
      heroImagePath: 'assets/images/placeholder.png',
      title: const Text('FARM FRESH',
          style:  TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 20,
          )),
      body: const Padding(
        padding:  EdgeInsets.only(
          left: 20,
          right: 20,
        ),
        child:  Text(
            'Our products directly goes from the farmer\'s hands to our customers as fresh as it comes.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
            )),
      ),
      iconImagePath: 'assets/images/placeholder_icon.png',
    ),
    PageModel(
      color: const Color(0xFF678FB4),
      heroImagePath: 'assets/images/placeholder.png',
      title: const Text('HOME DELIVERY',
          style:  TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 20,
          )),
      body: const Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
        ),
        child: Text(
            'We constantly aim to provide fastest and hassle-free delivery experience to our customers.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            )),
      ),
      iconImagePath: 'assets/images/placeholder_icon.png',
    ),
    PageModel(
      color: const Color(0xFF65B0B4),
      heroImagePath: 'assets/images/placeholder.png',
      title: const Text('DISCOUNT COUPONS',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 20,
          )),
      body: const Padding(
        padding:  EdgeInsets.only(
          left: 20,
          right: 20,
        ),
        child: const Text(
            'Invite your friends and family to KAMYAVAN NATURALS SHOP and earn various coupons and discounts.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
            )),
      ),
      iconImagePath: 'assets/images/placeholder_icon.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FancyOnBoarding(
        doneButtonText: "Done",
        skipButtonText: "Skip",
        pageList: pageList,
        onDoneButtonPressed: () {
          SharedPreferencesHelper.setValue(
              SharedPreferencesHelper.onboardingVisited, 'YES');
          Navigator.of(context).pushReplacementNamed(Login.routeName);
        },
        onSkipButtonPressed: () {
          SharedPreferencesHelper.setValue(
              SharedPreferencesHelper.onboardingVisited, 'YES');
          Navigator.of(context).pushReplacementNamed(Login.routeName);
        },
      ),
    );
  }
}