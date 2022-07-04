import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:veggies_app/my_account/user_dto.dart';

import '../helpers/shared_preferences_helper.dart';
import '../theme/secondary_button.dart';
import '../util/constants.dart';
import 'edit_user_details.dart';
import 'manage_address.dart';


class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {

  _launchURL() async {
    const url = 'mailto:$support_email?subject=$support_email_subject';
    if (!await launchUrl(Uri.parse(url))) throw 'Could not launch $url';
  }

  void resendVerificationEmail(BuildContext ctx) async {
  //   showLoader(ctx, title: 'Resending mail');
  //   UserDto userDetails = await SharedPreferencesHelper.getUserDetails();
  //   http.post(urls.signup, {}, {
  //     'resend': true,
  //     'mobile': userDetails.mobile,
  //   }).then((value) {
  //     hideLoader(ctx);
  //     displayToastMessage('Resent verification email!', color: Colors.orange);
  //   }).catchError((error) {
  //     hideLoader(ctx);
  //     print(error);
  //   });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder<UserDto>(
            future: SharedPreferencesHelper.getUserDetails(),
            builder: (BuildContext context, AsyncSnapshot<UserDto> snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }
              if (snapshot.data!.token.isEmpty) {
                return Container(
                  padding: EdgeInsets.only(top: (MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom) *
                      0.40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'You need to login first',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return Container(
                color: Colors.white,
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${snapshot.data!.firstName} ${snapshot.data!.lastName}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                snapshot.data!.mobile,
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                          SecondaryButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => EditUserDetails(
                                    snapshot.data!.mobile,
                                    snapshot.data!.email,
                                    snapshot.data!.firstName,
                                    snapshot.data!.lastName,
                                  ),
                                ),
                              ).then((value) {
                                setState(() {});
                              });
                            },
                            title: 'Edit',
                            color: Colors.orange,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            snapshot.data!.email,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          FutureBuilder<UserDto>(
                            future: SharedPreferencesHelper.getUserDetails(),
                            builder: (BuildContext ctx,
                                AsyncSnapshot<UserDto> snapshot) {
                              if (!snapshot.hasData) {
                                return SizedBox();
                              }
                              if (snapshot.data!.isEmailVerified) {
                                return Row(
                                  children: [
                                    Icon(
                                      Icons.done,
                                      color: Colors.green,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      'Email verified',
                                    )
                                  ],
                                );
                              } else {
                                return ElevatedButton(

                                  onPressed: () => resendVerificationEmail(ctx),
                                  child: Text('Verify'),

                                );
                              }
                            },
                          )
                        ],
                      ),
                      buildMenus(),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildMenus() {
    return Column(
      children: [
        Divider(
          thickness: 1,
          color: Colors.black,
        ),
        getManuCard('My Orders', () {
          // Navigator.of(context).pushNamed(PreviousOrders.routeName);
        }, Icons.history),
        getManuCard('My Basket', () {
          // Navigator.of(context).pushNamed(MyDeliveries.routeName);
        }, Icons.shopping_basket),
        getManuCard('My Address', () {
          // Navigator.of(context).pushNamed(ManageAddress.routeName);
        }, Icons.location_on),
        getManuCard('My Favorites', () {
          // Navigator.of(context).pushNamed(FavoriteProducts.routeName);
        }, Icons.favorite),
        getManuCard('Contact Us', () {
          _launchURL();
        }, Icons.contact_mail),
        Divider(
          thickness: 1,
          color: Colors.black,
        ),
      ],
    );
  }

  ListTile getManuCard(
    String title,
    Function onTap,
    IconData icon,
  ) {
    return ListTile(
      onTap: (){},
      leading: Icon(
        icon,
        color: Colors.black,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: Colors.grey,
      ),
    );
  }
}
