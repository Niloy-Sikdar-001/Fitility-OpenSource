import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'webview.dart';

class Dance extends StatefulWidget {
  @override
  _DanceState createState() => _DanceState();
}

class _DanceState extends State<Dance> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20.0,
        right: 20.0,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20.5,
            ),
            StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection('dance').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError)
                    return new Text('Error: ${snapshot.error}');
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return new Text('Loading....');
                    default:
                      return new ListView(
                        shrinkWrap: true,
                        children: snapshot.data.documents
                            .map((DocumentSnapshot document) {
                          String url = document['imageUrl'];
                          return Column(
                            children: [
                              new Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.remove,
                                          color: Colors.red.shade700,
                                          size: 30.0,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            _handleURLButtonPress(
                                              context,
                                              document['link'],
                                              document['title'],
                                            );
                                          },
                                          child: Text(
                                            document['title'],
                                            style: TextStyle(
                                              fontFamily: 'Rubik Regular',
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        right: 25.0,
                                        top: 13,
                                        bottom: 12.0,
                                      ),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        child: InkWell(
                                          onTap: () {
                                            _handleURLButtonPress(
                                              context,
                                              document['link'],
                                              document['title'],
                                            );
                                          },
                                          child: Image.network(
                                            url,
                                            height: 53.0,
                                            width: 100.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                            ],
                          );
                        }).toList(),
                      );
                  }
                }),
          ],
        ),
      ),
    );
  }

  void _handleURLButtonPress(BuildContext context, String url, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewContainer(url, title),
      ),
    );
  }
}
