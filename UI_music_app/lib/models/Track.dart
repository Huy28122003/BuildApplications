class Track {
  String _name;
  String _preview_url;
  String _image;

  Track(this._name, this._preview_url, this._image);

  String get image => _image;

  set image(String value) {
    _image = value;
  }

  String get preview_url => _preview_url;

  set preview_url(String value) {
    _preview_url = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }
}