class ModelClass {
  late String uid;
  late String image;
  late String name;
  late String phone;
  late String country;

  ModelClass(
      {required this.uid,
      required this.image,
      required this.name,
      required this.phone,
      required this.country});

  ModelClass.fromMap(Map<String, dynamic> data) {
    uid = data['uId'];
    image = data['Image'];
    name = data['Name'];
    phone = data['Phone'];
    country = data['Country'];
  }

  Map<String, dynamic> toMap() {
    return {
      "uId": uid,
      "Image": image,
      "Name": name,
      "Phone": phone,
      "Country": country
    };
  }
}
