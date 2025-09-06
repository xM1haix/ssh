import "dart:async";
import "dart:convert";

import "package:dartssh2/dartssh2.dart";
import "package:flutter/material.dart";
import "package:tefis_tool/virtual_keys.dart";
import "package:xterm/xterm.dart";

class TerminalSSH extends StatefulWidget {
  const TerminalSSH(
    this.name,
    this.host,
    this.port,
    this.username,
    this.password, {
    super.key,
  });
  final String name;
  final String host;
  final String username;
  final String password;
  final int port;

  @override
  State<TerminalSSH> createState() => _TerminalSSHState();
}

class _TerminalSSHState extends State<TerminalSSH> {
  late final terminal = Terminal(inputHandler: keyboard);
  final keyboard = VirtualKeyboard(defaultInputHandler);
  final terminalController = TerminalController();

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: const Color(0xFF121212),
          title: Text(widget.name),
          actions: [VirtualKeyboardView(keyboard)],
        ),
        body: TerminalView(terminal, backgroundOpacity: 0),
      );

  Future<void> connectToServer() async {
    terminal.write("Connecting...\r\n");
    try {
      final client = SSHClient(
        await SSHSocket.connect(widget.host, widget.port),
        username: widget.username,
        onPasswordRequest: () => widget.password,
      );
      final session = await client.shell(
        pty: SSHPtyConfig(
          width: terminal.viewWidth,
          height: terminal.viewHeight,
        ),
      );
      terminal.buffer.clear();
      terminal.buffer.setCursor(0, 0);
      terminal.onResize = session.resizeTerminal;
      terminal.onOutput = (data) => session.write(utf8.encode(data));
      session.stdout
          .cast<List<int>>()
          .transform(const Utf8Decoder())
          .listen(terminal.write);
      session.stderr
          .cast<List<int>>()
          .transform(const Utf8Decoder())
          .listen(terminal.write);
      terminal.write("Connected.\r\n");
    } catch (e) {
      terminal.write("Error connecting to server: $e\r\n");
    }
  }

  @override
  void initState() {
    super.initState();
    unawaited(connectToServer());
  }
}
