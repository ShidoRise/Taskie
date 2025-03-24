import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/event.dart';

class EventViewModel extends ChangeNotifier {
  static const String _eventsKey = 'events';
  final List<Event> _events = [];

  EventViewModel() {
    _loadEvents();
  }

  final DateFormat _dateFormat = DateFormat('yMd');
  DateTime _focusDate = DateTime.now();

  String get focusDateFormatted => _dateFormat.format(_focusDate);
  DateTime get focusDate => _focusDate;

  void updateFocusDate(DateTime date) {
    _focusDate = date;
    notifyListeners();
  }

  List<Event> get events => _events;

  void setSelectedDate(DateTime date) {
    _focusDate = date;
    notifyListeners();
  }

  List<Event> getEventsForHour(int hour) {
    return _events.where((event) {
      final eventHour = int.parse(event.fromTime.split(':')[0]);
      return eventHour == hour && DateUtils.isSameDay(event.date, _focusDate);
    }).toList();
  }

  bool checkEventsEmpty(DateTime date) {
    return !_events.any((event) => DateUtils.isSameDay(event.date, date));
  }

  Future<void> _loadEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final eventsJson = prefs.getStringList(_eventsKey) ?? [];
    _events.clear();
    _events.addAll(
      eventsJson.map((event) => Event.fromJson(jsonDecode(event))).toList(),
    );
    notifyListeners();
  }

  Future<void> _saveEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final eventsJson =
        _events.map((event) => jsonEncode(event.toJson())).toList();
    await prefs.setStringList(_eventsKey, eventsJson);
  }

  void addEvent(Event event) {
    _events.add(event);
    _saveEvents();
    notifyListeners();
  }

  void deleteEvent(String id) {
    _events.removeWhere((event) => event.id == id);
    _saveEvents();
    notifyListeners();
  }

  void editEvent(Event updatedEvent) {
    final index = _events.indexWhere((event) => event.id == updatedEvent.id);
    if (index != -1) {
      _events[index] = updatedEvent;
      _saveEvents();
      notifyListeners();
    }
  }
}
