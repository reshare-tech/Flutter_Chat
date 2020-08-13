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
                padding: EdgeInsets.all(10.0),
                child: Column(children: <Widget>[
                  Expanded(
                      child: Container(
                          height: 490,
                          width: 380,
                          padding: EdgeInsets.all(5.0),
                          margin: EdgeInsets.only(bottom: 10.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10.0))
                          ),
                          child: ListView.builder(
                            itemCount: textChat.length,
                            reverse: true,
                            itemBuilder: (context, index) {
                              return Container(
                                  margin : EdgeInsets.only(bottom:4.0,top:4.0,left: 10.0,right: 10.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                  child: Card(
                                    color: Color.fromRGBO(249, 249, 252, 1.0),
                                    shadowColor: Colors.black,
                                    elevation: 3.0,
                                    borderOnForeground: true,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(9.0))),
                                    child : ListTile(
                                    title: Text(
                                      textChat[textChat.length - index - 1]
                                          .name,
                                      style: TextStyle(
                                          fontSize: 15.0, color: Colors.black,fontWeight: FontWeight.w300),
                                    ),
                                    subtitle: Text(
                                      textChat[textChat.length - index - 1]
                                          .value,
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  )));
                            },
                          ))),
                  Container(
                      child: KeyboardAttachable(
                          child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          height: deviceHeight * 0.09,
                          width: deviceWidth * 0.66,
                          child: TextField(
                            textCapitalization: TextCapitalization.sentences,
                            controller: _controller,
                            style: TextStyle(fontSize: 19),
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                                hintText: "Type your message",
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 15.0, vertical: 15.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(24.0)))),
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
