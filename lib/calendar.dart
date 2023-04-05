import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

//ignore: must_be_immutable
class Calendar extends StatelessWidget {
  final Function getDate;
  final Function(DateTime) setDate;
  DateTime focussedDate = DateTime.now();

  Calendar({
    super.key, required this.getDate, required this.setDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.teal.shade400,
      child: ClipRRect(
        child: TableCalendar(
          startingDayOfWeek: StartingDayOfWeek.monday,
          firstDay: DateTime(2023, 3, 21),
          lastDay: DateTime.now(),
          focusedDay: getDate(),
          daysOfWeekStyle: const DaysOfWeekStyle(
            weekdayStyle: TextStyle(
              color: Colors.white,
            ),
            weekendStyle: TextStyle(
              color: Colors.white,
            ),
          ),
          calendarStyle: CalendarStyle(
            isTodayHighlighted: true,
            todayDecoration: BoxDecoration(
              color: Colors.teal.shade700,
              shape: BoxShape.circle,
            ),
            todayTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
            selectedTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
            selectedDecoration: BoxDecoration(
              color: Colors.teal.shade900,
              shape: BoxShape.circle,
            ),
            disabledTextStyle: const TextStyle(
              color: Colors.black26,
              fontSize: 20,
            ),
            outsideDaysVisible: false,
            defaultTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
            weekendTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
          ),
          /*onPageChanged: (focusedDay) {
            pickedDate = focusedDay;
          },*/
          onDaySelected: (selectedDay, focusedDay) {
            setDate(selectedDay);
            focussedDate = focusedDay;
          },
          selectedDayPredicate: (DateTime date) {
            return isSameDay(getDate(), date);
          },
        ),
      ),
    );
  }
}