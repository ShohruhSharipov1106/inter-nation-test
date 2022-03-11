import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:inter_nation_test/pupils/models/pupils_model.dart';

import '../../constants/exports/exports.dart';

class PupilsHomePage extends StatefulWidget {
  const PupilsHomePage({Key? key}) : super(key: key);

  @override
  State<PupilsHomePage> createState() => _PupilsHomePageState();
}

class _PupilsHomePageState extends State<PupilsHomePage> {
  List<Mark>? marks;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Pupils grades",
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: FutureBuilder(
          future: Future.wait(
            [
              getStudentsfromApi(),
              getMarksfromApi(),
            ],
          ),
          builder: (_, AsyncSnapshot<List> snap) {
            AsyncSnapshot<List<Student>>? student;
            AsyncSnapshot<List<Mark>>? mark;
            print("done");
            print(student);
            print(snap);
            print(getAvgMarks());
            print(getPupilsAvgMarks());
            return student!.connectionState == ConnectionState.done
                ? Column(
                    children: [
                      Text("${getAvgMarks()}"),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.8,
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: (getPupilsAvgMarks() as List)[index] >
                                      getAvgMarks()
                                  ? Text("${student.data![index].name}")
                                  : const Visibility(
                                      child: Text(""),
                                      visible: true,
                                    ),
                              trailing: CircleAvatar(
                                child: Text(
                                  student.data![index].id.toString(),
                                ),
                              ),
                            );
                          },
                          itemCount: student.data!.length,
                        ),
                      ),
                    ],
                  )
                : (snap.connectionState == ConnectionState.none
                    ? Center(
                        child: Text(
                          snap.error.toString(),
                        ),
                      )
                    : (snap.connectionState == ConnectionState.waiting
                        ? const Center(
                            child: CupertinoActivityIndicator(),
                          )
                        : const Center(
                            child: CircularProgressIndicator(),
                          )));
          },
        ),
      ),
    );
  }

  Future<List<Student>> getStudentsfromApi() async {
    Uri url = Uri.parse("https://jsonkeeper.com/b/AJ2X");
    http.Response res = await http.get(url);
    if (res.statusCode == 200) {
      return (json.decode(res.body)['students'] as List)
          .map((e) => Student.fromJson(e))
          .toList();
    } else {
      throw Exception("Xato bor: ${res.statusCode}");
    }
  }

  Future<List<Mark>> getMarksfromApi() async {
    Uri url = Uri.parse("https://jsonkeeper.com/b/AJ2X");
    http.Response res = await http.get(url);
    if (res.statusCode == 200) {
      final marksList = (json.decode(res.body)['marks'] as List);
      print(marksList);
      marks = marksList.map((data) => Mark.fromJson(data)).toList();
      print(marks);
      return marks!;
    } else {
      throw Exception("Xato bor: ${res.statusCode}");
    }
  }

  Future<double> getAvgMarks() async {
    double avgMarks = 0;
    for (var i = 0; i < marks!.length; i++) {
      avgMarks += double.parse(
        marks![i].score.toString(),
      );
    }
    return avgMarks / marks!.length;
  }

  Future<List<double>> getPupilsAvgMarks() async {
    List<int> studentsID = [1, 2, 3, 4, 5];
    List<double> studentAvgMarks = [];
    double avg = 0;
    int markssoni = 0;
    for (var i = 0; i <= studentsID.length; i++) {
      for (var j = 0; j <= marks!.length; j++) {
        if (studentsID[i] == marks![j].userId) {
          avg += double.parse(
            marks![j].score.toString(),
          );
          markssoni += 1;
        }
      }
      studentAvgMarks.add(avg / markssoni);
    }
    return studentAvgMarks;
  }
}
