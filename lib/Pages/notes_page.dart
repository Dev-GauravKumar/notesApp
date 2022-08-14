import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notes/Database/notes_database.dart';
import 'package:notes/Model/note.dart';
import 'package:notes/Pages/add_edit_note.dart';
import 'package:notes/Widgets/searchButton.dart';

class NotesPage extends StatefulWidget {
   const NotesPage({Key? key}) : super(key: key);

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late bool isDark;
  late List<Note> notes;
  late Note? note;
  bool isLoading = false;
  bool isSelected = false;
  List<Note> selectedItem = [];
  @override
  void initState() {
    super.initState();
    refreshNotes();
  }

  @override
  void dispose() {
    NotesDatabase.instance.close();
    super.dispose();
  }
  Future refreshNotes() async {
    setState(
      () => isLoading = true,
    );
    notes = await NotesDatabase.instance.readAllNotes();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final Brightness brightness=MediaQuery.of(context).platformBrightness;
    isDark=brightness==Brightness.dark;
    return WillPopScope(
      onWillPop: () => backButtonPressed(),
      child: Scaffold(
        backgroundColor: isDark?Theme.of(context).scaffoldBackgroundColor:Color.fromRGBO(220, 220, 220, 1),
        appBar: AppBar(
          backgroundColor: isDark?Theme.of(context).primaryColorDark:Theme.of(context).primaryColorLight,
          title: isSelected
              ? Text('${selectedItem.length} Items Selected')
              : const Text('Notes'),
          actions: isSelected
              ? <Widget>[
                  IconButton(
                    onPressed: () async {
                      await deleteNotes();
                    },
                    icon: const Icon(Icons.delete),
                  ),
                ]
              : [
                  IconButton(
                    onPressed: ()async {
                      note= await showSearch(
                      context: context,
                      delegate: search_button(searchItems: notes),
                    );
                      note!=null
                          ?await Navigator.push(context, MaterialPageRoute(builder: (context)=>addEditNote( type: note!.type,
                        note: note,))):null;
                      refreshNotes();
                    },
                    icon: const Icon(Icons.search),
                  )
                ],
        ),
        body: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : notes.isEmpty
                  ? const Text('No Notes')
                  : buildNotesList(),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: isDark?Theme.of(context).floatingActionButtonTheme.backgroundColor:Theme.of(context).primaryColorLight,
            child: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  backgroundColor: isDark?Theme.of(context).canvasColor:Colors.white,
                  title: Text('ADD'),
                  content: Container(
                    height: 100,
                    width: 100,
                    child: ListView(
                      children: [
                        ListTile(
                          leading: Icon(Icons.sticky_note_2_rounded,color: isDark?Theme.of(context).floatingActionButtonTheme.backgroundColor:Theme.of(context).primaryColorLight,),
                          title: Text('Text'),
                          onTap: () async {
                            await Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>addEditNote(type: 'standard')), (route) => route.isFirst);
                            refreshNotes();
                          },
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        ListTile(
                          leading: Icon(Icons.check_box,color: isDark?Theme.of(context).floatingActionButtonTheme.backgroundColor:Theme.of(context).primaryColorLight,),
                          title: Text('List'),
                          onTap: () async {
                            await Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>addEditNote(type: 'list')), (route) => route.isFirst);
                            refreshNotes();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
        ),
      ),
    );
  }

  Widget buildNotesList() {
    return ListView.separated(
        itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                  selectedColor: Colors.black,
                  trailing: isSelected
                      ? selectedItem.contains(notes[index])
                          ? Icon(
                              Icons.check_circle,
                              color: Colors.yellow,
                            )
                          : Icon(Icons.circle)
                      : SizedBox(
                          width: 0,
                          height: 0,
                        ),
                  selected: isSelected
                      ? selectedItem.contains(notes[index])
                          ? true
                          : false
                      : false,
                  selectedTileColor: Colors.black12,
                  minVerticalPadding: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  tileColor: isDark?Theme.of(context).canvasColor:Colors.white,
                  onTap: isSelected
                      ? () => setState(() {
                            selectItem(notes[index]);
                          })
                      : () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => addEditNote(
                                type: notes[index].type,
                                note: notes[index],
                              ),
                            ),
                          );
                          refreshNotes();
                        },
                  onLongPress: () {
                    setState(() {
                      isSelected = true;
                    });
                  },
                  title: notes[index].title == ''
                      ? notes[index].description.contains('\n')
                          ? Text(
                              notes[index].description.substring(
                                  0, notes[index].description.indexOf('\n')),
                              overflow: TextOverflow.ellipsis,
                            )
                          : Text(
                              notes[index].description,
                              overflow: TextOverflow.ellipsis,
                            )
                      : Text(
                          notes[index].title,
                          overflow: TextOverflow.ellipsis,
                        ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      notes[index].description == ''
                          ? SizedBox()
                          : notes[index].title == ''
                              ? notes[index].description.contains('\n')
                                  ? notes[index].description.indexOf('\n') !=
                                          notes[index].description.length - 1
                                      ? notes[index]
                                                  .description
                                                  .indexOf('\n') !=
                                              notes[index]
                                                  .description
                                                  .lastIndexOf('\n')
                                          ? Text(
                                              notes[index].description.substring(
                                                  notes[index]
                                                          .description
                                                          .indexOf('\n') +
                                                      1,
                                                  notes[index]
                                                      .description
                                                      .indexOf(
                                                          '\n',
                                                          notes[index]
                                                                  .description
                                                                  .indexOf(
                                                                      '\n') +
                                                              1)),
                                              overflow: TextOverflow.ellipsis,
                                            )
                                          : Text(notes[index]
                                              .description
                                              .substring(
                                                  notes[index]
                                                          .description
                                                          .indexOf('\n') +
                                                      1,
                                                  notes[index]
                                                      .description
                                                      .length)
                                              .replaceAll('\n', ' '))
                                      : SizedBox()
                                  : SizedBox()
                              : notes[index].description.contains('\n')
                                  ? Text(
                                      notes[index].description.substring(
                                          0,
                                          notes[index]
                                              .description
                                              .indexOf('\n')),
                                      overflow: TextOverflow.ellipsis)
                                  : Text(
                                      notes[index].description,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                      notes[index].createdTime.day == DateTime.now().day &&
                              notes[index].createdTime.month ==
                                  DateTime.now().month &&
                              notes[index].createdTime.year ==
                                  DateTime.now().year
                          ? Text(
                              '\n${notes[index].createdTime.hour > 12 ? notes[index].createdTime.hour - 12 : notes[index].createdTime.hour}:${notes[index].createdTime.minute} ${notes[index].createdTime.hour > 12 ? 'PM' : 'AM'}',
                            )
                          : Text(
                              '\n${notes[index].createdTime.day}/${notes[index].createdTime.month}/${notes[index].createdTime.year}',
                            ),
                    ],
                  )),
            ),
        separatorBuilder: (context, index) => const SizedBox(),
        itemCount: notes.length);
  }

  selectItem(Note note) {
    selectedItem.contains(note)
        ? selectedItem.remove(note)
        : selectedItem.add(note);
  }

  backButtonPressed() {
    isSelected==true?setState(() {
      isSelected = false;
      selectedItem.clear();
    }):SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }

  deleteNotes() {
    if (selectedItem.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('No Item Selected !'),
      ));
      return;
    }
    selectedItem.forEach((element) {
      NotesDatabase.instance.delete(element.id!);
    });
    selectedItem.clear();
    refreshNotes();
    setState(
      () => isSelected = false,
    );
  }
}
