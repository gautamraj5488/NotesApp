import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreServices {
  final CollectionReference notes =
      FirebaseFirestore.instance.collection("notes");
  // Create Data
  Future<void> addNotes(String note) {
    return notes.add({
      "notes": note,
      "timestamp": Timestamp.now(),
    });
  }

  // Read Data
  Stream<QuerySnapshot> getNotesStream() {
    final notesStream =
        notes.orderBy("timestamp", descending: true).snapshots();
    return notesStream;
  }
  // Update Data

  Future<void> updateNote(String docId, String newNote) {
    return notes.doc(docId).update({
      "notes": newNote,
      "timestamp": Timestamp.now(),
    });
  }
  // Delete Data

  Future<void> deleteNote(String docId){
     return notes.doc(docId).delete();
  }
}
