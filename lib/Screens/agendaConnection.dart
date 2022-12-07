import 'package:flutter/material.dart';
import 'package:tienda_rosita/Screens/Agenda.dart';
import 'package:tienda_rosita/Screens/viewUser.dart';

class AgendaConnection extends StatefulWidget {
  @override
  _AgendaConnectionState createState() => _AgendaConnectionState();
}

class _AgendaConnectionState extends State<AgendaConnection> {
  Widget i = ViewUser(index: 0, key: ValueKey(0),fil:"");
  changeData(value) {
    this.setState(() {
      i = value;
      print(i);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 9,
          child: Agenda(
            changeData: changeData,
          ),
        ),
        Expanded(
          flex: 9,
          child: i,
        )
      ],
    );
  }
}
