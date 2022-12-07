class UserModel {
  String name,
      urlImg,
      document,
      email,
      phone,
      city,
      address,
      dob,
      role,
      lowerName;
  bool isActive;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'lowerName': lowerName,
      'urlImg': urlImg,
      'document': document,
      'email': email,
      'phone': phone,
      'city': city,
      'role': role,
      'dob': dob,
      'address': address,
      'isActive': true,
    };
  }

  UserModel(
      {this.name,
      this.lowerName,
      this.urlImg,
      this.document,
      this.email,
      this.phone,
      this.city,
      this.dob,
      this.address,
      this.role,
      this.isActive});
}
