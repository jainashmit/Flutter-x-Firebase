import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterfirebase/add_new_task.dart';
import 'package:flutterfirebase/updateTask.dart';
import 'package:flutterfirebase/utils.dart';
import 'package:flutterfirebase/widgets/date_selector.dart';
import 'package:flutterfirebase/widgets/task_card.dart';
import 'package:intl/intl.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 4,
        shadowColor: Colors.white,
        title: const Text('My Tasks' , style: TextStyle(color: Colors.white),),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddNewTask()),
              );
            },
            icon: const Icon(CupertinoIcons.add , color: Colors.white,),
          ),

          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            icon: Icon(Icons.logout , color: Colors.white,),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            const DateSelector(),
            SizedBox(height: 16),
            StreamBuilder(
              stream:
                  FirebaseFirestore.instance
                      .collection("tasks")
                      .where(
                        "creator",
                        isEqualTo: FirebaseAuth.instance.currentUser!.uid,
                      )
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: const CircularProgressIndicator());
                }

                if (!snapshot.hasData) {
                  return const Text(
                    'No Data Found',
                    style: TextStyle(backgroundColor: Colors.black),
                  );
                }

                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        background: Expanded(
                          child: Container(
                            color: Colors.red,
                            child: Center(
                              child: Text(
                                'Swipe Left to Delete',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 24,
                                ),
                              ),
                            ),
                          ),
                        ),
                        key: ValueKey(index),
                        onDismissed: (direction) {
                          if (direction == DismissDirection.endToStart) {
                            FirebaseFirestore.instance
                                .collection("tasks")
                                .doc(snapshot.data!.docs[index].id)
                                .delete();
                          }
                        },
                        child: Row(
                          children: [
                            Expanded(
                              child: TaskCard(
                                color: hexToColor(
                                  snapshot.data!.docs[index].data()["Color"],
                                ),
                                headerText:
                                    snapshot.data!.docs[index].data()['title'],
                                descriptionText:
                                    snapshot.data!.docs[index]
                                        .data()["Description"],
                                scheduledDate: DateFormat(
                                  'dd MMM yyyy, hh:mm a',
                                ).format(
                                  (snapshot.data!.docs[index].data()['Date']
                                          as Timestamp)
                                      .toDate(),
                                ),
                                // snapshot.data!.docs[index].data()['Date'].toString(),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder:
                                        (context) => UpdateTask(
                                          docId: snapshot.data!.docs[index].id,
                                        ),
                                  ),
                                );
                              },
                              icon: Icon(Icons.edit, color: Colors.black),
                            ),
                            // Container(
                            //   height: 10,
                            //   width: 10,
                            //   decoration: BoxDecoration(
                            //     color: strengthenColor(
                            //       const Color.fromRGBO(246, 222, 194, 1),
                            //       0.69,
                            //     ),
                            //     shape: BoxShape.circle,
                            //   ),
                            // ),
                            const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Text(
                                '10:00AM',
                                style: TextStyle(fontSize: 17),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
