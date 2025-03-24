class Event {
  final String id;
  final DateTime date;
  final String fromTime;
  final String toTime;
  final String eventTitle;
  final String? eventDetails;

  Event({
    required this.id,
    required this.date,
    required this.fromTime,
    required this.toTime,
    required this.eventTitle,
    this.eventDetails,
  });

  Event copyWith({
    String? id,
    DateTime? date,
    String? fromTime,
    String? toTime,
    String? eventTitle,
    String? eventDetails,
  }) {
    return Event(
      id: id ?? this.id,
      date: date ?? this.date,
      fromTime: fromTime ?? this.fromTime,
      toTime: toTime ?? this.toTime,
      eventTitle: eventTitle ?? this.eventTitle,
      eventDetails: eventDetails ?? this.eventDetails,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'fromTime': fromTime,
        'toTime': toTime,
        'eventTitle': eventTitle,
        'eventDetails': eventDetails,
      };

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        id: json['id'],
        date: DateTime.parse(json['date']),
        fromTime: json['fromTime'],
        toTime: json['toTime'],
        eventTitle: json['eventTitle'],
        eventDetails: json['eventDetails'],
      );

  @override
  String toString() =>
      'Event(id: $id, date: $date, fromTime: $fromTime, toTime: $toTime, eventTitle: $eventTitle, eventDetails: $eventDetails)';
}
