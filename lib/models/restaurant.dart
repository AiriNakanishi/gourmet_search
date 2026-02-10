class Restaurant {
  final String id;
  final String name;
  final String address;
  final String open;
  final String access;
  final String logoImage;
  final String photoImage;

  Restaurant({
    required this.id,
    required this.name,
    required this.address,
    required this.open,
    required this.access,
    required this.logoImage,
    required this.photoImage,
  });

  // JSONからクラスに変換するファクトリメソッド
  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      open: json['open'],
      access: json['access'],
      logoImage: json['logo_image'],
      photoImage: json['photo']['pc']['l'], // 大きい画像を取得
    );
  }
}
