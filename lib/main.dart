//main.dart
import 'dart:convert';
import 'package:ce_job/internet_screen.dart';
import 'package:ce_job/prefectures_select.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:intl/intl.dart';
//
void main() =>
    runApp(MaterialApp(debugShowCheckedModeBanner: false, home: HomePage()));

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> _picturelistItem = [
    'assets/images/24.png',
    'assets/images/25.png',
    'assets/images/26.png',
    'assets/images/27.png',
    'assets/images/28.png',
    'assets/images/29.png',
    'assets/images/30.png',
  ];

  final List<String> _PrefectureslistItem = [
    '三重県',
    '滋賀県',
    '京都府',
    '大阪府',
    '兵庫県',
    '奈良県',
    '和歌山県',
  ];

  List<List<String>> hospitalList = []; //初期値
  List<List<String>> hospitalFavoriteList = []; //お気に入り一覧用
  List<List<String>> listData26 = [];
  List<List<String>> listData27 = [];
  List<String> favoriteSaveList = [];
  List<String> favoriteDaySaveList = [];
  List<List<String>> _workList = [];
  String _title = '病院一覧';

  @override
  void initState() {
    super.initState();
    loadCSV();
    favoritefileLoad();
  }

  void loadCSV() async {
    final readData26 = await rootBundle.loadString("assets/病院一覧/京都府.txt");
    List<String> split26 = [];
    List<String> splitList26 = [];
    split26 = readData26.toString().split('\n');
    for(var i = 0; i  <split26.length; i++){
      splitList26 = split26[i].split(',');
      listData26.add(splitList26);
    }
    final readData27 = await rootBundle.loadString("assets/病院一覧/大阪府.txt");
    List<String> split27 = [];
    List<String> splitList27 = [];
    split27 = readData27.toString().split('\n');
    for(var i = 0; i  <split27.length; i++){
      splitList27 = split27[i].split(',');
      listData26.add(splitList27);
    }

    //画面を更新する
    setState(() {
      hospitalList = [];
      hospitalList = listData26 + listData27;
      for (var i = 0; i < hospitalList.length; i++) {
        hospitalList[i].add('false');
      }
    });
  }

  void workSplit() {
    List<List<String>> list = [];
    for (var i = 0; i < hospitalFavoriteList.length; i++) {
      List<String> split = hospitalFavoriteList[i][6].split('/');
      list.add(split);
    }
    _workList = list;
  }

