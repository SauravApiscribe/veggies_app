import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:veggies_app/onborading/signup.dart';
import '../exception/generic_exception.dart';
import '../home_screen.dart';
import '../networking/fetch.dart' as http;
import '../networking/urls.dart' as urls;
import '../common_widget/logo.dart';
import '../theme/dialog.dart';
import '../theme/primary_button.dart';
import '../util/constants.dart';
import 'otp_screen.dart';

class Login extends StatefulWidget {
  static const routeName = '/login';

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _mobileNumberFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  late int _mobileNumber;
  final TextEditingController controller = TextEditingController();
  String initialCountry = 'IN';
  PhoneNumber number = PhoneNumber(isoCode: 'IN');

  @override
  void dispose() {
    super.dispose();
    _mobileNumberFocusNode.dispose();
  }

  void _validateAndLogin(BuildContext ctx) async {
    final isValid = _form.currentState?.validate();
    if (!isValid!) {
      return;
    }
    _form.currentState!.save();

    _login(ctx);
  }

  void _login(BuildContext ctx) {
    showLoader(ctx, title: 'Logging in..');
    http
        .post(
      urls.login,
      {},
      {"mobile": _mobileNumber.toString()},
    )
        .then((value) {
      hideLoader(ctx);
      Navigator.of(context).pushReplacementNamed(OtpScreen.routeName,
          arguments: _mobileNumber);
    })
        .catchError((e) => _handleGenericException(e, ctx),
        test: (e) => e is GenericException)
        .catchError((error) {
      hideLoader(ctx);
      displaySnackBarMessage(ctx, 'Something went wrong');
    });
  }

  void _handleGenericException(e, ctx) {
    hideLoader(ctx);
    if ((e as GenericException).httpResponse.statusCode == 404) {
      Navigator.of(context)
          .pushReplacementNamed(SignUp.routeName, arguments: _mobileNumber);
    } else{
      displaySnackBarMessage(ctx, 'Something went wrong');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Text(
         appName,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      body: Builder(
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
                    height: 15,
                  ),
                 const  Text(
                    appName,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                 const SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    child: Padding(
                      padding:const  EdgeInsets.only(top: 30,bottom: 30,left: 10,right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'LOGIN / SIGNUP',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        const  SizedBox(
                            height: 10,
                          ),
                          const Text(
                            'Enter your mobile number to proceed',
                            textAlign: TextAlign.start,
                          ),
                        const  SizedBox(height: 5,),
                          InternationalPhoneNumberInput(
                            spaceBetweenSelectorAndTextField: 2,
                            onInputChanged: (PhoneNumber number) {
                              if (kDebugMode) {
                                print(number.phoneNumber);
                              }
                            },
                            onInputValidated: (bool value) {
                              if (kDebugMode) {
                                print(value);
                              }
                            },
                            selectorConfig: const SelectorConfig(
                              selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                            ),
                            ignoreBlank: false,
                            autoValidateMode: AutovalidateMode.onUserInteraction,
                            selectorTextStyle: const TextStyle(color: Colors.black),
                            initialValue: number,
                            textFieldController: controller,
                            formatInput: false,
                            keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                            inputBorder:  OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:const BorderSide(width: 2,color: Colors.black)
                            ),

                            onSaved: (PhoneNumber number) {
                              if (kDebugMode) {
                                print('On Saved: $number');
                              }
                            },
                          ),
                       // const   SizedBox(
                       //      height: 10,
                       //    ),
                          // Form(
                          //   key: _form,
                          //   child: TextFormField(
                          //     focusNode: _mobileNumberFocusNode,
                          //     decoration: const InputDecoration(
                          //       border: OutlineInputBorder(
                          //         borderSide: BorderSide(
                          //           color: Colors.black,
                          //         ),
                          //       ),
                          //       labelText: '10 DIGIT MOBILE NUMBER',
                          //       alignLabelWithHint: true,
                          //       errorStyle: TextStyle(
                          //         fontWeight: FontWeight.bold,
                          //       ),
                          //     ),
                          //     onFieldSubmitted: (_) => _validateAndLogin(ctx),
                          //     keyboardType: TextInputType.number,
                          //     textInputAction: TextInputAction.done,
                          //     validator: (value) => validateMobileNumberInput(
                          //       value,
                          //       'Please Enter Valid Mobile Number',
                          //     ),
                          //     onSaved: (value) {
                          //       _mobileNumber = int.parse(value!);
                          //     },
                          //   ),
                          // ),
                          const SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding:const   EdgeInsets.symmetric(horizontal: 50),
                            child: Container(
                              height: 45,
                              width: MediaQuery.of(context).size.width/1.5,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20)
                              ),
                              child: ButtonTheme(

                                child: PrimaryButton(
                                  title: 'CONTINUE',
                                  onPressed: () {
                                    // Navigator.of(context).pushReplacementNamed(OtpScreen.routeName,
                                    //     arguments: 9589766386);
                                    Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>OtpScreen()));
                                  }
                                  // => _validateAndLogin(ctx),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  PrimaryButton(
                    title: 'Skip',

                    onPressed: () => Navigator.of(context).pushNamed(
                        Home.routeName),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? validateMobileNumberInput(value, error) {
    if (value.isEmpty) {
      return error;
    }
    if (value.length != 10) {
      return 'Please Enter Valid 10 digit Mobile Number';
    }
    if (int.tryParse(value) == null) {
      return 'Please Enter Valid Number';
    }

  }
}