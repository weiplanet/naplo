import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/dummy.dart';
import 'package:filcnaplo/data/models/lesson.dart';
import 'package:filcnaplo/ui/pages/planner/timetable/day.dart';
import 'package:filcnaplo/ui/pages/planner/timetable/tile.dart';
import 'package:filcnaplo/ui/pages/planner/timetable/week.dart';

class TimetableBuilder {
  Week week = Week([]);

  void build(i) {
    List<Day> days = [];
    List<Lesson> lessons;
    if (!app.debugUser) {
      week = getWeek(i);
      lessons = app.user.sync.timetable.data;
    } else {
      week = Dummy.week;
      lessons = Dummy.lessons;
    }

    lessons.sort((a, b) => a.start.compareTo(b.start));

    lessons.forEach((lesson) {
      if (!days.any(
          (d) => d.lessons.any((l) => l.date.weekday == lesson.date.weekday))) {
        days.add(Day(date: lesson.date, lessons: [], tiles: []));
      }

      if (!days.last.lessons.map((l) => l.id).contains(lesson.id))
        days.last.lessons.add(lesson);
      if (lesson.subject != null) days.last.tiles.add(LessonTile(lesson));
    });

    days.sort((a, b) => a.date.compareTo(b.date));

    week.days = days;
  }

  Week getWeek(int weekOfYear) {
    // Returns the current week of the school year
    final now = DateTime.now();
    DateTime schoolStart;
    Week currentWeek = Week([]);

    if (DateTime.utc(now.year, DateTime.september).isAfter(now))
      schoolStart = DateTime.utc(now.year - 1, DateTime.september, 1);
    else
      schoolStart = DateTime.utc(now.year, DateTime.september, 1);

    if (schoolStart.weekday >= 6)
      schoolStart = schoolStart.add(Duration(days: 8 - schoolStart.weekday));

    currentWeek.start = schoolStart
        .add(Duration(days: 7 * weekOfYear - (schoolStart.weekday - 1)));
    if (currentWeek.start.isBefore(DateTime.utc(now.year, DateTime.september, 1))) {
      currentWeek.start = DateTime.utc(now.year, DateTime.september, 1);
    }

    currentWeek.end = schoolStart
        .add(Duration(days: 7 * weekOfYear + (7 - schoolStart.weekday)));
    if (DateTime.utc(now.year, DateTime.september).isAfter(now)) {
      if (currentWeek.end.isAfter(DateTime.utc(now.year, DateTime.august, 31))) {
        currentWeek.start = DateTime.utc(now.year, 9, 1);
      }
    }

    return currentWeek;
  }

  int getCurrentWeek() {
    final now = DateTime.now();
    DateTime schoolStart;

    if (DateTime.utc(now.year, DateTime.september).isAfter(now))
      schoolStart = DateTime.utc(now.year - 1, DateTime.september, 1);
    else
      schoolStart = DateTime.utc(now.year, DateTime.september, 1);

    if (schoolStart.weekday >= 6)
      schoolStart = schoolStart.add(Duration(days: 8 - schoolStart.weekday));

    return ((now.difference(schoolStart).inDays - (now.weekday - 1)) / 7)
            .floor() + 1 + (now.weekday >= 6 ? 1 : 0);
  }
}