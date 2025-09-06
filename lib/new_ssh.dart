import "dart:async";

import "package:flutter/material.dart";
import "package:path/path.dart";
import "package:sqflite/sqflite.dart";
import "package:tefis_tool/custom_input.dart";

class NewSsh extends StatefulWidget {
  const NewSsh({this.id, super.key});
  final int? id;

  @override
  State<NewSsh> createState() => _NewSshState();
}

class _NewSshState extends State<NewSsh> {
  final name = TextEditingController();
  final host = TextEditingController();
  final port = TextEditingController();
  final username = TextEditingController();
  final password = TextEditingController();
  var isHide = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton.icon(
            onPressed: () async {
              final ssh = {
                "name": name.text,
                "host": host.text,
                "port": int.parse(port.text),
                "username": username.text,
                "password": password.text,
              };
              final db = await openDatabase(
                join(await getDatabasesPath(), "my_database.db"),
                version: 1,
              );
              await (widget.id == null
                  ? db.insert("ssh_details", ssh)
                  : db.update(
                      "ssh_details",
                      ssh,
                      where: "id = ?",
                      whereArgs: [widget.id],
                    ));

              if (!context.mounted) {
                return;
              }
              Navigator.pop(context);
            },
            icon: const Icon(Icons.save_alt),
            label: const Text("Save"),
          ),
        ],
        centerTitle: true,
        title:
            Text(widget.id == null ? "Add a new SSH" : "Edit the SSH Details"),
      ),
      backgroundColor: Colors.black,
      body: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xFF121212),
        ),
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            CustomInput("Name", name),
            CustomInput("Host", host),
            CustomInput("Port", port, isPort: true),
            CustomInput("Username", username),
            CustomInput(
              "password",
              password,
              isHide: isHide,
              hiden: Material(
                borderRadius: BorderRadius.circular(40),
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(40),
                  onTap: () => setState(() => isHide = !isHide),
                  child: Icon(
                    Icons.remove_red_eye,
                    color: isHide ? Colors.grey : Colors.blue,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.id != null) {
      unawaited(loadSshDetails());
    }
  }

  Future<void> loadSshDetails() async {
    final db =
        await openDatabase(join(await getDatabasesPath(), "my_database.db"));
    final List<Map<String, dynamic>> maps =
        await db.query("ssh_details", where: "id = ?", whereArgs: [widget.id]);
    if (maps.isNotEmpty) {
      setState(() {
        name.text = maps[0]["name"];
        host.text = maps[0]["host"];
        port.text = maps[0]["port"].toString();
        username.text = maps[0]["username"];
        password.text = maps[0]["password"];
      });
    }
  }
}
