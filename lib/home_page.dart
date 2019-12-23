import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '';
import '';
import '';
import '';
import '';

var homePageKey = GlobalKey<_HomePageState>();

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> listItems = [];
  List<String> completedItems = [];

  bool _validate = false;

  final TextEditingController eCtrl = TextEditingController();

  final PageController controller = PageController(
    initialPage: 1,
  );

  void _init() async {
    await SharePrefs.setInstance();
    listItems = SharePrefs.getListItems();
    completedItems = SharePrefs.getCompletedItems();
    setState(() {});
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Todo list App"),
        backgroundColor: Colors.lightBlue,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              setState(() {});
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CompletedTasks(),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          AppBackgroundPage(),
          PageView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.7),
                      color: Colors.white
                    ),
                    margin: EdgeInsets.all(5.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: eCtrl,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Write here!",
                              errorText:
                                _validate ? 'The input is empty.' : null,
                              contentPadding: const EdgeInsets.only(
                                left: 25.0, bottom: 15.0, top: 15.0
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(25.7),
                              ),
                            ),
                            autocorrect: true,
                            onSubmitted: (text) {
                              if (text.isEmpty) {
                                _validate = true;
                                setState(() {});
                              } else {
                                _validate = false;
                                completedItems.add('false');
                                listItems.add(text);
                                SharePrefs.setCompletedItems(completedItems)
                                .then((_) {
                                  setState(() {});
                                });
                                SharePrefs.setListItems(listItems).then((_) {
                                  setState(() {});
                                });
                                eCtrl.clear();
                              }
                            },
                          ),
                        ),
                        Container(
                          height: 70,
                        )
                      ]
                    )

                  )
                ],
              )
            ],
          )
        ]
      )
    );
  }
}