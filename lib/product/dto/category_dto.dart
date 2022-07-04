class CategoryDto {
  final int id;
  final String name;
  final String image;

  CategoryDto({
    required this.id,
    required this.name,
    required this.image,
  });

  CategoryDto.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        image = json['image'];
}
