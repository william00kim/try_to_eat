class Searchdbdatamodel {
  int? id;
  String name;
  String category;
  String address_name;
  String road_address_name;
  String phone;
  String place_url;
  String x;
  String y;

  Searchdbdatamodel({
    this.id,
    required this.name,
    required this.category,
    required this.address_name,
    required this.road_address_name,
    required this.phone,
    required this.place_url,
    required this.x,
    required this.y
  });

  Map<String, dynamic> toMap() {
    return {
      "id" : id,
      "name" : name,
      "category" : category,
      "address_name" : address_name,
      "road_address_name" : road_address_name,
      "phone" : phone,
      "place_url" : place_url,
      "x" : x,
      "y" : y,
    };
  }

}