import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import "package:web_socket_channel/web_socket_channel.dart";
import "package:web_socket_channel/io.dart";
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
  UserData(String name, String value) {
    name = this.name;
    value = this.value;
  }
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  Color c1 = const Color.fromRGBO(168, 214, 240, 0.8);
  Color c2 = const Color.fromRGBO(28, 147, 212, 1.0);
  TextEditingController _controller = TextEditingController();
  SocketIO socket = new SocketIOManager().createSocketIO("ws://echo.websocket.org"," ");
  List<UserData> myText = [];

  _MyStatefulWidgetState() {
    channel.stream.asBroadcastStream().listen((data) {
      setState(() {
        myText.add(data);
      });
    });
  }
  void initState() {
    super.initState();
  }

  void dispose() {
    channel.sink.close();
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
                new IconButton(
                    icon: new Icon(Icons.close),
                    onPressed: () {
                      SystemNavigator.pop();
                    })
              ],
              title: Text("Flutter Chat"),
              backgroundColor: Colors.blue[300],
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
                            itemCount: myText.length,
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
                                      myText[myText.length - index - 1].name,
                                      style: TextStyle(
                                          fontSize: 15.0, color: Colors.black),
                                    ),
                                    subtitle: Text(
                                      myText[myText.length - index - 1].value,
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
                                UserData data = new UserData(
                                    widget.myName, _controller.text);
                                channel.sink.add(data);
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
