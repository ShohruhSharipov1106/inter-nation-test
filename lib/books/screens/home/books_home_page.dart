import 'dart:math';

import 'package:dio/dio.dart';

import 'package:inter_nation_test/books/models/books_home_model.dart';

import '../../../pupils/constants/exports/exports.dart';

class BooksHomePage extends StatefulWidget {
  const BooksHomePage({Key? key}) : super(key: key);

  @override
  State<BooksHomePage> createState() => _BooksHomePageState();
}

class _BooksHomePageState extends State<BooksHomePage> {
  Future<List<Book>>? _bookfromApi;
  Future<List<Sold>>? _soldBookFromApi;
  @override
  void initState() {
    super.initState();
    _bookfromApi = _getABookFromApi();
    _soldBookFromApi = _getSoldBookFromApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Pupils grades"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: Future.wait<List<dynamic>>(
          [
            _bookfromApi!,
            _soldBookFromApi!,
          ],
        ),
        builder: ((context, AsyncSnapshot<List> snap) {
          print(snap.data);
          if (!snap.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snap.hasError) {
            return Center(
              child: Text("${snap.error}"),
            );
          } else {
            List<Book> _snapBook = snap.data![0];
            List<Sold> _snapSoldBooks = snap.data![1];
            List thebest = soldABook(_snapBook, _snapSoldBooks);
            return Column(
              children: [
                Text(
                  "7 - martda 6-martga qaraganda savdo ${soldDays(_snapSoldBooks)} % ga kamaygan",
                ),
                Text(
                  "Eng ko'p sotilgan kitob:\n ${_snapBook[thebest[0]].name} - ${thebest[1]} marta sotilgan",
                ),
              ],
            );
          }
        }),
      ),
    );
  }

  Future<List<Book>> _getABookFromApi() async {
    Response res = await Dio().get("https://jsonkeeper.com/b/LDPQ");

    if (res.statusCode == 200) {
      List<Book> book = (json.decode(res.data)["books"] as List)
          .map((e) => Book.fromJson(e))
          .toList();
      print(book);
      return book;
    } else {
      throw Exception("Xato bor: ${res.statusCode}");
    }
  }

  Future<List<Sold>> _getSoldBookFromApi() async {
    Response response = await Dio().get("https://jsonkeeper.com/b/LDPQ");

    if (response.statusCode == 200) {
      List<Sold> soldBook = (json.decode(response.data)["sold"] as List)
          .map((e) => Sold.fromJson(e))
          .toList();
      print(soldBook);
      return soldBook;
    } else {
      throw Exception("Xato bor: ${response.statusCode}");
    }
  }

  String soldDays(List<Sold> soldAtDay) {
    int march_6 = 0;
    int march_7 = 0;
    for (var i = 0; i < soldAtDay.length; i++) {
      if (soldAtDay[i].date == soldAtDay[0].date) {
        march_7 += 1;
      } else if (soldAtDay[i].date == soldAtDay[1].date) {
        march_6 += 1;
      }
    }
    return ((1 - (march_7 / march_6)) * 100).toStringAsFixed(2);
  }

  List<int> soldABook(List<Book> soldingABook, List<Sold> soldAtDay) {
    List<int> sellingBookID = List.generate(soldingABook.length, (index) => 0);
    for (var i = 0; i < soldingABook.length; i++) {
      for (var j = 0; j < soldAtDay.length; j++) {
        if (soldingABook[i].id == soldAtDay[j].bookId) {
          sellingBookID[i] += 1;
        }
      }
    }
    int indexOfBook = sellingBookID.indexOf(
      sellingBookID.reduce(max),
    );
    return [indexOfBook, sellingBookID.reduce(max)];
  }
}
