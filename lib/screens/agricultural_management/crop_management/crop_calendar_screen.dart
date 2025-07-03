import 'package:flutter/material.dart';
import '../../../providers/app_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart'; // Add this to your pubspec.yaml

class CropCalendarScreen extends ConsumerStatefulWidget {
  const CropCalendarScreen({super.key});

  @override
  ConsumerState<CropCalendarScreen> createState() => _CropCalendarScreenState();
}

class _CropCalendarScreenState extends ConsumerState<CropCalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Example events/tasks
  final Map<DateTime, List<String>> _events = {
    DateTime.utc(2025, 7, 5): ['Planting Maize'],
    DateTime.utc(2025, 7, 10): ['Fertilizer Application'],
    DateTime.utc(2025, 7, 15): ['Pest Scouting'],
    DateTime.utc(2025, 7, 20): ['Irrigation'],
  };

  List<String> _getEventsForDay(DateTime day) {
    return _events[DateTime.utc(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final customColors = ref.watch(customColorsProvider);
    final isEnglish = ref.watch(isEnglishProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEnglish ? 'Crop Calendar' : 'Kalendala ya Kulima',
          style: TextStyle(color: customColors['surface']),
        ),
        backgroundColor: customColors['primary'],
        iconTheme: IconThemeData(color: customColors['surface']),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay; // update `_focusedDay` here as well
              });
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            eventLoader: _getEventsForDay,
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: customColors['accent']!.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: customColors['primary'],
                shape: BoxShape.circle,
              ),
              markerDecoration: BoxDecoration(
                color: customColors['secondary'],
                shape: BoxShape.circle,
              ),
              outsideDaysVisible: false,
              weekendTextStyle: TextStyle(color: Colors.red[700]),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(
                color: customColors['text'],
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              leftChevronIcon: Icon(Icons.chevron_left, color: customColors['primary']),
              rightChevronIcon: Icon(Icons.chevron_right, color: customColors['primary']),
            ),
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ListView.builder(
              itemCount: _getEventsForDay(_selectedDay ?? _focusedDay).length,
              itemBuilder: (context, index) {
                final event = _getEventsForDay(_selectedDay ?? _focusedDay)[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                  child: ListTile(
                    leading: Icon(Icons.task, color: customColors['primary']),
                    title: Text(
                      event,
                      style: TextStyle(color: customColors['text']),
                    ),
                    subtitle: Text(
                      isEnglish ? 'Upcoming Task' : 'Ntchito Ikubwera',
                      style: TextStyle(color: customColors['subText']),
                    ),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(isEnglish ? 'Tapped on event: $event' : 'Makanikiza pa chochitika: $event')),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(isEnglish ? 'Add New Task tapped!' : 'Onjezani Ntchito Yatsopano kukanikizidwa!')),
                );
              },
              icon: Icon(Icons.add, color: customColors['surface']),
              label: Text(
                isEnglish ? 'Add New Task' : 'Onjezani Ntchito Yatsopano',
                style: TextStyle(color: customColors['surface']),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: customColors['secondary'],
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}