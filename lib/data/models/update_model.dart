/// Model for home screen updates/news/images
class UpdateModel {
  final String picture;

  UpdateModel({required this.picture});

  factory UpdateModel.fromJson(Map<String, dynamic> json) {
    return UpdateModel(
      picture: json['picture'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'picture': picture,
    };
  }
}
