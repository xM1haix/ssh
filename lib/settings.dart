import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tefis_tool/adaptive.dart';
import 'package:toast/toast.dart';

import 'custom_swtich_list.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool pinUnlockIsHide = true;
  bool pinConnectIsHide = true;
  late SharedPreferences prefs;
  late bool touchIdUnlock = false;
  late bool fingerPrint = false;
  @override
  void initState() {
    super.initState();
    getPrefs();
    ToastContext().init(context);
  }

  void getPrefs() async {
    prefs = await SharedPreferences.getInstance();
    final LocalAuthentication auth = LocalAuthentication();
    await prefs.setBool('fingerPrint',
        await auth.canCheckBiometrics && await auth.isDeviceSupported());
    setState(() {
      touchIdUnlock = prefs.getBool('touchIdUnlock') ?? false;
      fingerPrint = prefs.getBool('fingerPrint') ?? false;
    });
  }

  Future<bool> getFingerPrint() async {
    try {
      return await LocalAuthentication().authenticate(
          localizedReason: 'Check the fingerprint!',
          options: const AuthenticationOptions(biometricOnly: true));
    } on PlatformException catch (e) {
      Toast.show(e.toString(), duration: 3, gravity: Toast.bottom);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('SSH List'),
      ),
      body: Container(
        margin: EdgeInsets.all(adaptive(10, context)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xFF121212),
        ),
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: fingerPrint
              ? [
                  CustomSwitchTile(
                    const Text('Unlock using fingerprint'),
                    touchIdUnlock,
                    (value) async {
                      if (await getFingerPrint()) {
                        setState(() => touchIdUnlock = value);
                        prefs.setBool('touchIdUnlock', touchIdUnlock);
                      } else {
                        Toast.show("Finger print failed",
                            duration: 3, gravity: Toast.bottom);
                      }
                    },
                  ),
                ]
              : [
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(adaptive(15, context)),
                    child: const Text(
                        "\tFinger print settings not avalibe if the devices is doesn't have the hardware or it has not active finger print!"),
                  )
                ],
        ),
      ),
    );
  }
}
