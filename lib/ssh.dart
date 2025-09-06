import "dart:async";

import "package:flutter/material.dart";
import "package:path/path.dart";
import "package:sqflite/sqflite.dart";
import "package:tefis_tool/adaptive.dart";
import "package:tefis_tool/new_ssh.dart";
import "package:tefis_tool/settings.dart";
import "package:tefis_tool/terminal.dart";

class SSHList extends StatefulWidget {
  const SSHList({Key? key}) : super(key: key);

  @override
  State<SSHList> createState() => _SSHListState();
}

class Terminals {
  Terminals({
    required this.id,
    required this.name,
    required this.host,
    required this.port,
    required this.username,
    required this.password,
  });
  int id;
  final String name;
  final String host;
  final int port;
  final String username;
  final String password;
}

class _SSHListState extends State<SSHList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("SSH List"),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Settings()),
            ),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(adaptive(10, context)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(adaptive(10, context)),
          color: const Color(0xFF121212),
        ),
        padding: EdgeInsets.all(adaptive(10, context)),
        child: FutureBuilder<List<Terminals>>(
          future: getAllSshDetails(),
          builder: (context, snapshot) => !snapshot.hasData
              ? const Text("Nothing in here")
              : ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (_, i) => Padding(
                    padding: EdgeInsets.all(adaptive(3, context)),
                    child: Material(
                      borderRadius:
                          BorderRadius.circular(adaptive(10, context)),
                      color: Colors.black,
                      child: InkWell(
                        splashColor: Colors.green,
                        borderRadius:
                            BorderRadius.circular(adaptive(10, context)),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TerminalSSH(
                              snapshot.data![i].name,
                              snapshot.data![i].host,
                              snapshot.data![i].port,
                              snapshot.data![i].username,
                              snapshot.data![i].password,
                            ),
                          ),
                        ),
                        child: Container(
                          height: adaptive(72, context),
                          padding: EdgeInsets.symmetric(
                            horizontal: adaptive(16, context),
                          ),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(adaptive(10, context)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.terminal_outlined),
                              SizedBox(width: adaptive(16, context)),
                              Expanded(
                                child: Text(
                                  snapshot.data![i].name,
                                  style: TextStyle(
                                    fontSize: adaptive(16, context),
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              NewSsh(id: snapshot.data![i].id),
                                        ),
                                      );
                                      setState(() {});
                                    },
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () async => showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text(
                                          "Are you sure you want to delete?",
                                        ),
                                        actions: [
                                          TextButton(
                                            child: const Text(
                                              "Cancel",
                                              style:
                                                  TextStyle(color: Colors.blue),
                                            ),
                                            onPressed: () =>
                                                Navigator.pop(context),
                                          ),
                                          TextButton(
                                            child: const Text(
                                              "Delete",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                            onPressed: () async {
                                              final db = await openDatabase(
                                                join(
                                                  await getDatabasesPath(),
                                                  "my_database.db",
                                                ),
                                              );
                                              await db.delete(
                                                "ssh_details",
                                                where: "id = ?",
                                                whereArgs: [
                                                  snapshot.data![i].id,
                                                ],
                                              );
                                              if (!context.mounted) {
                                                return;
                                              }
                                              Navigator.pop(context);
                                              setState(() {});
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add",
        splashColor: Colors.blue,
        backgroundColor: Colors.transparent,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewSsh()),
          );
          setState(() {});
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Future<List<Terminals>> getAllSshDetails() async {
    final db =
        await openDatabase(join(await getDatabasesPath(), "my_database.db"));
    final List<Map<String, dynamic>> maps = await db.query("ssh_details");
    return List.generate(
      maps.length,
      (i) => Terminals(
        id: maps[i]["id"],
        name: maps[i]["name"],
        host: maps[i]["host"],
        port: maps[i]["port"],
        username: maps[i]["username"],
        password: maps[i]["password"],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    unawaited(getAllSshDetails());
  }
}
