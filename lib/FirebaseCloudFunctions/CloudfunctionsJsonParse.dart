class Cloudfunctionsjsonparse {
  final String Time;
  final String ImageLink;

  Cloudfunctionsjsonparse(this.Time, this.ImageLink);

  Cloudfunctionsjsonparse.fromJson(Map<String, dynamic> json)
    : Time = json['time'],
      ImageLink = json['Image'];

  Map<String, dynamic> toJson() =>
      {
        'time' : Time,
        'Image' : ImageLink,
      };
}