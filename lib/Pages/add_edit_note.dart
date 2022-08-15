import 'package:flutter/material.dart';
import 'package:notes/Database/notes_database.dart';
import 'package:notes/Model/note.dart';

class addEditNote extends StatefulWidget {
  final Note? note;
  final String type;
  const addEditNote({required this.type, Key? key, this.note})
      : super(key: key);

  @override
  State<addEditNote> createState() => _addEditNoteState();
}

class _addEditNoteState extends State<addEditNote> {
  late bool isDark;
  late List<bool> _value = [];
  late List<String>? conversion = [];
  late String title;
  late String description;
  late String state;
  bool isTyping = false;
  late List<String>? list = [];
  @override
  void initState() {
    super.initState();
    title = widget.note?.title ?? '';
    widget.type!='list'?description = widget.note?.description ?? '':description='';
    widget.note != null ? list = widget.note?.description.split('\n') : null;
    widget.note != null ? conversion = widget.note?.state!.split(',') : null;
    conversion != null
        ? _value = conversion!
            .map(
              (e) => e == 'true',
            )
            .toList()
        : null;
  }

  @override
  Widget build(BuildContext context) {
    final Brightness brightness=MediaQuery.of(context).platformBrightness;
    isDark=brightness==Brightness.dark;
    return WillPopScope(
      onWillPop: () => onBackPressed(),
      child: Scaffold(
        backgroundColor: isDark?Theme.of(context).canvasColor:Colors.white,
        appBar: AppBar(
          title: widget.note!=null?Text(widget.note!.title,overflow: TextOverflow.ellipsis,):const Text('Add Note'),
          backgroundColor: isDark?Theme.of(context).primaryColorDark:Theme.of(context).primaryColorLight,
          actions: [
            widget.note != null
                ? IconButton(
                    onPressed: () async {
                      await deleteNote(widget.note!);
                    },
                    icon: const Icon(Icons.delete))
                : const SizedBox(),
            buildButton(),
          ],
        ),
        body: widget.type == 'standard' ? buildStandard() : buildList(),
        floatingActionButton: widget.type == 'list'
            ? FloatingActionButton(
          backgroundColor: isDark?Theme.of(context).floatingActionButtonTheme.backgroundColor:Theme.of(context).primaryColorLight,
                child: const Icon(Icons.add), onPressed: () {
          FocusManager.instance.primaryFocus?.unfocus();
                  addItems();
                })
            : null,
      ),
    );
  }

  void addItem() {
    list!.add(description);
    description = '';
    _value.add(false);
    setState(() {});
  }

  Future addItems() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark?Theme.of(context).canvasColor:Colors.white,
        title: const Text('ADD ITEM'),
        content: TextFormField(
            onTap: () => isTyping = true,
            maxLines: 1,
            autocorrect: true,
            style: const TextStyle(
              fontSize: 20,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Type here',
            ),
            onChanged: (value) => description = value),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel',style: TextStyle(color: isDark?Colors.black:Colors.blue),)),
          TextButton(
              onPressed: () {
                description.isEmpty ? null : addItem();
                Navigator.pop(context);
              },
              child: Text('Ok',style: TextStyle(color: isDark?Colors.black:Colors.blue),)),
        ],
      ),
    );
  }

  Widget buildStandard() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextFormField(
            onTap: () => setState(
              () => isTyping = true,
            ),
            maxLines: 1,
            autocorrect: true,
            style: const TextStyle(
              fontSize: 25,
            ),
            initialValue: title,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Title',
            ),
            onChanged: (title) => setState(() => this.title = title),
          ),
          Expanded(
            child: TextFormField(
              onTap: () => setState(
                () => isTyping = true,
              ),
              maxLines: 500,
              cursorColor: Colors.black,
              textInputAction: TextInputAction.newline,
              autocorrect: true,
              initialValue: description,
              style: const TextStyle(
                fontSize: 15,
              ),
              onChanged: (description) =>
                  setState(() => this.description = description),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Type Something Here...',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildList() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          TextFormField(
            onTap: () => setState(
              () => isTyping = true,
            ),
            maxLines: 1,
            autocorrect: true,
            style: const TextStyle(
              fontSize: 25,
            ),
            initialValue: title,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'Title',
            ),
            onChanged: (title) => setState(() => this.title = title),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: ListView.builder(
                itemCount: list!.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    activeColor: isDark?Theme.of(context).floatingActionButtonTheme.backgroundColor:Theme.of(context).primaryColorLight,
                      controlAffinity: ListTileControlAffinity.leading,
                      checkColor: Colors.white,
                      value: _value[index],
                      onChanged: (value) => setState(() {
                            _value[index] = value!;
                            isTyping = true;
                          }),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          list![index].isEmpty
                              ? const SizedBox()
                              : Expanded(
                                child: Text(
                                    list![index],
                                    style: TextStyle(
                                        decoration: _value[index]
                                            ? TextDecoration.lineThrough
                                            : TextDecoration.none),
                                  ),
                              ),
                          IconButton(
                              onPressed: () => setState(() {
                                    list!.remove(list![index]);
                                    _value.remove(_value[index]);
                                  }),
                              icon: const Icon(Icons.close)),
                        ],
                      ));
                }),
          ),
        ],
      ),
    );
  }

  onBackPressed() {
    widget.type == 'list' ? description = list!.join('\n') : null;
    widget.type == 'list' ? state = _value.join(',') : null;
    title.isEmpty && description.isEmpty
        ? Navigator.canPop(context)
        : addOrUpdate();
    Navigator.of(context).pop();
  }

  Widget buildButton() {
    return isTyping
        ? IconButton(
            onPressed: () {
              widget.type == 'list' ? description = list!.join('\n') : null;
              widget.type == 'list' ? state = _value.join(',') : null;
              title.isEmpty && description.isEmpty
                  ? Navigator.canPop(context)
                  : addOrUpdate();
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.check))
        : Container();
  }

  void addOrUpdate() async {
    widget.note == null ? await addNote() : await updateNote();
  }

  Future addNote() async {
    final note = Note(
        title: title,
        description: description,
        createdTime: DateTime.now(),
        type: widget.type,
        state: widget.type == 'list' ? state : '');
    await NotesDatabase.instance.create(note);
  }

  Future updateNote() async {
    final note = widget.note!.copy(
      title: title,
      description: description,
      type: widget.type,
      state: widget.type == 'list' ? state : '',
    );
    await NotesDatabase.instance.update(note);
  }

  deleteNote(Note note) async {
    bool isDeleted = false;
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: isDark?Theme.of(context).canvasColor:Colors.white,
          title: const Center(child: Text('Delete Note')),
              content: const Padding(
                padding: EdgeInsets.only(left: 50),
                child: Text('Delete This Note?'),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FloatingActionButton.extended(
                        backgroundColor: isDark?Colors.black38:Colors.grey,
                        label: const Text('Cancel'),
                        onPressed: () async {
                          Navigator.pop(context);
                        }),
                    FloatingActionButton.extended(
                        backgroundColor: isDark?Theme.of(context).floatingActionButtonTheme.backgroundColor:Theme.of(context).primaryColorLight,
                        label: const Text('Delete'),
                        onPressed: () async {
                          await NotesDatabase.instance.delete(note.id!);
                          isDeleted = true;
                          Navigator.pop(context);
                        }),
                  ],
                )
              ],
            ));
    isDeleted ? Navigator.of(context).pop() : null;
  }
}
