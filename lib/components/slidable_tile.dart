import 'package:flutter/material.dart';

import 'package:flutter_slidable/flutter_slidable.dart';

class SlidableTile extends StatelessWidget {
  SlidableTile({this.title, this.subtitle, this.controller});

  final String title;
  final String subtitle;
  final controller;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      delegate: SlidableDrawerDelegate(),
      child: ListTile(
        title: Text(
          this.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: Theme.of(context).textTheme.subhead.fontSize + 2
          )
        ),
        isThreeLine: true,
        trailing: Text('10/9/12'),
        subtitle: Text(subtitle),
        onTap: (){print(this.title);}
      ),
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
          onTap: (){print('delete');}
        )
      ],
      controller: this.controller,
    );
  }
}