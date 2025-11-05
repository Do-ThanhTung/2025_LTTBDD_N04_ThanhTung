class Course {
  final String name;
  final double completedPercentage;
  final String author;
  final String thumbnail;

  const Course({
    required this.author,
    required this.completedPercentage,
    required this.name,
    required this.thumbnail,
  })  : assert(name != ''),
        assert(author != ''),
        assert(thumbnail != ''),
        assert(
          completedPercentage >= 0.0 &&
              completedPercentage <= 1.0,
          'completedPercentage must be between 0.0 and 1.0',
        );

  factory Course.fromJson(Map<String, dynamic> json) =>
      Course(
        name: (json['name'] as String?) ?? '',
        author: (json['author'] as String?) ?? '',
        completedPercentage:
            ((json['completedPercentage'] as num?)
                    ?.toDouble()) ??
                0.0,
        thumbnail:
            (json['thumbnail'] as String?) ?? '',
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'author': author,
        'completedPercentage': completedPercentage,
        'thumbnail': thumbnail,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Course &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          author == other.author &&
          thumbnail == other.thumbnail &&
          completedPercentage ==
              other.completedPercentage;

  @override
  int get hashCode =>
      name.hashCode ^
      author.hashCode ^
      thumbnail.hashCode ^
      completedPercentage.hashCode;
}

const List<Course> courses = [
  Course(
    author: "DevWheels",
    completedPercentage: 0.75,
    name: "Flutter Novice to Ninja",
    thumbnail: "assets/icons/flutter.jpg",
  ),
  Course(
    author: "DevWheels",
    completedPercentage: 0.60,
    name: "React Novice to Ninja",
    thumbnail: "assets/icons/react.jpg",
  ),
  Course(
    author: "DevWheels",
    completedPercentage: 0.75,
    name: "Node - The complete guide",
    thumbnail: "assets/icons/node.png",
  ),
];
