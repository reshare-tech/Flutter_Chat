import 'dart:convert';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';

class MyStatefulWidget extends StatefulWidget {
  final String myName;
  const MyStatefulWidget(this.myName);
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class UserData {
  String name;
  String value;
  UserData(String n, String v) {
    name = n;
    value = v;
  }
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  Color c1 = const Color.fromRGBO(168, 214, 240, 0.8);
  Color c2 = const Color.fromRGBO(28, 147, 212, 1.0);
  TextEditingController _controller = TextEditingController();
  SocketIO socket = new SocketIOManager().createSocketIO(
    "https://flutter-chat-1.herokuapp.com/",
    "/",
  );
  List<String> myText = [];
  List<UserData> textChat = [];

  void initState() {
    socket.init();
    socket.subscribe("receive_message", (data) {
      Map<String, dynamic> map = json.decode(data);
      this.setState(() {
        textChat.add(UserData(map['name'], map['value']));
      });
    });
    socket.connect();
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    FocusScopeNode currentFocus = FocusScope.of(context);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              centerTitle: true,
              actions: [
                OutlineButton(
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                  child: Text(
                    "Exit",style:TextStyle(fontSize: 16),
                  ),
                  textColor: Colors.white,
                  borderSide: BorderSide.none,
                )
              ],
              title: Text(
                "Chatroom",
                style: TextStyle(
                  fontSize: 23,
                ),
              ),
            ),
            body: Container(
                padding: EdgeInsets.all(20.0),
                child: Column(children: <Widget>[
                  Expanded(
                      child: Container(
                          height: 490,
                          width: 380,
                          padding: EdgeInsets.all(5.0),
                          margin: EdgeInsets.only(bottom: 10.0),
                          decoration: BoxDecoration(),
                          child: ListView.builder(
                            itemCount: textChat.length,
                            reverse: true,
                            itemBuilder: (context, index) {
                              return Container(
                                  padding: EdgeInsets.all(5.0),
                                  margin:
                                      EdgeInsets.only(bottom: 7.0, top: 7.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      color: Colors.blue[50],
                                      border:
                                          Border.all(color: Colors.blue[300])),
                                  child: ListTile(
                                    title: Text(
                                      textChat[textChat.length - index - 1]
                                          .name,
                                      style: TextStyle(
                                          fontSize: 15.0, color: Colors.black),
                                    ),
                                    subtitle: Text(
                                      textChat[textChat.length - index - 1]
                                          .value,
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ));
                            },
                          ))),
                  Container(
                      child: KeyboardAttachable(
                          child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          height: deviceHeight * 0.09,
                          width: deviceWidth * 0.62,
                          child: TextField(
                            textCapitalization: TextCapitalization.sentences,
                            controller: _controller,
                            style: TextStyle(fontSize: 19),
                            decoration: InputDecoration(
                                hintText: "Type your message",
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 15.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(5.0)))),
                          )),
                      Container(
                          width: deviceWidth * 0.25,
                          height: deviceHeight * 0.077,
                          child: RaisedButton(
                            onPressed: () {
                              if (_controller.text.isNotEmpty) {
                                socket.sendMessage(
                                    "send_message",
                                    json.encode({
                                      "name": widget.myName,
                                      "value": _controller.text
                                    }));
                                this.setState(() {
                                  textChat.add(UserData(
                                      widget.myName, _controller.text));
                                });
                                _controller.clear();
                                currentFocus.unfocus();
                              }
                            },
                            color: Colors.white,
                            child: Text("Send", style: TextStyle(fontSize: 18)),
                            textColor: Colors.blue[300],
                          ))
                    ],
                  )))
                ]))));
  }
}
