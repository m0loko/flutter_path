import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_speed_test_plus/flutter_speed_test_plus.dart';
import 'package:lightweight_applications/screens/widgets/loading_widget.dart';
import 'package:lightweight_applications/screens/widgets/run_test_widget.dart';
import 'package:lightweight_applications/screens/widgets/space_widget.dart';
import 'package:lightweight_applications/screens/widgets/speed_gauge_widget.dart';

class SpeedTestScreen extends StatefulWidget {
  const SpeedTestScreen({super.key});

  @override
  State<SpeedTestScreen> createState() => _SpeedTestScreenState();
}

class _SpeedTestScreenState extends State<SpeedTestScreen> {
  final internetSpeedTest = FlutterInternetSpeedTest()..enableLog();
  final PageController pageController = PageController();

  double _downloadRate = 0;
  double _uploadRate = 0;
  double _finalDownloadRate = 0;
  double _finalUploadRate = 0;

  bool _isServerSelectionInProgress = false;
  bool _runTest = false;
  bool _runTestIsComplete = false;

  String? _ip;
  String _unit = 'Mbps';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Test Speed'.toUpperCase())),
      body: !_runTest
          ? RunTestWidget(onTap: startTest)
          : _isServerSelectionInProgress
          ? LoadingWidget()
          : SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: SizedBox(
                      height: 400,
                      child: PageView(
                        controller: pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          Column(
                            children: [
                              Text(
                                'DOWNLOAD SPEED',
                                style: TextStyle(
                                  color: Colors.cyanAccent,
                                  fontWeight: .bold,
                                  fontSize: 30,
                                ),
                              ),
                              SpaceWidget(),
                              SpeedGaugeWidget(
                                value: _downloadRate,
                                unit: _unit,
                                pointerColor: Colors.cyanAccent,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                'UPLOAD SPEED',
                                style: TextStyle(
                                  color: Colors.purpleAccent,
                                  fontWeight: .bold,
                                  fontSize: 30,
                                ),
                              ),
                              SpaceWidget(),
                              SpeedGaugeWidget(
                                value: _uploadRate,
                                unit: _unit,
                                pointerColor: Colors.cyanAccent,
                                enableLoadingAnimation: false,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Future<void> startTest() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        _runTest = true;
        _runTestIsComplete = false;
      });
      await internetSpeedTest.startTesting(
        onCompleted: (downloadm, upload) {
          setState(() {
            _runTestIsComplete = true;
            _finalDownloadRate = downloadm.transferRate;
            _finalUploadRate = upload.transferRate;
          });
        },
        onProgress: (percent, data) {
          setState(() {
            if (data.type == TestType.download) {
              _downloadRate = data.transferRate;
            } else {
              _uploadRate = data.transferRate;
            }
          });
        },
        onDefaultServerSelectionInProgress: () {
          setState(() {
            _isServerSelectionInProgress = true;
          });
        },
        onDefaultServerSelectionDone: (client) {
          setState(() {
            _isServerSelectionInProgress = false;
            _ip = client?.ip;
          });
        },
        onError: (erroeMessage, speedTestError) {
          reset();
        },
        onCancel: () {
          reset();
        },
      );
    });
  }

  void reset() {
    setState(() {
      _downloadRate = 0;
      _finalDownloadRate = 0;
      _uploadRate = 0;
      _finalUploadRate = 0;
      _ip = null;
      _runTest = false;
    });
  }
}
