import 'package:flutter/material.dart';
import '../cart/checkout_screen.dart';
import '../cart/pincode_dto.dart';
import '../helpers/shared_preferences_helper.dart';
import '../my_account/user_dto.dart';
import '../networking/fetch.dart' as http;
import '../networking/urls.dart' as urls;
import '../onborading/login.dart';
import '../theme/dialog.dart';
import 'basket_dto.dart';
import 'basket_product_item.dart';


class BasketDetails extends StatefulWidget {
  final BasketDto basketDto;
  final bool isOneTimeBasket;

  BasketDetails(this.basketDto, this.isOneTimeBasket);

  @override
  _BasketDetailsState createState() => _BasketDetailsState();
}

class _BasketDetailsState extends State<BasketDetails> {
  late List<DropdownMenuItem<dynamic>> _pincodes;
  late List<PincodeDto> _pincodesDetails;
  late int _selectedSlot;

  @override
  void initState() {
    super.initState();
    _fetchPincodes();
  }

  void _refreshBasketDetails() {
    _fetchPincodes();
  }

  Future<void> _fetchPincodes() async {
    List<PincodeDto> pincodesList;
    dynamic response = await http.get(urls.pincodes, {});
    pincodesList =
        (response['responseData']['pincodes'] as List<dynamic>).map((value) {
      return PincodeDto.fromJson(value);
    }).toList();

    List<DropdownMenuItem> pincodes = pincodesList.map((e) {
      return DropdownMenuItem(
        child: Text(e.pincode.toString()),
        value: e.pincode,
      );
    }).toList();

    setState(() {
      _pincodes = pincodes;
      _pincodesDetails = pincodesList;
    });
  }

  void resendVerificationEmail(BuildContext ctx) async {
    Navigator.of(context).pop();
    showLoader(ctx, title: 'Resending mail');
    UserDto userDetails = await SharedPreferencesHelper.getUserDetails();
    http.post(urls.signup, {}, {
      'resend': true,
      'mobile': userDetails.mobile,
    }).then((value) {
      hideLoader(ctx);
      displayToastMessage('Resent verification email!', color: Colors.orange);
    }).catchError((error) {
      hideLoader(ctx);
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).accentColor,
        iconTheme: new IconThemeData(color: Theme.of(context).primaryColor),
        leading: BackButton(),
        title: Text(
          '${widget.basketDto.name}',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...widget.basketDto.description.map((e) {
                        return Padding(
                          padding: EdgeInsets.all(5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '\u2022  ',
                              ),
                              Flexible(child: Text(e)),
                            ],
                          ),
                        );
                      }).toList(),
                      SizedBox(
                        height: 10,
                      ),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: widget.basketDto.products.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          childAspectRatio: 0.65,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                        ),
                        itemBuilder: (context, index) {
                          return BasketProductItem(
                              widget.basketDto.products[index]);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            FutureBuilder<UserDto>(
              future: SharedPreferencesHelper.getUserDetails(),
              builder: (BuildContext ctx, AsyncSnapshot<UserDto> snapshot) {
                if (!snapshot.hasData) {
                  return SizedBox();
                }
                if (snapshot.data!.doesHoldMembership && !widget.isOneTimeBasket) {
                  return Container(
                    width: double.infinity,
                    color: Theme.of(context).primaryColor,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'You have already purchased a basket membership!',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                }
                return Container(
                  width: double.infinity,
                  color: Theme.of(context).primaryColor,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          child: Text(
                            'Checkout',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          onPressed: () async {
                            UserDto userDetails = await SharedPreferencesHelper.getUserDetails();
                            if(userDetails.token.isEmpty){
                              Navigator.of(context).pushNamedAndRemoveUntil(Login.routeName, (Route<dynamic> route) => false);
                            } else {
                              var response = await http.get(urls.signup, {});
                              SharedPreferencesHelper.setMembershipFlag(
                                  response['responseData']['user']['doesHoldMembership']);
                              SharedPreferencesHelper.setIsEmailVerified(
                                  response['responseData']['user']['isEmailVerified']);
                              userDetails = await SharedPreferencesHelper.getUserDetails();
                              if(!userDetails.isEmailVerified) {
                                displayMessageWithAction(context, 'It seems like you have not verified email yet.\n\nResend verification mail?', () => resendVerificationEmail(ctx));
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CheckoutScreen(
                                      cartAmount: (widget.basketDto.price),
                                      isBasket: true,
                                      basketId: widget.basketDto.id,
                                      slot: _selectedSlot,
                                      refreshBasketDetails: _refreshBasketDetails,
                                      isOnetimeBasket: widget.basketDto.isOneTimeDelivery,
                                    ),
                                  ),
                                );
                              }
                            }
                          },

                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
