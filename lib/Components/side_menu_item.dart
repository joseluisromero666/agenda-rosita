import 'package:flutter/material.dart';

class SideMenuItem extends StatelessWidget {
  const SideMenuItem({
    Key key,
    this.showBorder = true,
    @required this.icon,
    @required this.title,
    @required this.press,
  }) : super(key: key);

  final bool showBorder;
  final icon;
  final String title;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 30),
      child: InkWell(
        onTap: press,
        child: Row(
          children: [
            SizedBox(
              width: 15,
            ),
            SizedBox(
              width: 20 / 4,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(bottom: 15, right: 5),
                decoration: showBorder
                    ? BoxDecoration(
                        border: Border(
                        bottom: BorderSide(color: Color(0xFF000000)),
                      ))
                    : null,
                child: Row(
                  children: [
                    Icon(icon),
                    SizedBox(
                      width: 20 * 0.75,
                    ),
                    Text(
                      title,
                      style: Theme.of(context)
                          .textTheme
                          .button
                          .copyWith(color: Color(0xFF000000)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
