import 'package:flutter/material.dart';

class interviewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: const Text('面接対策'),
       actions: [
         IconButton(
           icon: const Icon(
             Icons.settings,
             color: Colors.black,
             size: 30,
           ),
           onPressed: () {
             print('設定ボタンが押されました');
           },
         ),
       ],
     ),

     body: ListView(
       padding: EdgeInsets.all(16),
        children: [
          buildCard_QandA(),
          buildCard_interview(),
          buildCard_look_back(),
        ],
     ),
   );
  }
}

Widget buildCard_QandA() => Card(
  shadowColor: const Color(0xfff0f8ff),
  elevation: 8,
  clipBehavior: Clip.antiAlias,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(24),
  ),
  child: Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.white, Color(0xfff0f8ff)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    ),
    padding: const EdgeInsets.all(16),
    child: Row(
      children: [
        Image.network('https://assets.st-note.com/production/uploads/images/74412850/profile_367658e8990923a88853182e8caf84e7.jpg?width=60',
        ),
        const SizedBox(width: 10,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              '質問対策',
              style: TextStyle(
                fontSize: 30,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              '事前に回答内容をメモしよう！',
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ],
    ),
  ),
);

Widget buildCard_interview() => Card(
  shadowColor: const Color(0xfff0f8ff),
  elevation: 8,
  clipBehavior: Clip.antiAlias,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(24),
  ),
  child: Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.white, Color(0xfff0f8ff)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    ),
    padding: const EdgeInsets.all(16),
    child: Row(
      children: [
        Image.network('https://assets.st-note.com/production/uploads/images/74412850/profile_367658e8990923a88853182e8caf84e7.jpg?width=60',
        ),
        const SizedBox(width: 10,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              '面接練習',
              style: TextStyle(
                fontSize: 30,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              '仮想面接官と練習しよう！',
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ],
    ),
  ),
);

Widget buildCard_look_back() => Card(
  shadowColor: const Color(0xfff0f8ff),
  elevation: 8,
  clipBehavior: Clip.antiAlias,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(24),
  ),
  child: Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.white, Color(0xfff0f8ff)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    ),
    padding: const EdgeInsets.all(16),
    child: Row(
      children: [
        Image.network('https://assets.st-note.com/production/uploads/images/74412850/profile_367658e8990923a88853182e8caf84e7.jpg?width=60',
        ),
        const SizedBox(width: 10,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              '練習履歴',
              style: TextStyle(
                fontSize: 30,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              '過去の練習結果を振り返ろう！',
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ],
    ),
  ),
);