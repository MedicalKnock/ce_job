//prefectures_select.dart
import 'dart:ffi';

import 'package:ce_job/internet_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:intl/intl.dart';

class PrefecturesSelect extends StatefulWidget {
  PrefecturesSelect(this.prefectures);

  final String prefectures;

  @override
  State<PrefecturesSelect> createState() => _PrefecturesSelectState();
}

class _PrefecturesSelectState extends State<PrefecturesSelect> {
  List<List<String>> hospitalList = [];
  List<String> favoriteSaveList = [];
  List<String> favoriteDaySaveList = [];
  List<List<String>> _workList = [];
  var sortMode = 'up';

  @override
  void initState() {
    super.initState();
    loadCSV();
    favoritefileLoad();
  }

  void loadCSV() async {
    if (widget.prefectures == '京都府') {
      final readData = await rootBundle.loadString("assets/病院一覧/京都府.txt");
      List<List<String>> list = [];
      List<String> splitList = [];
      List<String> split = readData.toString().split('\n');
      for(var i = 0; i  <split.length; i++){
        splitList = split[i].split(',');
        list.add(splitList);
      }
      hospitalList = list;
      for (var i = 0; i < hospitalList.length; i++) {
        hospitalList[i].add('false');
      }

    } else if (widget.prefectures == '大阪府') {
      final readData = await rootBundle.loadString("assets/病院一覧/大阪府.txt");
      List<List<String>> list = [];
      List<String> splitList = [];
      List<String> split = readData.toString().split('\n');
      for (var i = 0; i < split.length; i++) {
        splitList = split[i].split(',');
        list.add(splitList);
      }
      hospitalList = list;
      for (var i = 0; i < hospitalList.length; i++) {
        hospitalList[i].add('false');
      }
    }
    setState(() {});
    workSplit();
  }

  Future<void> favoritefileLoad() async {
    //お気に入り登録ファイル
    final directory = await getApplicationDocumentsDirectory();
    String file = directory.path + '/お気に入り登録.txt';
    File textfilePath = File(file);

    //お気に入り登録日
    final directory2 = await getApplicationDocumentsDirectory();
    String file2 = directory2.path + '/登録日.txt';
    File textfilePath2 = File(file2);

    //ファイルの存在確認
    if (textfilePath.existsSync()) {
      print('存在しています');
      var contents = await textfilePath.readAsString();
      var contents2 = await textfilePath2.readAsString();
      List<String> favoriteAddList = [];
      List<String> favoriteAddDayList = [];
      favoriteAddList = contents.split('\n');
      favoriteAddDayList = contents2.split('\n');
      List<String> favoriteCompareList = [];
      for (var i = 0; i < hospitalList.length; i++) {
        favoriteCompareList.add(hospitalList[i][0]);
      }
      for (var i = 0; i < favoriteAddList.length - 1; i++) {
        favoriteSaveList.add(favoriteAddList[i]);
        favoriteDaySaveList.add(favoriteAddDayList[i]);
        if (favoriteCompareList.indexOf(favoriteAddList[i]) != -1) {
          hospitalList[favoriteCompareList
              .indexOf(favoriteAddList[i])][8] = 'true';
        }
      }
    } else {
      print('存在していません');
    }
    setState(() {});
  }

  Future<void> saveFavorite() async {
    //お気に入り登録ファイル
    final directory = await getApplicationDocumentsDirectory();
    String file = directory.path + '/お気に入り登録.txt';
    File textfilePath = File(file);

    //お気に入り登録日
    final directory2 = await getApplicationDocumentsDirectory();
    String file2 = directory2.path + '/登録日.txt';
    File textfilePath2 = File(file2);

    var save = '';
    for (var i = 0; i < favoriteSaveList.length; i++) {
      save += favoriteSaveList[i].toString() + '\n';
    }
    await textfilePath.writeAsString(save);

    var save2 = '';
    for (var i = 0; i < favoriteDaySaveList.length; i++) {
      save2 += favoriteDaySaveList[i].toString() + '\n';
    }
    await textfilePath2.writeAsString(save2);
  }

  void workSplit() {
    List<List<String>> list = [];
    for (var i = 0; i < hospitalList.length; i++) {
      List<String> split = hospitalList[i][6].split('/');
      list.add(split);
    }
    _workList = list;
  }

  //病院名のソート
  void sortCharacter() {
    if (sortMode == 'up') {
      hospitalList.sort((a, b) => a[7].compareTo(b[7]));
      setState(() {});
      sortMode = 'down';
    } else if (sortMode == 'down') {
      hospitalList.sort((a, b) => -a[7].compareTo(b[7]));
      setState(() {});
      sortMode = 'up';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.greenAccent[400],
        elevation: 0,
        title: Text(widget.prefectures),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort_by_alpha),
            onPressed: () => {sortCharacter()},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(children: <Widget>[
            for (int i = 0; i < hospitalList.length; i++) ...{
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            InternetScreen(hospitalList[i][4])),
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(left: 10),
                    padding: const EdgeInsets.only(top: 10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    hospitalList[i][1],
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    hospitalList[i][2],
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    hospitalList[i][3],
                                    style: const TextStyle(
                                      fontSize: 8,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Stack(
                              children: [
                                Icon(
                                  hospitalList[i][8] == 'false'
                                      ? Icons.bookmark_outline
                                      : Icons.bookmark,
                                  size: 40,
                                ),
                                Opacity(
                                  opacity: 0.0,
                                  child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        if (hospitalList[i][8] == 'true') {
                                          hospitalList[i][8] = 'false';
                                          hospitalList[i][8] == 'false'
                                              ? Icons.bookmark_outline
                                              : Icons.bookmark;
                                          int favoriteDaySaveListDeleteNum = favoriteSaveList.indexOf(hospitalList[i][0]);
                                          favoriteDaySaveList.removeAt(favoriteDaySaveListDeleteNum);
                                          favoriteSaveList.remove(hospitalList[i][0]);

                                          saveFavorite();
                                        } else {
                                          DateTime now = DateTime.now();
                                          DateFormat outputFormat =
                                          DateFormat('yyyy/MM/dd HH:mm:ss');
                                          String date =
                                          outputFormat.format(now);
                                          icon:
                                          const Icon(Icons.bookmark);
                                          hospitalList[i][8] = 'true';
                                          hospitalList[i][8] == 'true'
                                              ? Icons.bookmark
                                              : Icons.bookmark_outline;
                                          favoriteSaveList
                                              .add(hospitalList[i][0]);
                                          favoriteDaySaveList.add(date);
                                          saveFavorite();
                                        }
                                      });
                                    },
                                    icon: const Icon(Icons.bookmark_border),
                                    color: Colors.black,
                                    iconSize: 32,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Wrap(
                            spacing: 2.0,
                            // gap between adjacent chips
                            runSpacing: 2.0,
                            // gap between lines
                            children: <Widget>[
                              for (int j = 0; j < _workList[i].length; j++) ...{
                                Chip(
                                  label: Text(_workList[i][j],
                                      style: const TextStyle(
                                          fontSize: 10,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold)),
                                  backgroundColor: Colors.grey,
                                ),
                              }
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            }
          ]),
        ),
      ),
    );
  }
}