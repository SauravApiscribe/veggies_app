import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../home_screen.dart';
import '../networking/urls.dart' as urls;
import '../networking/fetch.dart' as http;
import '../common_widget/logo.dart';
import '../exception/generic_exception.dart';
import '../helpers/shared_preferences_helper.dart';
import '../theme/dialog.dart';
import '../theme/link_button.dart';
import '../theme/primary_button.dart';
import '../util/constants.dart';
import 'login.dart';

class OtpScreen extends StatefulWidget {
  static const routeName = '/otp';

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController textEditingController = TextEditingController();
  late StreamController<ErrorAnimationType> errorController;
  bool hasError = false;
  String _otp = "";
  late String _mobileNumber;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    errorController = StreamController<ErrorAnimationType>();
  }

  @override
  void dispose() {
    super.dispose();
    errorController.close();
  }

  void _validateAndSubmitOTP(BuildContext ctx) {
    formKey.currentState!.validate();

    if (!_validateOtp()) {
      errorController.add(ErrorAnimationType.shake);
      setState(() {
        hasError = true;
      });
    } else {
      setState(() {
        hasError = false;
      });
      _submitOTP(ctx);
    }
  }

  void _submitOTP(BuildContext ctx) {
    showLoader(ctx, title: 'Logging In..');
    http
        .put(
          urls.login,
          {},
          {
            "mobile": _mobileNumber,
            "otp": int.parse(_otp),
            // "fcmId": PushNotificationsManager().fcmToken,
          },
        )
        .then((response) {
          var loginResponse = response['responseData']['login'];
          _storeUserDetails(loginResponse);
          //todo change the route home
          Navigator.of(context).pushNamedAndRemoveUntil(
              Login.routeName, (Route<dynamic> route) => false);
        })
        .catchError((e) => _handleGenericException(e, ctx),
            test: (e) => e is GenericException)
        .catchError((error) {
          hideLoader(ctx);
          displaySnackBarMessage(ctx, 'Something went wrong');
        });
  }

  void _storeUserDetails(loginResponse) async {
    SharedPreferencesHelper.setValues({
      SharedPreferencesHelper.token: loginResponse['token'],
      SharedPreferencesHelper.mobile: loginResponse['user']['mobile'],
      SharedPreferencesHelper.email: loginResponse['user']['email'],
      SharedPreferencesHelper.firstName: loginResponse['user']['firstName'],
      SharedPreferencesHelper.lastName: loginResponse['user']['lastName'],
    });
    SharedPreferencesHelper.setMembershipFlag(
        loginResponse['user']['doesHoldMembership']);
    SharedPreferencesHelper.setIsEmailVerified(
        loginResponse['user']['isEmailVerified']);
  }

  bool _validateOtp() {
    if (_otp.length != 6) {
      return false;
    }
    if (int.tryParse(_otp) == null) {
      return false;
    }
    return true;
  }

  void _handleGenericException(e, ctx) {
    hideLoader(ctx);
    if ((e as GenericException).httpResponse.statusCode == 401) {
      displaySnackBarMessage(ctx, 'Invalid OTP');
    } else {
      displaySnackBarMessage(ctx, 'Something went wrong');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _mobileNumber = ModalRoute.of(context)!.settings.arguments.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed(Login.routeName);
          },
        ),
        backgroundColor: Theme.of(context).accentColor,
        title: Text(
          appName,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      key: scaffoldKey,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Builder(
          builder: (ctx) => SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Logo((MediaQuery.of(context).size.height -
                            MediaQuery.of(context).padding.top -
                            MediaQuery.of(context).padding.bottom) *
                        0.2),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 8),
                      child: RichText(
                        text: TextSpan(
                          text: "Enter the OTP sent to ",
                          children: [
                            TextSpan(
                              text: _mobileNumber,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 15,
                          ),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Form(
                      key: formKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 30),
                        child: PinCodeTextField(
                          length: 6,
                          animationType: AnimationType.fade,
                          keyboardType: TextInputType.number,
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(5),
                            fieldHeight: 50,
                            fieldWidth: 40,
                            activeFillColor: Colors.white,
                            inactiveColor: Colors.green.shade200,
                            selectedColor: Colors.green.shade800,
                          ),
                          animationDuration: const Duration(milliseconds: 300),
                          errorAnimationController: errorController,
                          controller: textEditingController,
                          onCompleted: (v) {
                            // TODO: ask if otp needs to auto submit after 6th number
                            //_submitOtp();
                          },
                          onChanged: (value) {
                            setState(() {
                              _otp = value;
                            });
                          },
                          beforeTextPaste: (text) {
                            return false;
                          }, appContext: context,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Text(
                        hasError ? "Enter 6 digit OTP" : "",
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text(
                          'Didn\'t receive the code?',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 15,
                          ),
                        ),
                        LinkButton(
                          title: 'RESEND',
                          onPressed: () {},
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 30,
                      ),
                      child: Container(
                        width: double.infinity,
                        child: ButtonTheme(
                          height: 50,
                          child: PrimaryButton(
                            title: 'CONTINUE',
                            onPressed: ()=>Get.to(Home())
                            // onPressed: () => _validateAndSubmitOTP(ctx),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
