
final String tableNotes = 'notes';

class NoteFields{
  static final List<String> values = [id,title,description,time];
  static final String id = '_id';
  static final String title = 'title';
  static final String description = 'description';
  static final String time = 'time';
  static final String type = 'type';
  static final String state = 'state';

}

class Note{
  final int? id;
  final String title;
  final String description;
  final DateTime createdTime;
  final String type;
  final String? state;
  const Note({
    this.id,
    required this.title,
    required this.description,
    required this.createdTime,
    required this.type,
    required this.state
});
  Note copy ({
    int? id,
    bool? isImportant,
    int? number,
    String? title,
    String? description,
    DateTime? createdTime,
    String? type,
    String? state
  })=>Note(state: state??this.state,type: type??this.type,id: id?? this.id ,title: title??this.title, description: description??this.description, createdTime: createdTime??this.createdTime);
  Map<String,Object?> toJson()=>{
    NoteFields.id : id,
    NoteFields.title : title,
    NoteFields.description : description,
    NoteFields.time : createdTime.toIso8601String(),
    NoteFields.type : type,
    NoteFields.state : state,
  };
  static Note fromJson( Map< String, Object?> json)=> Note(
      id: json[NoteFields.id] as int?,
      title: json[NoteFields.title] as String,
      description: json[NoteFields.description] as String,
      createdTime: DateTime.parse(json[NoteFields.time] as String),
      type: json[NoteFields.type] as String,
      state: json[NoteFields.state] as String,
  );
}