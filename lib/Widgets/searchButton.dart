
import 'package:flutter/material.dart';
import 'package:notes/Database/notes_database.dart';
import 'package:notes/Model/note.dart';

class search_button extends SearchDelegate<Note> {
  List<Note> searchItems;
  search_button({required this.searchItems});
  @override
  Future refreshNotes() async {
    searchItems = await NotesDatabase.instance.readAllNotes();
  }
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(onPressed: () {
        query = '';
      }, icon: Icon(Icons.close),),
    ];
  }
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(onPressed: () {
      Navigator.pop(context);
    }, icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    var suggetions=searchItems.where((element) => element.title.toLowerCase().contains(query.toLowerCase())||element.description.toLowerCase().contains(query.toLowerCase())).toList();
    return ListView.builder(
        itemCount: suggetions.length,
        itemBuilder: (context,index)=>ListTile(
          title: Text(suggetions[index].title,overflow: TextOverflow.ellipsis,),
          subtitle: Text(suggetions[index].description,overflow: TextOverflow.ellipsis,),
          onTap: (){
            close(context, suggetions[index]);
          },
        ));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var suggetions=searchItems.where((element) => element.title.toLowerCase().contains(query.toLowerCase())||element.description.toLowerCase().contains(query.toLowerCase())).toList();
    return ListView.builder(
        itemCount: suggetions.length,
        itemBuilder: (context,index)=>ListTile(
          title: Text(suggetions[index].title,overflow: TextOverflow.ellipsis,),
          subtitle: Text(suggetions[index].description,overflow: TextOverflow.ellipsis,),
          onTap: (){
            close(context, suggetions[index]);
          },
        ));
  }
}