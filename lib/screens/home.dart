import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:torch/constants/home_constants.dart';
import 'package:torch/widgets/circle_container.dart';
import 'package:torch_light/torch_light.dart';
import 'package:vibration/vibration.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isOn = false;

  Future<bool> _isTorchAvailable(BuildContext context) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      return await TorchLight.isTorchAvailable();
    } on Exception catch (_) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Could not check if the device has an available torch'),
        ),
      );
      rethrow;
    }
  }

  Future<void> _torchLight() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    if (isOn) {
      try {
        Vibration.vibrate(duration: 100);
        await TorchLight.enableTorch();
      } on Exception catch (_) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Could not enable torch')),
        );
      }
    } else {
      try {
        await TorchLight.disableTorch();
      } on Exception catch (_) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Could not disable torch')),
        );
      }
    }
  }

  void _setTorch() {
    setState(() {
      isOn = !isOn;
      _torchLight();
    });
  }

  @override
  void initState() {
    super.initState();
    _isTorchAvailable(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fast Torch"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            SystemNavigator.pop();
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      backgroundColor: HomeConstants.backgroundColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isOn ? Icons.wb_sunny : Icons.wb_sunny_outlined,
              size: 120,
              color: isOn ? Color(0xFFFF8E01) : Color(0xFF504847),
            ),
            SizedBox(height: 25),
            Text(
              "FLASHLIGHT: ${isOn ? "ON" : "OFF"}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 65),
            Stack(
              alignment: Alignment.center,
              children: [
                CircleContainer(
                  w: 350,
                  h: 350,
                  color: isOn
                      ? Color.fromRGBO(73, 46, 10, 1)
                      : HomeConstants.bigButtonColor,
                ),
                CircleContainer(
                  w: 300,
                  h: 300,
                  color: isOn
                      ? Color.fromRGBO(163, 86, 5, 1)
                      : HomeConstants.midButtonColor,
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  width: HomeConstants.smallButtonSize,
                  height: HomeConstants.smallButtonSize,
                  child: ElevatedButton(
                    onPressed: () => _setTorch(),
                    child: Icon(Icons.power_settings_new, size: 170),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isOn
                          ? Color.fromRGBO(253, 127, 1, 1).withOpacity(0.82)
                          : HomeConstants.smallButtonColor,
                      foregroundColor: isOn ? Colors.white : Color(0xFFFF8E01),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
