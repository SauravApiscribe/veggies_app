import 'package:flutter/material.dart';

class BillDetails extends StatelessWidget {
  final double totalCartAmount;
  final double deliveryCharges;
  final double discount;

  BillDetails(this.totalCartAmount, this.deliveryCharges, this.discount);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Bill',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Amount',
              ),
              Text('₹$totalCartAmount'),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Delivery Charges',
              ),
              Text('₹$deliveryCharges'),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Discount',
              ),
              Text('- ₹$discount'),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Divider(
            color: Colors.grey,
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Amount to Pay',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '₹${totalCartAmount + deliveryCharges - discount}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            '*These items will get delivered with your next delivery of basket',
            style: TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
