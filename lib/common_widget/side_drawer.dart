import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../about/our_story.dart';
import '../about/why_us.dart';
import '../helpers/shared_preferences_helper.dart';
import '../home_screen.dart';
import '../my_account/user_dto.dart';
import '../onborading/login.dart';
import '../util/constants.dart';


class SideDrawer extends StatelessWidget {
  _launchURL() async {
    const url = 'mailto:$support_email?subject=$support_email_subject';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 150,
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            alignment: Alignment.centerLeft,
            color: Theme.of(context).primaryColor,
            child: Padding(
              padding: const EdgeInsets.only(top: 25, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset(
                    'assets/images/logoe.png',
                    fit: BoxFit.cover,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text(
                        appName_1,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 25,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        appName_2,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 25,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: IconButton(
              icon: const Icon(
                Icons.home,
                color: Colors.orange,
              ), onPressed: () {  },
            ),
            title: const Text('HOME'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed(Home.routeName);
            },
          ),
          const Divider(
            color: Colors.black,
          ),
          ListTile(
            leading: IconButton(
              icon: const Icon(
                Icons.description,
                color: Colors.orange,
              ), onPressed: () {  },
            ),
            title: const Text('OUR STORY'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed(OurStory.routeName);
            },
          ),
          const Divider(
            color: Colors.black,
          ),
          ListTile(
            leading: IconButton(
              icon: const Icon(
                Icons.question_answer,
                color: Colors.orange,
              ), onPressed: () {  },
            ),
            title: const Text('WHY US?'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed(WhyUs.routeName);
            },
          ),
          const Divider(
            color: Colors.black,
          ),
          ListTile(
            leading: IconButton(
              icon: const Icon(
                Icons.contact_mail,
                color: Colors.orange,
              ), onPressed: () {  },
            ),
            title: const Text('CONTACT US'),
            onTap: _launchURL,
          ),
          const Divider(
            color: Colors.black,
          ),
          FutureBuilder(
            future: SharedPreferencesHelper.getUserDetails(),
            builder: (BuildContext context, AsyncSnapshot<UserDto> snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }
              if (snapshot.data!.token.isEmpty) {
                return ListTile(
                  leading: IconButton(
                    icon: const Icon(
                      Icons.login,
                      color: Colors.orange,
                    ), onPressed: () {  },
                  ),
                  title: const Text('LOGIN'),
                  onTap: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        Login.routeName, (Route<dynamic> route) => false);
                  },
                );
              } else {
                return ListTile(
                  leading: IconButton(
                    icon: const Icon(
                      Icons.exit_to_app,
                      color: Colors.orange,
                    ), onPressed: () {  },
                  ),
                  title: const Text('LOGOUT'),
                  onTap: () {
                    [
                      SharedPreferencesHelper.token,
                      SharedPreferencesHelper.mobile,
                      SharedPreferencesHelper.email,
                      SharedPreferencesHelper.firstName,
                      SharedPreferencesHelper.lastName,
                      SharedPreferencesHelper.cart,
                      SharedPreferencesHelper.isEmailVerified,
                      SharedPreferencesHelper.doesHoldMembership,
                    ].forEach((element) =>
                        SharedPreferencesHelper.removeValue(element));
                    Navigator.of(context).pushReplacementNamed(Login.routeName);
                  },
                );
              }
            },
          ),
          const Divider(
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}

