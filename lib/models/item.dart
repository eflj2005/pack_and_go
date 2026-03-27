class Item {
  var _id;
  var _name;
  var _quantity;
  var _unit;
  var _priority;
  var _description;
  var _image;
  var isCompleted;

  Item(
    this._id,
    this._name,
    this._quantity,
    this._unit,
    this._priority,
    this._description,
    this._image,
    this.isCompleted,
  );

  get id => _id;
  get name => _name;
  get quantity => _quantity;
  get unit => _unit;
  get priority => _priority;
  get description => _description;
  get image => _image;
  get isCompleted => isCompleted;

  set id(value) => _id = value;
  set name(value) => _name = value;
  set quantity(value) => _quantity = value;
  set unit(value) => _unit = value;
  set priority(value) => _priority = value;
  set description(value) => _description = value;
  set image(value) => _image = value;
  set isCompleted(value) => isCompleted = value;

  Item.fromJson(Map<String, dynamic> json)
    : _id = json['id'],
      _name = json['name'],
      _quantity = json['quantity'],
      _unit = json['unit'],
      _priority = json['priority'],
      _description = json['description'],
      _image = json['image'],
      isCompleted = json['isCompleted'];

  Map<String, dynamic> toJson() => {
    'id': _id,
    'name': _name,
    'quantity': _quantity,
    'unit': _unit,
    'priority': _priority,
    'description': _description,
    'image': _image,
    'isCompleted': isCompleted,
  };
}
