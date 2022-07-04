import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../exception/generic_exception.dart';
import '../helpers/shared_preferences_helper.dart';
import '../networking/urls.dart' as urls;
import '../networking/fetch.dart' as http;
import '../theme/dialog.dart';
import '../theme/primary_button.dart';


class EditUserDetails extends StatefulWidget {
  final String mobileNumber;
  final String firstName;
  final String lastName;
  final String email;

  EditUserDetails(this.mobileNumber, this.email, this.firstName, this.lastName);

  @override
  _EditUserDetailsState createState() => _EditUserDetailsState();
}

class _EditUserDetailsState extends State<EditUserDetails> {
  final _form = GlobalKey<FormState>();
  final _firstNameFocusNode = FocusNode();
  final _lastNameFocusNode = FocusNode();

  late int _mobileNumber;
  late String _email;
  late String _firstName;
  late String _lastName;

  @override
  void initState() {
    super.initState();
    setState(() {
      _mobileNumber = int.parse(widget.mobileNumber);
      _email = widget.email;
      _firstName = widget.firstName;
      _lastName = widget.lastName;
    });
  }

  void _validateAndUpdate(BuildContext ctx) {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _updateUserDetails(ctx);
  }

  void _updateUserDetails(BuildContext ctx) {
    _form.currentState!.save();
    showLoader(ctx, title: 'Updating details..');

    http
        .put(
          urls.signup + _mobileNumber.toString() + '/',
          {},
          {"email": _email, "firstName": _firstName, "lastName": _lastName},
        )
        .then((response) {
          var loginResponse = response['responseData'];
          _storeUserDetails(loginResponse);
          hideLoader(ctx);
          Navigator.of(context).pop();
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
    displaySnackBarMessage(ctx, 'Something went wrong');
  }

  void _storeUserDetails(loginResponse) {
    SharedPreferencesHelper.setValues({
      SharedPreferencesHelper.mobile: loginResponse['user']['mobile'],
      SharedPreferencesHelper.email: loginResponse['user']['email'],
      SharedPreferencesHelper.firstName: loginResponse['user']['firstName'],
      SharedPreferencesHelper.lastName: loginResponse['user']['lastName'],
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(),
        iconTheme: new IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Theme.of(context).accentColor,
        title: Text(
          'Edit Details',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      body: Builder(
        builder: (ctx) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'EDIT DETAILS',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Form(
                      key: _form,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            initialValue: _mobileNumber.toString(),
                            enabled: false,
                            decoration: const InputDecoration(
                              border: const OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                             labelText: "mobile Number",
                              alignLabelWithHint: true,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            initialValue: _email,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              labelText: 'Email id',
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
                              _email = value!;
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            focusNode: _firstNameFocusNode,
                            initialValue: _firstName,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              labelText: 'First name',
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
                              _firstName = value!;
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            focusNode: _lastNameFocusNode,
                            initialValue: _lastName,
                            decoration: const InputDecoration(
                              border: const OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              labelText: 'Last name',
                              alignLabelWithHint: true,
                              errorStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onFieldSubmitted: (_) => _validateAndUpdate(ctx),
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.done,
                            validator: (value) => validateStringInput(
                              value,
                              'Enter a valid last name',
                            ),
                            onSaved: (value) {
                              _lastName = value!;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  width: double.infinity,
                  child: ButtonTheme(
                    height: 50,
                    child: PrimaryButton(
                      title: 'UPDATE',
                      onPressed: () => _validateAndUpdate(ctx),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? validateStringInput(value, error) {
    if (value.isEmpty) {
      return error;
    }

  }
}
