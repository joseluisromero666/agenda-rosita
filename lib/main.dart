import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tienda_rosita/Controller/auth.dart';
import 'package:tienda_rosita/Screens/SignIn.dart';
import 'package:tienda_rosita/Screens/adminHome.dart';
import 'package:tienda_rosita/Screens/customerHome.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(
          initialData: null,
          create: (context) =>
              context.read<AuthenticationService>().authStateChanges,
        ),
      ],
      child: MaterialApp(
        title: 'Tienda Rosita',
        home: FutureBuilder(
            future: _initialization,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print('You have an error! ${snapshot.error.toString()}');
                return Text('Something went wrong!');
              } else if (snapshot.hasData) {
                return AuthenticationWrapper();
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  AuthenticationWrapper({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseuser = context.watch<User>();
    if (firebaseuser != null) {
      return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseuser.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            final user = snapshot.data.data();
            context.read<AuthenticationService>().addLoginAudit(
                user['name'], user['email'], user['phone'], user['role']);
            if (user['role'] == 'Administrador') {
              return AdminHome();
            } else {
              return CustomerHome();
            }
          }
          return Material(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      );
    }
    return SingIn();
  }
}
