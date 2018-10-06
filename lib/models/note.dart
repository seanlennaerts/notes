
class Note {
  Note({this.id, this.title, this.doc, this.plainText, this.timeStamp});

  final int id;
  final String title;
  final String doc; //json string doc
  final String plainText; // for searchability
  final DateTime timeStamp;
}
