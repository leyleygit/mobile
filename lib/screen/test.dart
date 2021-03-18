import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TestFirestore extends StatefulWidget {
  @override
  _TestFirestoreState createState() => _TestFirestoreState();
}

//long press to edit mode
bool _isEditMod = false;
//variable list save id
List<String> _productID = [];
CollectionReference _colRef = FirebaseFirestore.instance.collection('mobile');

class _TestFirestoreState extends State<TestFirestore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _colRef.add({'brand': 'sony', 'model': 'xnxx', 'price': '500'});
          },
        ),
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: _isEditMod
              ? IconButton(
                  icon: Icon(Icons.clear_rounded),
                  onPressed: () {
                    setState(() {
                      _isEditMod = false;
                      print(_isEditMod);
                      _productID = [];
                    });
                  },
                )
              : null,
          title: Text('Cloud Firestore'),
          centerTitle: true,
          backgroundColor: Colors.orange[300],
          actions: [
            _isEditMod
                ? _productID.length > 1
                    ? Container()
                    : IconButton(
                        icon: Icon(
                          Icons.edit_outlined,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _isEditMod = false;
                          });
                        },
                      )
                : Container(),
            _isEditMod
                ? IconButton(
                    onPressed: () {
                      _productID.forEach((docID) {
                        _colRef.doc(docID).delete();
                      });
                    },
                    icon: Icon(
                      Icons.delete_forever,
                      color: Colors.white,
                    ),
                  )
                : Container(),
          ],
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('mobile').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              print('No data');
            } else if (snapshot.hasData) {
              var docD = snapshot.data.docs;
              return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      ListTile(
                        onLongPress: _isEditMod == true
                            ? null
                            : () {
                                setState(() {
                                  _isEditMod = true;
                                  print('$_isEditMod');
                                  if (_productID.contains(docD[index].id)) {
                                    print(_productID);
                                    _productID.remove(docD[index].id);
                                  } else {
                                    _productID.add(docD[index].id);
                                  }
                                });
                                print(_productID);
                              },
                        trailing: Text(
                          '${docD[index]['price']} \$',
                          style: TextStyle(color: Colors.green),
                        ),
                        title: Text(docD[index]['model']),
                        leading: _isEditMod
                            ? _productID.contains(docD[index].id)
                                ? Icon(
                                    Icons.check_circle,
                                    color: Colors.greenAccent,
                                  )
                                : Icon(
                                    Icons.circle,
                                    color: Colors.grey,
                                  )
                            : null,
                        onTap: () {
                          setState(() {
                            if (_isEditMod == true) {
                              if (_productID.contains(docD[index].id)) {
                                _productID.remove(docD[index].id);
                                if (_productID.length == 0) {
                                  _isEditMod = false;
                                } else {
                                  _productID.remove(docD[index].id);
                                }
                              } else {
                                _productID.add(docD[index].id);
                              }
                            }
                            print('ProductID: $_productID');
                          });
                        },
                      ),
                      Divider(
                        thickness: 2.0,
                      )
                    ],
                  );
                },
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }
}
