import 'dart:io';

import 'package:dio/dio.dart';

import 'package:inter_nation_test/pupils/models/pupils_model.dart';

import '../../constants/exports/exports.dart';

class PupilsHomePage extends StatefulWidget {
  const PupilsHomePage({Key? key}) : super(key: key);

  @override
  State<PupilsHomePage> createState() => _PupilsHomePageState();
}

class _PupilsHomePageState extends State<PupilsHomePage> {
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
      body: Column(
        children: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.movie_filter),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width,
            child: FutureBuilder(
              future: Future.wait([
                getStudentsfromApi(),
                getMarksfromApi(),
              ]),
              builder: (context, AsyncSnapshot<List<dynamic>> snap) {
                print(snap);
                print(snap.data);
                if (!snap.hasData) {
                  print("NULL");
                  print(snap.data![0]);
                  return const Center(child: CircularProgressIndicator());
                } else if (snap.hasError) {
                  print("ERROR");
                  return Center(
                    child: Text(
                      snap.error.toString(),
                    ),
                  );
                } else {
                  print("DONE");
                  List<Student> _snapStudent = snap.data![0];
                  List<Mark> _snapMark = snap.data![1];
                  double averageBaho = getAvgMarks(_snapMark);
                  return Column(
                    children: [
                      Text("$averageBaho"),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.8,
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: (getPupilsAvgMarks(_snapMark))[index] >
                                      averageBaho
                                  ? Text("${_snapStudent[index].name}")
                                  : const Visibility(
                                      child: Text(""),
                                      visible: true,
                                    ),
                              trailing: CircleAvatar(
                                child: Text(
                                  _snapStudent[index].id.toString(),
                                ),
                              ),
                            );
                          },
                          itemCount: _snapStudent.length,
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<List<Student>> getStudentsfromApi() async {
    Response res = await Dio().get("https://jsonkeeper.com/b/AJ2X");
    if (res.statusCode == HttpStatus.ok) {
      // List<Student>? students = (json.decode(res.data)['student'] as List)
      //     .map((e) => Student.fromJson(e))
      //     .toList();
      Map<String, dynamic> map = json.decode(res.data);
      List<dynamic> data = map["students"];
      print(data[0]["name"]);
      ;
      return data[0];
    } else {
      throw Exception("Xato bor: ${res.statusCode}");
    }
  }

  Future<List<Mark>> getMarksfromApi() async {
    Response res = await Dio().get("https://jsonkeeper.com/b/AJ2X");
    if (res.statusCode == 200) {
      List<Mark> marks = (json.decode(res.data)['marks'] as List)
          .map((e) => Mark.fromJson(e))
          .toList();
      return marks;
    } else {
      throw Exception("Xato bor: ${res.statusCode}");
    }
  }

  double getAvgMarks(List<Mark> grades) {
    double avgMarks = 0;
    for (var i = 0; i < grades.length - 1; i++) {
      avgMarks += double.parse(
        grades[i].score.toString(),
      );
    }
    return avgMarks / grades.length;
  }

  List<double> getPupilsAvgMarks(
    List<Mark> listmarks,
  ) {
    List<int> studentsID = [1, 2, 3, 4, 5];
    List<double> studentAvgMarks = [];
    double avg = 0;
    int markssoni = 0;
    for (var i = 0; i <= studentsID.length; i++) {
      for (var j = 0; j <= listmarks.length; j++) {
        if (studentsID[i] == listmarks[j].userId) {
          avg += double.parse(
            listmarks[j].score.toString(),
          );
          markssoni += 1;
        }
      }
      studentAvgMarks.add(avg / markssoni);
    }
    return studentAvgMarks;
  }
}
