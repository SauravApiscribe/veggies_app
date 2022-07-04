import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


void showLoader(BuildContext context, {required String title}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        child:  SizedBox(
          height: 80,
          child: Padding(
            padding:const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child:  Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
               const SizedBox(
                  width: 20,
                ),
             Text(title),
              ],
            ),
          ),
        ),
      );
    },
  );
}

void hideLoader(BuildContext context) {
  Navigator.pop(context);
}

void displayAlertMessage(BuildContext context, String message) {
  displayMessageWithAction(context, message, () {});
}

void displayMessageWithAction(
    BuildContext context, String message, VoidCallback action) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Text(
            message,
            style:const TextStyle(fontSize: 15),
          ),
          actions: [
            ElevatedButton(
              child:const Text("OK"),
              onPressed: () {
                //Navigator.of(context).pop();
                action();
              },
            )
          ],
        );
      });
}

void displayConfirmationMessage(
    BuildContext context, String message, VoidCallback confirmCallback) {
  showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Text(
            message,
            style:const  TextStyle(fontSize: 15),
          ),
          actions: [
            ElevatedButton(
              child:const  Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();
                confirmCallback();
              },
            )
          ],
        );
      });
}

void displayPopup(
    BuildContext context, Widget widget, String title, String buttonText) {
  showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          content: widget,
          actions: [
            ElevatedButton(
              child: Text(buttonText),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      });
}

void displaySnackBarMessage(BuildContext context, String message,
    {Color color = Colors.red}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        maxLines: 3,
        style: TextStyle(
          color: Theme.of(context).colorScheme.secondary,
        ),
        textAlign: TextAlign.center,
      ),
      backgroundColor: color,
    ),
  );
}

void displayToastMessage(String message, {Color color = Colors.green}) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: color,
      textColor: Colors.white,
      fontSize: 16.0);
}

void showPaymentPopupMessage(BuildContext ctx, bool isPaymentSuccess, String message) {
  showDialog<void>(
    context: ctx,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isPaymentSuccess ? const Icon(
              Icons.done,
              color: Colors.green,
            ) : const Icon(
              Icons.clear,
              color: Colors.red,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              isPaymentSuccess ? 'Payment Successful' : 'Payment Failed',
              style:const  TextStyle(
                fontSize: 20,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              const Divider(
                color: Colors.grey,
              ),
              const  SizedBox(
                height: 5,
              ),
              Text(message),
              const  SizedBox(
                height: 5,
              ),
              const Text('Thank you for shopping with us!'),
            ],
          ),
        ),
      );
    },
  );
}
