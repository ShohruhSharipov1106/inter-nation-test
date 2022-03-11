
class Books {
    Books({
        this.books,
        this.sold,
    });

    List<Book>? books;
    List<Sold>? sold;

    factory Books.fromJson(Map<String, dynamic> json) => Books(
        books: List<Book>.from(json["books"].map((x) => Book.fromJson(x))),
        sold: List<Sold>.from(json["sold"].map((x) => Sold.fromJson(x))),
    );

    
}

class Book {
    Book({
        this.id,
        this.name,
    });

    int? id;
    String? name;

    factory Book.fromJson(Map<String, dynamic> json) => Book(
        id: json["id"],
        name: json["name"],
    );

    
}

class Sold {
    Sold({
        this.bookId,
        this.date,
    });

    int? bookId;
    DateTime? date;

    factory Sold.fromJson(Map<String, dynamic> json) => Sold(
        bookId: json["book_id"],
        date: DateTime.parse(json["date"]),
    );

}
