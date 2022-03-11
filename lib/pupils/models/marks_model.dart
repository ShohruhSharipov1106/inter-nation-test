class Marks {
    Marks({
        this.userId,
        this.score,
    });

    int? userId;
    int? score;

    factory Marks.fromJson(Map<String, dynamic> json) => Marks(
        userId: json["user_id"],
        score: json["score"],
    );

    
}
