class Item {
  var _id;
  var _name;
  var _quantity;
  var _unit;
  var _priority;
  var _description;
  var _image;
  var _isCompleted;

  Item(
    this._id,
    this._name,
    this._quantity,
    this._unit,
    this._priority,
    this._description,
    this._image,
    this._isCompleted,
  );

  dynamic get id => _id;
  dynamic get name => _name;
  dynamic get quantity => _quantity;
  dynamic get unit => _unit;
  dynamic get priority => _priority;
  dynamic get description => _description;
  dynamic get image => _image;
  dynamic get isCompleted => _isCompleted;

  set id(value) => _id = value;
  set name(value) => _name = value;
  set quantity(value) => _quantity = value;
  set unit(value) => _unit = value;
  set priority(value) => _priority = value;
  set description(value) => _description = value;
  set image(value) => _image = value;
  set isCompleted(value) => _isCompleted = value;

  Item.fromJson(Map<String, dynamic> json)
    : _id = json['id'],
      _name = json['name'],
      _quantity = json['quantity'],
      _unit = json['unit'],
      _priority = json['priority'],
      _description = json['description'],
      _image = json['image'],
      _isCompleted = json['isCompleted'];

  Map<String, dynamic> toJson() => {
    'id': _id,
    'name': _name,
    'quantity': _quantity,
    'unit': _unit,
    'priority': _priority,
    'description': _description,
    'image': _image,
    'isCompleted': _isCompleted,
  };
}
