import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:bluetooth/global.dart';

class ScanPage extends StatefulWidget {
  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  BluetoothDevice? device;
  BluetoothCharacteristic? serialCharacteristic;

  List<ScanResult> scanResults = [];

  @override
  void initState() {
    super.initState();
    startScan();
  }

  void startScan() {
    flutterBlue.startScan(timeout: const Duration(seconds: 4));
    var scanSubscription = flutterBlue.scanResults.listen((results) {
      for (ScanResult r in results) {
        scanResults = results;
        print('${r.device.name} found! rssi: ${r.rssi}');
      }
      showScan(); // 데이터 업데이트 시 showScan() 호출
    });
  }

  void connectDevice(BluetoothDevice d) async {
    await d.connect();
  }

  void discoverServices(BluetoothDevice d) async {
    if (d != null) {
      List<BluetoothService> services = await d!.discoverServices();
      // ignore: avoid_function_literals_in_foreach_calls
      for (var service in services) {
        for (var characteristic in service.characteristics) {
          if (characteristic.uuid.toString() ==
              '0000ffe1-0000-1000-8000-00805f9b34fb') {
            print("success characteristic & uuid");
            serialCharacteristic = characteristic;
          }
        }
      }
    } else {
      print("device is null");
    }
  }

  void subscribeTochar(BluetoothCharacteristic characteristic) async {
    await characteristic.setNotifyValue(true);
    print('sucess subscribe');
    var value = characteristic.read();
    print('character value $value');
    characteristic.value.listen((data) {
      print('Received data: $data');
      String text = String.fromCharCodes(data);
      print(text);
      RegExp regex_push = RegExp(r'^Pu'); // 정규식 패턴: 문자열의 맨 앞이 'Pu'인지 확인
      RegExp regex_sit = RegExp(r'^S'); // 정규식 패턴: 문자열의 맨 앞이 'S'인지 확인
      RegExp regex_plank = RegExp(r'^Pl'); // 정규식 패턴: 문자열의 맨 앞이 'Pl'인지 확인
      RegExp regex = RegExp(r'(\d+)'); // 정규식 패턴: 문자열의 접두사에 있는 숫자
      int cnt = 0;

      Match? match = regex.firstMatch(text); // 정규식에 첫 번째 일치하는 부분 찾기

      if (match != null) {
        String numberString = match.group(1)!; // 첫 번째 그룹 추출 (숫자 부분)
        int number = int.parse(numberString); // 정수로 파싱
        if (regex_push.hasMatch(text)) {
          pushUpsCnt = number;
        } else if (regex_sit.hasMatch(text)) {
          sitUpsCnt = number;
        } else if (regex_plank.hasMatch(text)) {
          plankCnt = number;
        }
        print(number);
      } else {
        print('number is null');
      }
    });
  }

  void subscribeNull(BluetoothCharacteristic? c) {
    if (serialCharacteristic != null) {
      BluetoothCharacteristic nonnull = c as BluetoothCharacteristic;
      subscribeTochar(nonnull);
    } else {
      print('serial Characteristic is null');
    }
  }

  void stopScan() {
    flutterBlue.stopScan();
  }

  void showScan() {
    setState(() {});
  }

  @override
  void dispose() {
    stopScan();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Device Scan'),
        ),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 30),
                  child: ElevatedButton(
                      onPressed: startScan, child: const Text('Scan')),
                ),
                ElevatedButton(onPressed: stopScan, child: const Text('Stop')),
                ElevatedButton(
                    onPressed: () {
                      subscribeNull(serialCharacteristic);
                    },
                    child: Text('Read')),
              ],
            ),
            Expanded(
                child: ListView.builder(
              itemCount: scanResults.length,
              itemBuilder: (context, index) {
                ScanResult result = scanResults[index];
                BluetoothDevice? device = result.device;
                return ListTile(
                    title: Text(device.name),
                    subtitle: Text(device.id.toString()),
                    trailing: Column(
                      children: [
                        Expanded(
                            child: ElevatedButton(
                          onPressed: () {
                            connectDevice(device);
                            discoverServices(device);
                          },
                          child: const Icon(Icons.play_arrow),
                        )),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(top: 3),
                          child: ElevatedButton(
                            onPressed: () async {
                              await device.disconnect();
                            },
                            child: const Icon(Icons.stop),
                          ),
                        )),
                      ],
                    ));
              },
            ))
          ],
        ));
  }
}
