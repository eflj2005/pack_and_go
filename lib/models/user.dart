class User {
  var _uid;
  var _name;
  var _email;
  var _phone;
  var _gender;
  var _birthday;
  var _image;

  User({
    this._uid,
    this._name,
    this._email,
    this._phone,
    this._gender,
    this._birthday,
    this._image,
  });

  User.fromJson(Map<String, dynamic> json)
    : _uid = json['uid'],
      _name = json['name'],
      _email = json['email'],
      _phone = json['phone'],
      _gender = json['gender'],
      _birthday = json['birthday'],
      _image = json['image'];

  Map<String, dynamic> toJson() => {
    'uid': _uid,
    'name': _name,
    'email': _email,
    'phone': _phone,
    'gender': _gender,
    'birthday': _birthday,
    'image': _image,
  };
}
