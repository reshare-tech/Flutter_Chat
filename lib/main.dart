import "package:flutter/material.dart";
import 'package:flutter_chat/chat.dart';

void main() {
  runApp(IndexPage());
}

class IndexPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
        home: IndexPageStateful(), debugShowCheckedModeBanner: false);
  }
}

class IndexPageStateful extends StatefulWidget {
  IndexPageState createState() => IndexPageState();
}

class IndexPageState extends State<IndexPageStateful> {
  TextEditingController controller = TextEditingController();
  String userName;

  void initState() {
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text("Flutter Chat"),
              backgroundColor: Colors.blue[300],
            ),
            body: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(
                    top: 20.0, bottom: 25.0, left: 15.0, right: 15.0),
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: controller,
                      autocorrect: false,
                      enableSuggestions: false,
                      style: TextStyle(fontSize: 18),
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                          hintText: "Enter Your Name",
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 10.0)),
                    ),
                    OutlineButton(
                        onPressed: () {
                          if (controller.text.isNotEmpty) {
                             userName = controller.text;
                             controller.clear();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyStatefulWidget(userName)));
                          }
                        },
                        textColor: Colors.blue[300],
                        child: Text(
                          "Join Chat",
                          style: TextStyle(fontSize: 18),
                        ))
                  ],
                ))));
  }
}
