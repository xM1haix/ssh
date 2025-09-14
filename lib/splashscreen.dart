import "dart:async";

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:local_auth/local_auth.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:tefis_tool/adaptive.dart";
import "package:tefis_tool/ssh.dart";
import "package:toast/toast.dart";

///UI for the splash screen including
///a locking system and a disable fingerprint
class SplashScreen extends StatefulWidget {
  ///
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late SharedPreferences prefs;
  late var touchIdUnlock = false;
  late var fingerPrint = false;
  var reset = 0;

  Future auth() async {
    await Future.delayed(const Duration(seconds: 1));
    if (touchIdUnlock && fingerPrint) {
      final authenticated = await getFingerPrint();
      if (authenticated) {
        await nav();
      }
      if (reset == 117) {
        await prefs.setBool("touchIdUnlock", false);
        await prefs.setBool("fingerPrint", false);
        await nav();
      }
    } else {
      await nav();
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.black,
        body: GestureDetector(
          onTap: () => setState(() => reset = reset + 1),
          onDoubleTap: () => setState(() => reset = reset * 6),
          onLongPress: () => setState(() => reset = reset * 9),
          child: FutureBuilder(
            future: auth(),
            builder: (context, snapshot) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  const Text("Welcome!"),
                  SizedBox(height: adaptive(10, context)),
                  CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: adaptive(2, context),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      );
  Future<bool> getFingerPrint() async {
    try {
      return await LocalAuthentication().authenticate(
        localizedReason: "Check the fingerprint!",
        options: const AuthenticationOptions(biometricOnly: true),
      );
    } on PlatformException catch (e) {
      Toast.show(e.message.toString(), duration: 3);
      return false;
    }
  }

  Future<void> getPrefs() async {
    prefs = await SharedPreferences.getInstance();
    final auth = LocalAuthentication();
    await prefs.setBool(
      "fingerPrint",
      await auth.canCheckBiometrics && await auth.isDeviceSupported(),
    );
    setState(() {
      touchIdUnlock = prefs.getBool("touchIdUnlock") ?? false;
      fingerPrint = prefs.getBool("fingerPrint") ?? false;
    });
  }

  @override
  void initState() {
    super.initState();
    unawaited(getPrefs());
    ToastContext().init(context);
  }

  Future<void> nav() async {
    if (!mounted) {
      return;
    }
    await Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(seconds: 1),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const SSHList(),
      ),
    );
  }
}
