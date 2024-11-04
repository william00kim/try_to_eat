class SearchInFoResListParse {
  String? address_name;
  String? category_group_code;
  String? category_group_name;
  String? category_name;
  String? distance;
  String? id;
  String? phone;
  String? place_name;
  String? place_url;
  String? road_address_name;
  String? x;
  String? y;

  SearchInFoResListParse.fromMap(Map<String, dynamic> data)
      : address_name = data["address_name"],
        category_group_code = data["category_group_code"],
        category_group_name = data["category_group_name"],
        category_name = data["category_name"],
        distance = data["distance"],
        id = data["id"],
        phone = data["phone"],
        place_name = data["place_name"],
        place_url = data["place_url"],
        road_address_name = data["road_address_name"],
        x = data["x"],
        y = data["y"];

  Map<String, dynamic> toJson() => {
    'address_name' : address_name,
    'category_group_code' : category_group_code,
    'category_group_name' : category_group_name,
    'category_name' : category_name,
    'distance' : distance,
    'id' : id,
    'phone' : phone,
    'place_name' : place_name,
    'place_url' : place_url,
    'road_adress_name' : road_address_name,
    'x' : x,
    'y' : y,
  };

}