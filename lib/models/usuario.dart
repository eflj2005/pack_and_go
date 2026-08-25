class Usuario {
  var _uid;
  var _name;
  var _email;
  var _phone;
  var _gender;
  var _birthday;
  var _image;

  Usuario(
    this._uid,
    this._name,
    this._email,
    this._phone,
    this._gender,
    this._birthday,
    this._image,
  );

  dynamic get uid => _uid;
  dynamic get name => _name;
  dynamic get email => _email;
  dynamic get phone => _phone;
  dynamic get gender => _gender;
  dynamic get birthday => _birthday;
  dynamic get image => _image;

  set uid(value) => _uid = value;
  set name(value) => _name = value;
  set email(value) => _email = value;
  set phone(value) => _phone = value;
  set gender(value) => _gender = value;
  set birthday(value) => _birthday = value;
  set image(value) => _image = value;

  Usuario.fromJson(Map<String, dynamic> json)
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
