

class Students {
    Students({
        this.students,
        this.marks,
    });

    List<Student>? students;
    List<Mark>? marks;

    factory Students.fromJson(Map<String, dynamic> json) => Students(
        students: List<Student>.from(json["students"].map((x) => Student.fromJson(x))),
        marks: List<Mark>.from(json["marks"].map((x) => Mark.fromJson(x))),
    );

  
}

class Mark {
    Mark({
        this.userId,
        this.score,
    });

    int? userId;
    int? score;

    factory Mark.fromJson(Map<String, dynamic> json) => Mark(
        userId: json["user_id"],
        score: json["score"],
    );

  
}

class Student {
    Student({
        this.id,
        this.name,
    });

    int? id;
    String? name;

    factory Student.fromJson(Map<String, dynamic> json) => Student(
        id: json["id"],
        name: json["name"],
    );

  
}
