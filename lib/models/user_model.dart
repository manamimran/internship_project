class UserModel {
  late String uid;
  late String image;
  late String name;
  late String phone;
  late String country;
  List<String> sendRequests = [];
  List<String> getRequests = [];
  List<String> friends = [];

  UserModel({
    required this.uid,
    required this.image,
    required this.name,
    required this.phone,
    required this.country,
    required this.sendRequests,
    required this.getRequests,
    required this.friends,

  });

  UserModel.fromMap(Map<String, dynamic> data) {
    uid = data['uId'];
    image = data['Image'];
    name = data['Name'];
    phone = data['Phone'];
    country = data['Country'];
    sendRequests = List<String>.from(data['SendRequest'] ?? []);
    getRequests = List<String>.from(data['GetRequest'] ?? []);
    friends = List<String>.from(data['Friends'] ?? []);
  }

  Map<String, dynamic> toMap() {
    return {
      "uId": uid,
      "Image": image,
      "Name": name,
      "Phone": phone,
      "Country": country,
      'SendRequest': sendRequests,
      'GetRequest': getRequests,
      'Friends': friends,
    };
  }
}
