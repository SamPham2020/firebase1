import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async{
  // when we start the application we want it already connected to the cloud
  WidgetsFlutterBinding.ensureInitialized();

  //now mention explicitly the API key at the main call
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: 'AIzaSyDtnti31lMSLqvlhcMW_sb4Q0gb2FqvcZ4',
        appId: '804372131139',
        messagingSenderId: '1:804372131139:android:245549bf10c1c74d4053f6',
        projectId: 'fir-2026demo1'
    ),
  );
  
  runApp(MyApp()); 
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyFSDemo(),
    );
  }
}
class MyFSDemo extends StatefulWidget {
  const MyFSDemo({super.key});

  @override
  State<MyFSDemo> createState() => _MyFSDemoState();
}

class _MyFSDemoState extends State<MyFSDemo> {
  // we are creating database folder that is being referred as users
  // that is being created as Instance (Root of collection/reference)
  // this will create on the cloud
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  String name = '';
  String password = '';
  Future<void> addUser() async {
    if (name.isNotEmpty && password.isNotEmpty) {
      //name arguments {'name': name, 'password' : password}
      await users.add({'name': name, 'password' : password});
      setState(() {
        // once added we want to empty the initial
        name='';
        password='';
      });
    }
  }

  // method to update user
  Future<void> updateUser([String id = '', String newName = '']) async{
    if(newName.isNotEmpty) {
      try{
        await users.doc(id).update({'name' : newName});
      }catch(error){
        print('failed to update');
      }
    }
    else{
      print('enter a valid name');
    }
  }

  // delete method String id on firebase is text string
  Future<void> deleteUser(String id) async {
      await users.doc(id).delete();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FS CRUD'),
      ),
      body: Column(
        children: [
          TextField(
            onChanged: (value) => name = value,
            decoration: InputDecoration(hintText: 'Type your name'),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            onChanged: (value) => password = value,
            decoration: InputDecoration(hintText: 'Type your password'),
            obscureText: true,
          ),
          SizedBox(
            height: 10,
          ),
          ElevatedButton(onPressed: addUser, child: Text('Add user to FS')),
          SizedBox(height: 10,),
          Expanded(
              child: StreamBuilder<QuerySnapshot> (
                stream: users.snapshots(),
                builder: (context, snapshot) {
                  if(!snapshot.hasData) return Text('Loading....');
                  return ListView(
                      children: snapshot.data!.docs.map ((doc) {
                        return ListTile(
                          title: Text(doc['name']),
                          subtitle: Text('Password: ${doc['password']}',),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          String newName = '';
                                          return AlertDialog(
                                            title: Text("Edit User"),
                                            content: TextField(
                                              onChanged: (value) => newName = value,
                                              decoration: InputDecoration(hintText: 'Enter new Name'),
                                            ),
                                            actions: [
                                              ElevatedButton(onPressed: () {
                                                updateUser(doc.id, newName);
                                                Navigator.pop(context);
                                              }, child: Text('Update'))
                                            ],
                                          );
                                        });
                                  },
                                  child: Text("Edit")),
                              TextButton(
                                  onPressed: () => deleteUser(doc.id),
                                  child: Text('Delete'))
                            ],
                          ),
                        );
                      }).toList()
                  );
                },
              ))
        ],
      ),
    );
  }
}
