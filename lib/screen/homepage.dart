import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mobile/screen/addproduct.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

bool _isEdit = false;
List<String> _selectedID = [];
CollectionReference colRe = FirebaseFirestore.instance.collection('mobile');

class _HomePageState extends State<HomePage> {
  _handelRemove() {
    _selectedID.forEach((val) {
      colRe.doc(val).delete();
    });
    setState(() {
      _isEdit = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    //Size size = MediaQuery.of(context).size;
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            size: 40,
          ),
          backgroundColor: Colors.orange[400],
          tooltip: 'បន្ថែមទូរស័ព្ទ?',
          onPressed: () {
            setState(() {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddProduct()));
            });
          },
        ),
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.orange,
          centerTitle: true,
          title: Text("HomePage"),
          actions: [
            _isEdit
                ? !(_selectedID.length > 1)
                    ? IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (contex) {
                            return AddProduct(
                              docID: _selectedID[0],
                            );
                          }));
                        },
                      )
                    : Container()
                : Container(),
            _isEdit
                ? IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _handelRemove();
                    },
                  )
                : Container(),
          ],
          leading: _isEdit
              ? IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      _isEdit = false;
                      _selectedID = [];
                    });

                    print('isEdit: $_isEdit');
                  },
                )
              : null,
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('mobile').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Text(
                  'no data',
                  style: TextStyle(color: Colors.white, fontSize: 30.0),
                ),
              );
            } else {
              var _doc = snapshot.data.docs;
              return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  String idDoc = snapshot.data.docs[index].id;
                  return Column(
                    children: [
                      ListTile(
                        leading: _isEdit
                            ? _selectedID.contains(idDoc)
                                ? Icon(Icons.check_circle, color: Colors.green)
                                : Icon(Icons.circle, color: Colors.grey)
                            : null,
                        onLongPress: () {
                          if (_selectedID.contains(idDoc)) {
                            print('selectedID: $_selectedID');
                          } else {
                            setState(() {
                              _isEdit = true;
                              _selectedID.add(idDoc);
                            });
                          }

                          print('isEdit: $_isEdit');
                          print('selectedID: $_selectedID');
                        },
                        onTap: () {
                          if (_isEdit == false) {
                            print('selectedID: $_selectedID');
                          } else {
                            if (_selectedID.contains(idDoc)) {
                              setState(() {
                                _selectedID.remove(idDoc);
                                print('selectedID: $_selectedID');
                                if (_selectedID.length < 1) {
                                  _isEdit = false;
                                } else {
                                  _selectedID.remove(idDoc);
                                }
                              });
                            } else {
                              setState(() {
                                _selectedID.add(idDoc);
                              });
                            }
                          }

                          print('selectedID: $_selectedID');
                        },
                        title: Text(_doc[index]['model']),
                        //DOCID['keyname']
                        trailing: Text(
                          '${_doc[index]['price']} \$',
                          style: TextStyle(
                            color: Colors.green[600],
                            fontSize: 17,
                          ),
                        ),
                      ),
                      Divider(
                        indent: 10,
                        endIndent: 10,
                        thickness: 1.0,
                        color: Colors.grey[800],
                      )
                    ],
                  );
                },
              );
            }
          },
        ));
  }
}
