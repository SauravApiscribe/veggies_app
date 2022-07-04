
import 'package:flutter/material.dart';
import 'package:veggies_app/cart/pincode_dto.dart';


class SelectDeliverySlot extends StatefulWidget {
  final List<Slot> slots;
  final Function setSelectedSlot;

  SelectDeliverySlot(this.slots, this.setSelectedSlot);

  @override
  _SelectDeliverySlotState createState() => _SelectDeliverySlotState();
}

class _SelectDeliverySlotState extends State<SelectDeliverySlot> {
  List<Map<String, dynamic>> slots = [];
  int selectedSlot = 0;

  String getDay(int dayNumber) {
    String day = 'Monday';
    switch (dayNumber) {
      case 0:
        {
          day = 'Monday';
        }
        break;
      case 1:
        {
          day = 'Tuesday';
        }
        break;
      case 2:
        {
          day = 'Wednesday';
        }
        break;
      case 3:
        {
          day = 'Thursday';
        }
        break;
      case 4:
        {
          day = 'Friday';
        }
        break;
      case 5:
        {
          day = 'Saturday';
        }
        break;
      case 6:
        {
          day = 'Sunday';
        }
        break;
    }

    return day;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20, top: 10),
          child: Text(
            'Available slots',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
    //     Container(
    //       width: double.infinity,
    //       child:
    // /*      Chip.single(
    //         value: selectedSlot,
    //         options: ChipsChoiceOption.listFrom<int, Map<String, dynamic>>(
    //           source: widget.slots.map((e) {
    //             return {'value': e.id, 'title': '${getDay(e.day)}'};
    //           }).toList(),
    //           value: (index, item) => item['value'],
    //           label: (index, item) => item['title'],
    //         ),
    //         onChanged: (val) {
    //           setState(() => selectedSlot = val);
    //           widget.setSelectedSlot(val);
    //         },
    //         isWrapped: true,
    //       ),*/
    //     // ),
    //     /*Wrap(
    //       children: List<Widget>.generate(
    //         widget.slots.length,
    //         (int index) {
    //           return ChoiceChip(
    //             padding: EdgeInsets.all(10),
    //             label: Text(getDay(widget.slots[index].day)),
    //             selected: selectedSlot == index,
    //             onSelected: (bool selected) {
    //               widget.setSelectedSlot(widget.slots[index].id);
    //               setState(() {
    //                 selectedSlot = selected ? index : null;
    //               });
    //             },
    //           );
    //         },
    //       ).toList(),
    //     ),*/
    //     )
      ],

    );
  }
}
