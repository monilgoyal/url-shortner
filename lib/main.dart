import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var url = '';
  var shorturl = '';
  bool isVisible = false;
  Future<void> fetchtinyurl(String url) async {
    var res = await http.get(Uri.parse(
        'http://tinyurl.com/api-create.php?url=' + Uri.encodeComponent(url)));
    setState(() {
      shorturl = res.body;
      isVisible = !isVisible;
    });
  }

  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "URL Shortner",
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 100.0,
            right: 20.0,
            left: 20.0,
          ),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, //Center Column contents vertically,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Form(
                key: _key,
                child: Column(
                  children: [
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Required";
                        } else if (Uri.parse(value).isAbsolute) {
                          url = value;
                          return null;
                        } else {
                          return "Enter Valid url";
                        }
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter url here',
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_key.currentState!.validate()) {
                          fetchtinyurl(url);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(5.0), // foreground
                          fixedSize: Size(70.0, 40.0)),
                      child: Text(
                        "Short",
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 50.0,
              ),
              Visibility(
                visible: isVisible,
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment
                        .center, //Center Row contents horizontally,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SelectableText(shorturl),
                      IconButton(
                        onPressed: () {
                          Clipboard.setData(
                            ClipboardData(
                              text: shorturl,
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.copy,
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
