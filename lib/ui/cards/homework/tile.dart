import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:filcnaplo/data/context/app.dart';
import 'package:filcnaplo/data/models/homework.dart';
import 'package:filcnaplo/utils/format.dart';
import 'package:flutter/material.dart';

class HomeworkTile extends StatelessWidget {
  final Homework homework;

  HomeworkTile(this.homework);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3),
      margin: EdgeInsets.all(3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
            width: 46.0,
            height: 46.0,
            alignment: Alignment.center,
            child: Icon(FeatherIcons.home, color: app.settings.appColor)
        ),
        title: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                homework.subjectName,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(formatDate(context, homework.date)),
            ),
          ],
        ),
        subtitle: Text(
          escapeHtml(homework.content),
          softWrap: true,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
