import 'dart:convert';

class PlaceMarkSuggestion {
  String? placeName;
  double? lat;
  double? long;
  String? state;
  String? locality;
  String? country;
  String? distance;

  PlaceMarkSuggestion(
      {this.placeName,
      this.lat,
      this.long,
      this.state,
      this.locality,
      this.country,
      this.distance});

  PlaceMarkSuggestion.fromJson(Map<String, dynamic> json) {
    placeName = json['place_name'];
    lat = json['lat'];
    long = json['long'];
    state = json['state'];
    locality = json['locality'];
    country = json['country'];
    distance = json['distance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['place_name'] = placeName;
    data['lat'] = lat;
    data['long'] = long;
    data['state'] = state;
    data['locality'] = locality;
    data['country'] = country;
    data['distance'] = distance;
    return data;
  }

  static Map<String, dynamic> toMap(PlaceMarkSuggestion suggestion) => {
        'place_name': suggestion.placeName,
        'long': suggestion.long,
        'lat': suggestion.lat,
        'state': suggestion.state,
        'locality': suggestion.locality,
        'country': suggestion.country,
        'distance': suggestion.distance,
      };

  static String encodeList(List<PlaceMarkSuggestion> suggestions) => jsonEncode(
        suggestions
            .map<Map<String, dynamic>>(
                (suggestion) => PlaceMarkSuggestion.toMap(suggestion))
            .toList(),
      );

  static List<PlaceMarkSuggestion> decodeList(String suggestions) =>
      (jsonDecode(suggestions) as List<dynamic>)
          .map<PlaceMarkSuggestion>(
              (item) => PlaceMarkSuggestion.fromJson(item))
          .toList();
}
