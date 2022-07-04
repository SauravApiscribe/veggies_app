import 'package:flutter/material.dart';

import '../theme/primary_button.dart';


class ApplyCoupon extends StatefulWidget {

  final Function applyCouponCode;
  final Function clearCouponCode;
  final BuildContext ctx;

  ApplyCoupon(this.applyCouponCode, this.clearCouponCode, this.ctx);

  @override
  _ApplyCouponState createState() => _ApplyCouponState();
}

class _ApplyCouponState extends State<ApplyCoupon> {
  final _form = GlobalKey<FormState>();
  final _couponCodeController = TextEditingController();

  void _applyCode(ctx) {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }

    widget.applyCouponCode(_couponCodeController.text, widget.ctx);
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (ctx) => Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Coupon code',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 15,
            ),
            Form(
              key: _form,
              child: TextFormField(
                controller: _couponCodeController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  labelText: 'Coupon Code',
                  alignLabelWithHint: true,
                  errorStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onFieldSubmitted: (_) {
                  // TODO: Apply coupon code
                },
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                validator: (value) => validateStringInput(
                  value,
                  'Enter a valid coupon code',
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PrimaryButton(
                  title: 'Apply',
                  onPressed: () => _applyCode(ctx),
                ),
                PrimaryButton(
                  title: 'Clear',
                  onPressed: () {
                    _couponCodeController.clear();
                    widget.clearCouponCode();
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  String? validateStringInput(value, error) {
    if (value.isEmpty) {
      return error;
    }

    return null;
  }

}
