import 'dart:async';
import 'scan.dart';
import 'package:flutter/material.dart';
import 'package:bluetooth/global.dart';
import 'alarm.dart';

//SplashScreens
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    // 5초 후에 홈페이지로 이동
    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //const FlutterLogo(size: 150), // 로고 이미지
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Image.asset('assets/images/start_image.jpg'),
            ),
            const SizedBox(height: 16.0),
            const Text('Home Training Counter',
                style: TextStyle(fontSize: 24.0)), // 앱 이름
            const SizedBox(height: 16.0),
            const CircularProgressIndicator(), // 로딩 애니메이션
          ],
        ),
      ),
    );
  }
}

void main() {
  return runApp(
    MaterialApp(home: SplashScreen()),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Home Training Counter'),
      ),
      body: Container(
          child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 80),
            child: Center(
                child: Text(
              '아직 목표에 도달하진 않았지만\n어제의 나보다 오늘의 내가 목표에 더 가까워졌다',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            )),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Image.asset('assets/images/home_image.jpg'),
          )
        ],
      )),
      persistentFooterButtons: [
        // We want to enable this button if the scan has NOT started
        // If the scan HAS started, it should be disabled.
        // True condition
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.blue, // background
            onPrimary: Colors.white, // foreground
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ScanPage()),
            );
          },
          child: const Icon(Icons.search),
        ),
        ElevatedButton(
          child: const Icon((Icons.list)),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SecondRoute()),
            );
          },
        ),
        ElevatedButton(
          child: const Icon((Icons.alarm)),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NewPage()),
            );
          },
        ),
      ],
    );
  }
}

class ColumnTextStyle {
  static const TextStyle defaultStyle = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.italic,
    // other style properties...
  );
}

class TodayDateWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate =
        "${now.year}-${_formatNumber(now.month)}-${_formatNumber(now.day)}";

    return Text('$formattedDate');
  }

  String _formatNumber(int number) {
    return number.toString().padLeft(2, '0');
  }
}

class SecondRoute extends StatefulWidget {
  const SecondRoute({super.key});
  @override
  _SecondRouteState createState() => _SecondRouteState();
}

class _SecondRouteState extends State<SecondRoute> {
  List<DataRow> dataRows = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WorkOut Log'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DataTable(columns: const <DataColumn>[
            DataColumn(
                label: Text(
              'Date',
              style: TextStyle(fontSize: 16),
            )),
            DataColumn(
                label: Text(
              'Push Up',
              style: ColumnTextStyle.defaultStyle,
            )),
            DataColumn(
                label: Text(
              'Sit Up',
              style: ColumnTextStyle.defaultStyle,
            )),
            DataColumn(
                label: Text(
              'Plank',
              style: ColumnTextStyle.defaultStyle,
            )),
          ], rows: dataRows),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Go back!'),
          ),
        ],
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 16.0, right: 16.0),
        child: FloatingActionButton(
          onPressed: () {
            // + 버튼을 눌렀을 때 동작할 코드
            DataRow newRow = DataRow(cells: <DataCell>[
              DataCell(TodayDateWidget()),
              DataCell(Text(pushUpsCnt.toString())),
              DataCell(Text(sitUpsCnt.toString())),
              DataCell(Text(plankCnt.toString())),
            ]);

            // 생성한 데이터 로우 추가
            setState(() {
              dataRows.add(newRow);
            });

            // 추가된 데이터 로우를 출력
            print('New row added: $newRow');
          },
          child: Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
