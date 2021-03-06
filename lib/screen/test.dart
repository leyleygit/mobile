import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TestFirestore extends StatefulWidget {
  @override
  _TestFirestoreState createState() => _TestFirestoreState();
}

class _TestFirestoreState extends State<TestFirestore> {
  bool _isLongPress = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: _isLongPress
              ? IconButton(
                  icon: Icon(Icons.clear_rounded),
                  onPressed: () {
                    setState(() {
                      _isLongPress = false;
                    });
                  },
                )
              : null,
          title: Text('Cloud Firestore'),
          centerTitle: true,
          backgroundColor: Colors.orange[300],
          actions: [
            _isLongPress
                ? IconButton(
                    icon: Icon(
                      Icons.edit_outlined,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _isLongPress = false;
                      });
                    },
                  )
                : Container(),
            
            _isLongPress?IconButton(
              icon: Icon(Icons.delete_forever,color: Colors.white,),
            ):Container(),
            
          ],
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('mobile').snapshots(),
          builder: (context, snapshot) {
            List<QueryDocumentSnapshot> _doc = snapshot.data.docs;
            return ListView.builder(
              itemCount: _doc.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    ListTile(
                      onLongPress: () {
                        setState(() {
                          _isLongPress = !_isLongPress;
                        });
                        print('$_isLongPress');
                      },
                      trailing: Text('${_doc[index]['price']}'),
                      title: Text(_doc[index]['model']),
                      leading: _isLongPress
                          ? Icon(
                              Icons.check_circle_outline_outlined,
                              color: Colors.greenAccent,
                            )
                          : null,
                    ),
                    Divider(
                      thickness: 2.0,
                    )
                  ],
                );
              },
            );
          },
        ));
  }
}
