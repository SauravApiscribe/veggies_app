import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'onborading/login.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // initializeFcm();
  runApp(App());
}



class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KAMYAVAN NATURALS',
      theme: ThemeData(
        primaryColor: Colors.green,
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.white),
      ),
      home:Login()
    );

    //   FutureBuilder<bool>(
    //       future: _hasVisitedOnboarding(),
    //       builder: (BuildContext context, AsyncSnapshot<bool> snapshot) =>
    //       !snapshot.hasData
    //           ? FullScreenLoader()
    //           : snapshot.data
    //           ? FutureBuilder<bool>(
    //         future: _isUserLoggedIn(context),
    //         builder: (BuildContext context,
    //             AsyncSnapshot<bool> snapshot) =>
    //         !snapshot.hasData
    //             ? FullScreenLoader()
    //             : snapshot.data
    //             ? Home()
    //             : Login(),
    //       )
    //           : Login()),
    //   routes: {
    //     Home.routeName: (ctx) => Home(),
    //     Login.routeName: (ctx) => Login(),
    //     OtpScreen.routeName: (ctx) => OtpScreen(),
    //     SignUp.routeName: (ctx) => SignUp(),
    //     ProductList.routeName: (ctx) => ProductList(),
    //     ProductDetails.routeName: (ctx) => ProductDetails(),
    //     PreviousOrders.routeName: (ctx) => PreviousOrders(),
    //     FavoriteProducts.routeName: (ctx) => FavoriteProducts(),
    //     MyDeliveries.routeName: (ctx) => MyDeliveries(),
    //     ManageAddress.routeName: (ctx) => ManageAddress(),
    //     OurStory.routeName: (ctx) => OurStory(),
    //     WhyUs.routeName: (ctx) => WhyUs(),
    //   },
    // );
  }
}

// Future<bool> _hasVisitedOnboarding() async =>
//     (await SharedPreferencesHelper.getValue(
//         SharedPreferencesHelper.onboardingVisited))
//         .isNotEmpty;
//
// Future<bool> _isUserLoggedIn(BuildContext context) async {
//   checkForUpdates(context);
//
//   if ((await SharedPreferencesHelper.getValue(SharedPreferencesHelper.token))
//       .isNotEmpty) {
//     http.get(urls.signup, {}).then((response) {
//       SharedPreferencesHelper.setMembershipFlag(
//           response['responseData']['user']['doesHoldMembership']);
//       SharedPreferencesHelper.setIsEmailVerified(
//           response['responseData']['user']['isEmailVerified']);
//     });
//     return true;
//   }
//   return false;
// }
//
// void checkForUpdates(BuildContext context) {
//   http.get(
//     urls.version + '?versionName=' + APP_VERSION,
//     {},
//   ).then((response) {
//     if (!response['responseData']['isLatest'] &&
//         response['responseData']['updateType'] == 'MANDATORY') {
//       String updateDetails = '';
//       var updateDetailsList = (response['responseData']['updateDetails']
//       ['updateFeatures'] as List<dynamic>)
//           .map((e) => '$e')
//           .toList();
//       updateDetailsList.forEach((element) {
//         updateDetails = updateDetails + element + '\n';
//       });
//       displayMessageWithAction(
//           context,
//           "This is mandatory update and includes following features:\n$updateDetails",
//               () => StoreRedirect.redirect());
//     }
//   }).catchError((error,) {});
// }