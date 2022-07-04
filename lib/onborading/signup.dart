import 'dart:convert';
import 'package:flutter/material.dart';
import '../exception/generic_exception.dart';
import '../networking/fetch.dart' as http;
import '../networking/urls.dart' as urls;
import '../theme/dialog.dart';
import '../theme/link_button.dart';
import '../theme/primary_button.dart';
import '../util/constants.dart';
import 'login.dart';

class SignUp extends StatefulWidget {
  static const routeName = '/signup';

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _form = GlobalKey<FormState>();
  final _emailFocusNode = FocusNode();
  final _firstNameFocusNode = FocusNode();
  final _lastNameFocusNode = FocusNode();

  dynamic ?_mobileNumber;
  String? _email;
  String? _firstName;
  String? _lastName;
  bool? _isChecked = false;

  void _validateAndSignup(BuildContext ctx) {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    if (!_isChecked!) {
      displaySnackBarMessage(ctx, 'Please accept terms and conditions');
      return;
    }
    _signup(ctx);
  }

  void _signup(BuildContext ctx) {
    _form.currentState!.save();
    showLoader(ctx, title: 'Signing up..');

    http
        .post(
          urls.signup,
          {},
          {
            "mobile": _mobileNumber.toString(),
            "email": _email,
            "firstName": _firstName,
            "lastName": _lastName
          },
        )
        .then((value) {
          Navigator.of(context).pushReplacementNamed(Login.routeName);
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
      displaySnackBarMessage(ctx,
          jsonDecode((e).httpResponse.body)['message']);
    } else {
      displaySnackBarMessage(ctx, 'Something went wrong');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _mobileNumber = ModalRoute.of(context)!.settings.arguments;
  }

  @override
  void dispose() {
    super.dispose();
    _emailFocusNode.dispose();
    _firstNameFocusNode.dispose();
    _lastNameFocusNode.dispose();
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
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'SIGNUP',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Create a new account with the phone number',
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Form(
                    key: _form,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                            ),
                            labelText: '10 DIGIT MOBILE NUMBER',
                            alignLabelWithHint: true,
                            errorStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_emailFocusNode);
                          },
                          initialValue: _mobileNumber.toString(),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          validator: (value) => validateMobileNumberInput(
                            value,
                            'Please Enter Valid Mobile Number',
                          ),
                          onSaved: (value) {
                            _mobileNumber = int.parse(value!);
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          focusNode: _emailFocusNode,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                            ),
                            labelText: 'Enter your email id',
                            alignLabelWithHint: true,
                            errorStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_firstNameFocusNode);
                          },
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validator: (value) => validateStringInput(
                            value,
                            'Enter a valid email id',
                          ),
                          onSaved: (value) {
                            _email = value;
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          focusNode: _firstNameFocusNode,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                            ),
                            labelText: 'Enter your first name',
                            alignLabelWithHint: true,
                            errorStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_lastNameFocusNode);
                          },
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          validator: (value) => validateStringInput(
                            value,
                            'Enter a valid first name',
                          ),
                          onSaved: (value) {
                            _firstName = value;
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          focusNode: _lastNameFocusNode,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                            ),
                            labelText: 'Enter your last name',
                            alignLabelWithHint: true,
                            errorStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onFieldSubmitted: (_) => _validateAndSignup(ctx),
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.done,
                          validator: (value) => validateStringInput(
                            value,
                            'Enter a valid last name',
                          ),
                          onSaved: (value) {
                            _lastName = value;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: _isChecked,
                              checkColor: Theme.of(context).colorScheme.secondary,
                              activeColor: Colors.green,
                              onChanged: (val) {
                                setState(() {
                                  _isChecked = val;
                                });
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text(
                                  'By creating account, I accept ',
                                  style: TextStyle(fontSize: 12),
                                ),
                                LinkButton(
                                  title: 'Terms and Conditions',
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: double.infinity,
                          child: ButtonTheme(
                            height: 50,
                            child: PrimaryButton(
                              title: 'CONTINUE',
                              onPressed: () => _validateAndSignup(ctx),
                            ),
                          ),
                        ),
                      ],
                    ),
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

  String? validateStringInput(value, error) {
    if (value.isEmpty) {
      return error;
    }


  }
}
