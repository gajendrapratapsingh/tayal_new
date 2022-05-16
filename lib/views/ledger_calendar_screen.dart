import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class LedgerCalendarScreen extends StatefulWidget {
  const LedgerCalendarScreen({Key key}) : super(key: key);

  @override
  _LedgerCalendarScreenState createState() => _LedgerCalendarScreenState();
}

class _LedgerCalendarScreenState extends State<LedgerCalendarScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Card(
           elevation: 8,
           child: SfCalendar(
             onSelectionChanged: (calendarSelectionDetails) {
               /*setState(() {
                 toDate = "";
                 fromDate = calendarSelectionDetails.date
                     .toString()
                     .split(" ")[0];
                 fromDateSelected = false;
               });*/
               // print(calendarSelectionDetails.date.toString());
             },
             view: CalendarView.month,
             backgroundColor: Colors.teal[50],
             todayHighlightColor: Colors.green,
             minDate: DateTime.now().add(Duration(days: 1)),
           )),
    );
  }
}
