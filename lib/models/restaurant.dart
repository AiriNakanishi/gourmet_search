class Restaurant {
  final String id;
  final String name;
  final String address;
  final String open;
  final String access;
  final String logoImage;
  final String photoImage;
  final double lat;
  final double lng;
  final List<String> genres;

  Restaurant({
    required this.id,
    required this.name,
    required this.address,
    required this.open,
    required this.access,
    required this.logoImage,
    required this.photoImage,
    required this.lat,
    required this.lng,
    required this.genres,
  });

  // JSONからクラスに変換するファクトリメソッド
  factory Restaurant.fromJson(Map<String, dynamic> json) {
    List<String> extractedGenres = [];
    if (json['genre'] != null && json['genre']['name'] != null) {
      extractedGenres.add(json['genre']['name'].toString());
    }
    if (json['sub_genre'] != null && json['sub_genre']['name'] != null) {
      extractedGenres.add(json['sub_genre']['name'].toString());
    }
    if (extractedGenres.isEmpty) {
      extractedGenres.add('飲食店');
    }

    return Restaurant(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      address: (json['address'] ?? '').toString(),
      open: (json['open'] ?? '').toString(),
      access: (json['access'] ?? '').toString(),
      logoImage: (json['logo_image'] ?? '').toString(),
      photoImage: (json['photo']?['pc']?['l'] ?? '').toString(),
      lat: double.tryParse(json['lat'].toString()) ?? 0.0,
      lng: double.tryParse(json['lng'].toString()) ?? 0.0,
      genres: extractedGenres,
    );
  }
}
