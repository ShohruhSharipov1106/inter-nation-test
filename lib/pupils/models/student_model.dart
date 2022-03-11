class Students {
  Students({
    this.id,
    this.name,
  });

  int? id;
  String? name;

  factory Students.fromJson(Map<String, dynamic> json) => Students(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
