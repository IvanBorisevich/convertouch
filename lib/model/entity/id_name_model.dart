abstract class IdNameModel {
  IdNameModel(this._id, this._name);

  final int _id;
  final String _name;

  int get id {
    return _id;
  }

  String get name {
    return _name;
  }
}