//ボトムナビゲーションボタンの画面
  var _selectIndex = 0;
  void _onTapItem(int index) {
    setState(() {
      _selectIndex = index;
      loadCSV();
      favoritefileLoad();
      switch (index) {
        case 0:
          _title = '病院一覧';
          break;
        case 1:
          _title = '登録病院';
          break;
        case 2:
          _title = '面接対策';
          break;
        case 3:
          _title = 'お問い合わせ';
          break;
        case 4:
          _title = '各種設定';
          break;
      }
    });
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
      hospitalFavoriteList = [];
      favoriteSaveList = [];
      favoriteDaySaveList = [];

      //String→int型に変換
      for (var i = 0; i < hospitalList.length; i++) {
        favoriteCompareList.add(hospitalList[i][0]);
      }

      for (var i = 0; i < favoriteAddList.length - 1; i++) {
        if (favoriteCompareList.indexOf(favoriteAddList[i]) != -1) {
          hospitalFavoriteList.add(hospitalList[favoriteCompareList.indexOf(favoriteAddList[i])]);
          hospitalFavoriteList[i].add(favoriteAddDayList[i]);
        } else {
          favoriteCompareList.remove(int.parse(favoriteAddList[i]));
        }
      }

      //お気に入りリストの\n分-1
      for (var i = 0; i < favoriteAddList.length - 1; i++) {
        favoriteSaveList.add(favoriteAddList[i]);
        favoriteDaySaveList.add(favoriteAddDayList[i]);
        if (favoriteCompareList.indexOf(favoriteAddList[i]) != -1) {
          hospitalFavoriteList[i][8] = 'true';
        } else {
          print('存在していません');
        }
      }
      setState(() {});
    }
    workSplit();
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
    setState(() {
      favoritefileLoad();
    });
  }

  Future<void> filterSelection() async {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text("並べ替え"),
          children: [
            SimpleDialogOption(
              onPressed: () {
                hospitalFavoriteList.sort((a, b) => a[0].compareTo(b[0]));
                Navigator.pop(context);
                workSplit();
                setState(() {});
              },
              child: Text("フィルタ解除"),
            ),
            SimpleDialogOption(
              onPressed: () {
                hospitalFavoriteList.sort((a, b) => a[7].compareTo(b[7]));
                Navigator.pop(context);
                workSplit();
                setState(() {});
              },
              child: Text("名前の昇順"),
            ),
            SimpleDialogOption(
              onPressed: () {
                hospitalFavoriteList.sort((a, b) => -a[7].compareTo(b[7]));
                Navigator.pop(context);
                workSplit();
                setState(() {});
              },
              child: Text("名前の降順"),
            ),
            SimpleDialogOption(
              onPressed: () {
                hospitalFavoriteList.sort((a, b) => a[9].compareTo(b[9]));
                Navigator.pop(context);
                workSplit();
                setState(() {});
              },
              child: Text("登録の新しい順"),
            ),
            SimpleDialogOption(
              onPressed: () {
                hospitalFavoriteList.sort((a, b) => -a[9].compareTo(b[9]));
                Navigator.pop(context);
                workSplit();
                setState(() {});
              },
              child: Text("登録の古い順"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var _pages = <Widget>[
      ///病院一覧////////////////////////////////////////////////////////////////
      Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10.0),
                child: GridView.count(
                  crossAxisCount: 3,
                  //横に並べる件数
                  crossAxisSpacing: 10,
                  //グリッド間の横スペース
                  mainAxisSpacing: 10,
                  //グリッド間の縦スペース
                  children: <Widget>[
                    for (int i = 0; i < _PrefectureslistItem.length; i++) ...{
                      Card(
                        shadowColor: Colors.black,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PrefecturesSelect(
                                      _PrefectureslistItem[i])),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            //中央寄せ
                            children: <Widget>[
                              Image.asset(
                                _picturelistItem[i],
                                width: 60,
                                height: 80,
                              ),
                              Container(
                                alignment: Alignment.center,
                                width: 100,
                                decoration:
                                const BoxDecoration(color: Colors.white),
                                child: Text(
                                  _PrefectureslistItem[i],
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    }
                  ],
                  shrinkWrap: true,
                ),
              ),
            ],
          ),
        ),
      ),

      ///登録病院////////////////////////////////////////////////////////////////
      Container(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10.0),
            child: Column(children: <Widget>[
              for (int i = 0; i < hospitalFavoriteList.length; i++) ...{
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              InternetScreen(hospitalFavoriteList[i][4])),
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
                                      hospitalFavoriteList[i][1],
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      hospitalFavoriteList[i][2],
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      hospitalFavoriteList[i][3],
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
                                    hospitalFavoriteList[i][8] == 'false' ? Icons.bookmark_outline : Icons.bookmark,
                                    size: 40,
                                  ),
                                  Opacity(
                                    opacity: 0.0,
                                    child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          if (hospitalFavoriteList[i][8] == 'true') {
                                            hospitalFavoriteList[i][8] = 'false';
                                            hospitalFavoriteList[i][8] == 'false' ? Icons.bookmark_outline : Icons.bookmark;
                                            favoriteDaySaveList.removeAt(favoriteSaveList.indexOf(hospitalFavoriteList[i][0]));
                                            favoriteSaveList.remove(hospitalFavoriteList[i][0]);
                                            hospitalFavoriteList.remove([i]);
                                            saveFavorite();
                                          } else {
                                            DateTime now = DateTime.now();
                                            DateFormat outputFormat =
                                            DateFormat('yyyy/MM/dd HH:mm:ss');
                                            String date = outputFormat.format(now);
                                            icon: const Icon(Icons.bookmark);
                                            hospitalFavoriteList[i][8] = 'true';
                                            hospitalFavoriteList[i][8] == 'true' ? Icons.bookmark : Icons.bookmark_outline;
                                            favoriteSaveList.add(hospitalFavoriteList[i][0]);
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
      ),
      Container(
        child: Text('Favorite'),
        alignment: Alignment.center,
        color: Colors.pink.withOpacity(0.5),
      ),
      Container(
        child: Text('Favorite'),
        alignment: Alignment.center,
        color: Colors.pink.withOpacity(0.5),
      ),
      Container(
        child: Text('Favorite'),
        alignment: Alignment.center,
        color: Colors.pink.withOpacity(0.5),
      ),
    ];

    var _appberactions = <Widget>[
      IconButton(
        icon: Icon(Icons.settings),
        onPressed: () {},
      ),
      IconButton(
        icon: Icon(Icons.sort_by_alpha),
        onPressed: () {
          filterSelection();
        },
      ),
      IconButton(
        icon: Icon(Icons.save_as),
        onPressed: () {},
      ),
      IconButton(
        icon: Icon(Icons.forward_to_inbox),
        onPressed: () {},
      ),
      IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          filterSelection();
        },
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.greenAccent[400],
        elevation: 0,
        centerTitle: true,
        title: Text(_title),
        actions: <Widget>[
          _appberactions[_selectIndex],
        ],
      ),
      body: _pages[_selectIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[50],
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: '病院一覧',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: '登録病院',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.question_answer),
            label: '面接対策',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mail),
            label: 'お問い合わせ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '各種設定',
          ),
        ],
        currentIndex: _selectIndex,
        onTap: _onTapItem,
      ),
    );
  }
}
