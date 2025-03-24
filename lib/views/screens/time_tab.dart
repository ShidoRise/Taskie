import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_and_task_management/models/event.dart';
import 'package:time_and_task_management/utils/colors.dart';
import 'package:time_and_task_management/view_models/events_viewmodel.dart';
import 'package:time_and_task_management/views/widgets/add_event_sheet.dart';
import 'package:time_and_task_management/views/widgets/app_bar.dart';
import 'package:time_and_task_management/views/widgets/drawer.dart';

class TimeTab extends StatelessWidget {
  const TimeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EventViewModel>(builder: (context, viewModel, child) {
      return Scaffold(
        appBar: const SAppBar(title: 'Time', isBreakMode: false),
        body: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              _miniCalendar(context, viewModel),
              Expanded(
                child: ListView.builder(
                  itemCount: 24,
                  itemBuilder: (context, index) {
                    final hour = index;
                    final period = hour < 12 ? 'AM' : 'PM';
                    final displayHour = hour == 0
                        ? '00'
                        : (hour > 12
                            ? (hour - 12).toString().padLeft(2, '0')
                            : hour.toString().padLeft(2, '0'));
                    final time = '$displayHour:00 $period';

                    final eventsForHour = viewModel.getEventsForHour(hour);

                    return _buildTimeBlock(
                        time, eventsForHour, context, viewModel);
                  },
                ),
              ),
            ],
          ),
        ),
        drawer: const SDrawer(),
      );
    });
  }

  Widget _miniCalendar(BuildContext context, EventViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 15),
      child: EasyInfiniteDateTimeLine(
        selectionMode: const SelectionMode.autoCenter(),
        firstDate: DateTime(2024),
        focusDate: viewModel.focusDate,
        lastDate: DateTime(2025, 12, 31),
        onDateChange: (selectedDate) {
          viewModel.updateFocusDate(selectedDate);
        },
        dayProps: const EasyDayProps(width: 64, height: 64),
        itemBuilder: (context, date, isSelected, onTap) {
          return _buildCalendarItem(
              context, viewModel, date, isSelected, onTap);
        },
      ),
    );
  }

  Widget _buildCalendarItem(
    BuildContext context,
    EventViewModel viewModel,
    DateTime date,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.0),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          _calendarItem(date, isSelected),
          if (!viewModel.checkEventsEmpty(date))
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Icon(
                Icons.circle,
                size: 8,
                color: isSelected ? Colors.white : SColors.accent,
              ),
            ),
        ],
      ),
    );
  }

  Widget _calendarItem(DateTime date, bool isSelected) {
    return Container(
      width: 164.0,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: SColors.grey,
        ),
        color: isSelected ? SColors.accent : null,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            date.day.toString(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : const Color(0xff393646),
            ),
          ),
          const SizedBox(width: 8.0),
          Text(
            EasyDateFormatter.shortDayName(date, "en_US").toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? Colors.white : SColors.darkGrey,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddEventSheet(
      BuildContext context, EventViewModel viewModel, String time) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: AddEventSheet(
          initialTime: time,
          viewModel: viewModel,
          onEventAdd: viewModel.addEvent,
        ),
      ),
    );
  }

  Widget _buildTimeBlock(String time, List<Event> events, BuildContext context,
      EventViewModel viewModel) {
    return InkWell(
      onTap: () => _showAddEventSheet(context, viewModel, time),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey, width: 0.5),
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 70,
              child: Text(
                time,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: events.isEmpty
                  ? Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text('Tap to add event'),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: events.map((event) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: SColors.primaryFirst.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                event.eventTitle,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${event.fromTime} - ${event.toTime}',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                              if (event.eventDetails != null)
                                Text(
                                  event.eventDetails!,
                                  style: const TextStyle(fontSize: 12),
                                ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
