import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tienda_rosita/Controller/user.dart';

class Reports extends StatefulWidget {
  @override
  _ReportsState createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: NetworkImage(
                      "https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1950&q=80"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.bottomRight,
                    colors: [
                      Colors.black.withOpacity(.6),
                      Colors.black.withOpacity(.3),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Reportes",
                      style: GoogleFonts.dancingScript(
                          color: Colors.white,
                          fontSize: 35,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(children: [
                  Text(
                    'Reporte Usuarios',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      FeatherIcons.download,
                      color: Color(0xFFD46382),
                    ),
                    hoverColor: Colors.transparent,
                    onPressed: () async {
                      await UserServices().downloadLink();
                    },
                  )
                ]),
                Column(children: [
                  Text(
                    'Reporte Auditoria',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      FeatherIcons.download,
                      color: Color(0xFFD46382),
                    ),
                    hoverColor: Colors.transparent,
                    onPressed: () async {
                      await UserServices().downloadLinkAuditoria();
                    },
                  )
                ])
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(children: [
                  Text(
                    'Reporte Inicio de Sesión',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      FeatherIcons.download,
                      color: Color(0xFFD46382),
                    ),
                    hoverColor: Colors.transparent,
                    onPressed: () async {
                      await UserServices().downloadLinkLogin();
                    },
                  )
                ]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
