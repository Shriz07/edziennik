import 'dart:collection';

import 'package:table_calendar/table_calendar.dart';

class Event {
  Event(
      {required this.date,
      required this.type,
      required this.description,
      required this.subject,
      required this.classID});

  DateTime date;
  String type;
  String description;
  String subject;
  String classID;

  Map<String, dynamic> toMap() {
    return {
      'date': date.toString(),
      'subject': subject,
      'type': type,
      'description': description,
      'classID': classID,
    };
  }

  @override
  String toString() => type + ' | ' + subject + ' | ' + description;
}

final kEvents = LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
);

void addEventsToMap(List<Event> events) {
  Map<DateTime, List<Event>> kEventSource = {};
  events.forEach((event) {
    kEventSource[event.date] = kEventSource[event.date] != null
        ? [...?kEventSource[event.date], event]
        : [event];
  });
  kEvents.addAll(kEventSource);
  print(kEvents);
}

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);
