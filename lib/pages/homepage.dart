import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sheets/services/firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _ReadState();
}

class _ReadState extends State<HomePage> {
  final FireStoreServices fireStoreService = FireStoreServices();

  final TextEditingController textEditingController = TextEditingController();

  void openNoteBox({String? docId}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: TextField(
              controller: textEditingController,
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    if (docId == null) {
                      fireStoreService.addNotes(textEditingController.text);
                    } else {
                      fireStoreService.updateNote(
                          docId, textEditingController.text);
                    }

                    textEditingController.clear();
                    Navigator.pop(context);
                  },
                  child: Text("Add"))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("NOTES"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openNoteBox,
        child: Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: fireStoreService.getNotesStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List notesList = snapshot.data!.docs;
            return ListView.builder(
                itemCount: notesList.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot document = notesList[index];
                  String docId = document.id;
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                  String noteText = data["notes"];
                  return ListTile(
                    title: Text(noteText),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () => openNoteBox(docId: docId),
                          icon: Icon(Icons.settings),
                        ),
                        IconButton(
                          onPressed: () => fireStoreService.deleteNote(docId),
                          icon: Icon(Icons.delete),
                        )
                      ],
                    ),
                  );
                });
          } else {
            return Center(
              child: Text("No Data"),
            );
          }
        },
      ),
    );
  }
}


