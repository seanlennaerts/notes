import 'package:flutter/material.dart';

import 'package:flutter_slidable/flutter_slidable.dart';

class SlidableTile extends StatelessWidget {
  SlidableTile(
      {this.title, this.subtitle, this.date, this.controller, this.onTap, this.onTapDelete});

  final String title;
  final String subtitle;
  final String date;
  final controller;
  final onTap;
  final onTapDelete;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      delegate: SlidableDrawerDelegate(),
      child: Column(children: [
        ListTile(
            title: Text(this.title,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize:
                        Theme.of(context).textTheme.subhead.fontSize + 2)),
            isThreeLine: false,
            trailing: Text(this.date),
            subtitle: Text(subtitle, overflow: TextOverflow.ellipsis),
            onTap: this.onTap),
        Divider(
          height: 0.0,
          indent: 16.0,
        )
      ]),
      // actions: [
      //   IconSlideAction(
      //     caption: 'Flag',
      //     color: Colors.orange,
      //     icon: Icons.flag,
      //     onTap: (){},
      //     foregroundColor: Colors.white,
      //   )
      // ],
      secondaryActions: [
        IconSlideAction(
            caption: 'Delete',
            color: Colors.red,
            icon: Icons.delete,
            onTap: this.onTapDelete)
      ],
      controller: this.controller,
    );
  }
}
