import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tienda_rosita/Model/User.dart';
import 'package:url_launcher/url_launcher.dart';

class UserServices {
  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  CollectionReference auditCollection =
      FirebaseFirestore.instance.collection('audit');

  CollectionReference loginCollection =
      FirebaseFirestore.instance.collection('loginAudit');

  Future<void> addUser(UserModel user) {
    return usersCollection.add(user.toMap());
  }

  Future<void> updateUser(UserModel newUser, String email) {
    return usersCollection
        .where('email', isEqualTo: email)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.update({
          'name': newUser.name,
          'lowerName': newUser.name.toLowerCase(),
          'urlImg': newUser.urlImg,
          'email': newUser.email,
          'phone': newUser.phone,
          'city': newUser.city,
        });
      });
    }).catchError((err) => print("Failed to update employee: $err"));
  }

  Future<void> deleteUser(String email) {
    return usersCollection
        .where('email', isEqualTo: email)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.update({
          'isActive': false,
        });
      });
    }).catchError((err) => print("Failed to delete employee: $err"));
  }

  Future<void> activateUser(String email) {
    return usersCollection
        .where('email', isEqualTo: email)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.update({
          'isActive': true,
        });
      });
    }).catchError((err) => print("Failed to delete employee: $err"));
  }

  Future<void> downloadLink() async {
    List<List<String>> data = [
      ["Nombre", "Correo", "Telefono", "Rol", "Ciudad", "Estado"],
    ];
    await usersCollection.get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        data.add([
          "${doc.get('name')}",
          "${doc.get('email')}",
          "${doc.get('phone')}",
          "${doc.get('role')}",
          "${doc.get('city')}",
          (doc.get('isActive')) ? "Activo" : "Inactivo",
        ]);
      });
    });

    String csvData = ListToCsvConverter().convert(data);
    try {
      await firebase_storage.FirebaseStorage.instance
          .ref()
          .child("/Reports/reporteUsuario.csv")
          .putString(csvData, format: firebase_storage.PutStringFormat.raw)
          .then((value) => {print('hey')});
    } catch (e) {
      print(e.code);
    }

    final link = await FirebaseStorage.instance
        .ref("/Reports/reporteUsuario.csv")
        .getDownloadURL();
    if (await canLaunch(link)) {
      await launch(link);
    } else {
      throw 'Could no launch $link';
    }
  }

  // Future<List<String>> retrieveUsers() async {
  //   List<String> emails = [];
  //   await usersCollection.get().then((querySnapshot) {
  //     querySnapshot.docs.forEach((doc) {
  //       emails.add(doc.get('email'));
  //     });
  //   }).catchError((err) => {});

  //   return emails;
  // }

  Future<void> downloadLinkAuditoria() async {
    List<List<String>> data = [
      [
        'Fecha',
        'Acción',
        'Usuario Antiguo',
        'Ciudad',
        'Email',
        'Nombre',
        'Estado',
        'Teléfono',
        'Rol',
        'Usuario Nuevo',
        'Ciudad',
        'Email',
        'Nombre',
        'Estado',
        'Teléfono',
        'Rol'
      ]
    ];
    await auditCollection.get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (doc.get('kind') == 'Update')
          data.add([
            "${doc.get('date')}",
            "Actualización",
            "->",
            "${doc.get('oldUser')['city']}",
            "${doc.get('oldUser')['email']}",
            "${doc.get('oldUser')['name']}",
            (doc.get('oldUser')['isActive']) ? "Activo" : "Inactivo",
            "${doc.get('oldUser')['phone']}",
            "${doc.get('oldUser')['role']}",
            "->",
            "${doc.get('newUser')['city']}",
            "${doc.get('newUser')['email']}",
            "${doc.get('newUser')['name']}",
            (doc.get('newUser')['isActive']) ? "Activo" : "Inactivo",
            "${doc.get('newUser')['phone']}",
            "${doc.get('newUser')['role']}",
          ]);
        else
          data.add([
            "${doc.get('date')}",
            (doc.get('kind') == 'Delete') ? "Borrado" : "Restaurado",
            "->",
            "${doc.get('user')['city']}",
            "${doc.get('user')['email']}",
            "${doc.get('user')['name']}",
            (doc.get('user')['isActive']) ? "Activo" : "Inactivo",
            "${doc.get('user')['phone']}",
            "${doc.get('user')['role']}",
            "->",
            "",
            "",
            "",
            "",
            "",
            "",
          ]);
      });
    });
    String csvData = ListToCsvConverter().convert(data);
    try {
      await firebase_storage.FirebaseStorage.instance
          .ref()
          .child("/Reports/reporteAuditoria.csv")
          .putString(csvData, format: firebase_storage.PutStringFormat.raw)
          .then((value) => {print('hey')});
    } catch (e) {
      print(e.code);
    }
    final link = await FirebaseStorage.instance
        .ref("/Reports/reporteAuditoria.csv")
        .getDownloadURL();
    if (await canLaunch(link)) {
      await launch(link);
    } else {
      throw 'Could no launch $link';
    }
  }

  Future<void> downloadLinkLogin() async {
    List<List<String>> data = [
      ["Nombre", "Correo", "Rol", "Teléfono", "Fecha"]
    ];
    await loginCollection.get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        data.add([
          "${doc.get('name')}",
          "${doc.get('email')}",
          "${doc.get('role')}",
          "${doc.get('phone')}",
          "${doc.get('date')}",
        ]);
      });
    });

    String csvData = ListToCsvConverter().convert(data);
    try {
      await firebase_storage.FirebaseStorage.instance
          .ref()
          .child("/Reports/reporteInicioSesion.csv")
          .putString(csvData, format: firebase_storage.PutStringFormat.raw)
          .then((value) => {print('hey')});
    } catch (e) {
      print(e.code);
    }

    final link = await FirebaseStorage.instance
        .ref("/Reports/reporteInicioSesion.csv")
        .getDownloadURL();
    if (await canLaunch(link)) {
      await launch(link);
    } else {
      throw 'Could no launch $link';
    }
  }

  // List<String> ems;
}
