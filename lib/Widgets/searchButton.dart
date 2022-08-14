import 'package:flutter/material.dart';
import 'package:notes/Model/note.dart';

class search_button extends SearchDelegate<Note> {
  List<Note> searchItems;
  search_button({required this.searchItems});
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.close),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    var suggetions = searchItems
        .where((element) =>
            element.title.toLowerCase().contains(query.toLowerCase()) ||
            element.description.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView.builder(
        itemCount: suggetions.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
            tileColor: Colors.white,
            title: suggetions[index].title == ''
                ? suggetions[index].description.contains('\n')
                ? Text(
              suggetions[index].description.substring(0,
                  suggetions[index].description.indexOf('\n')),
              overflow: TextOverflow.ellipsis,
            )
                : Text(
              suggetions[index].description,
              overflow: TextOverflow.ellipsis,
            )
                : Text(
              suggetions[index].title,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                suggetions[index].description == ''
                    ? SizedBox()
                    : suggetions[index].title == ''
                    ? suggetions[index].description.contains('\n')
                    ? suggetions[index]
                    .description
                    .indexOf('\n') !=
                    suggetions[index].description.length -
                        1
                    ? suggetions[index]
                    .description
                    .indexOf('\n') !=
                    suggetions[index]
                        .description
                        .lastIndexOf('\n')
                    ? Text(
                  suggetions[index]
                      .description
                      .substring(
                      suggetions[index]
                          .description
                          .indexOf('\n') +
                          1,
                      suggetions[index]
                          .description
                          .indexOf(
                          '\n',
                          suggetions[index]
                              .description
                              .indexOf(
                              '\n') +
                              1)),
                  overflow: TextOverflow.ellipsis,
                )
                    : Text(suggetions[index]
                    .description
                    .substring(
                    suggetions[index]
                        .description
                        .indexOf('\n') +
                        1,
                    suggetions[index]
                        .description
                        .length)
                    .replaceAll('\n', ' '))
                    : SizedBox()
                    : SizedBox()
                    : suggetions[index].description.contains('\n')
                    ? Text(
                    suggetions[index].description.substring(
                        0,
                        suggetions[index]
                            .description
                            .indexOf('\n')),
                    overflow: TextOverflow.ellipsis)
                    : Text(
                  suggetions[index].description,
                  overflow: TextOverflow.ellipsis,
                ),
                suggetions[index].createdTime.day == DateTime.now().day &&
                    suggetions[index].createdTime.month ==
                        DateTime.now().month &&
                    suggetions[index].createdTime.year ==
                        DateTime.now().year
                    ? Text(
                  '\n${suggetions[index].createdTime.hour > 12 ? suggetions[index].createdTime.hour - 12 : suggetions[index].createdTime.hour}:${suggetions[index].createdTime.minute} ${suggetions[index].createdTime.hour > 12 ? 'PM' : 'AM'}',
                )
                    : Text(
                  '\n${suggetions[index].createdTime.day}/${suggetions[index].createdTime.month}/${suggetions[index].createdTime.year}',
                ),
              ],
            ),
            onTap: () {
              close(context, suggetions[index]);
            },
          ),
        ));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var suggetions = searchItems
        .where((element) =>
            element.title.toLowerCase().contains(query.toLowerCase()) ||
            element.description.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return Scaffold(
      backgroundColor: Color.fromRGBO(220, 220, 220, 1),
      body: ListView.builder(
          itemCount: suggetions.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              tileColor: Colors.white,
              title: suggetions[index].title == ''
                  ? suggetions[index].description.contains('\n')
                      ? Text(
                          suggetions[index].description.substring(0,
                              suggetions[index].description.indexOf('\n')),
                          overflow: TextOverflow.ellipsis,
                        )
                      : Text(
                          suggetions[index].description,
                          overflow: TextOverflow.ellipsis,
                        )
                  : Text(
                      suggetions[index].title,
                      overflow: TextOverflow.ellipsis,
                    ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  suggetions[index].description == ''
                      ? SizedBox()
                      : suggetions[index].title == ''
                          ? suggetions[index].description.contains('\n')
                              ? suggetions[index]
                                          .description
                                          .indexOf('\n') !=
                                      suggetions[index].description.length -
                                          1
                                  ? suggetions[index]
                                              .description
                                              .indexOf('\n') !=
                                          suggetions[index]
                                              .description
                                              .lastIndexOf('\n')
                                      ? Text(
                                          suggetions[index]
                                              .description
                                              .substring(
                                                  suggetions[index]
                                                          .description
                                                          .indexOf('\n') +
                                                      1,
                                                  suggetions[index]
                                                      .description
                                                      .indexOf(
                                                          '\n',
                                                          suggetions[index]
                                                                  .description
                                                                  .indexOf(
                                                                      '\n') +
                                                              1)),
                                          overflow: TextOverflow.ellipsis,
                                        )
                                      : Text(suggetions[index]
                                          .description
                                          .substring(
                                              suggetions[index]
                                                      .description
                                                      .indexOf('\n') +
                                                  1,
                                              suggetions[index]
                                                  .description
                                                  .length)
                                          .replaceAll('\n', ' '))
                                  : SizedBox()
                              : SizedBox()
                          : suggetions[index].description.contains('\n')
                              ? Text(
                                  suggetions[index].description.substring(
                                      0,
                                      suggetions[index]
                                          .description
                                          .indexOf('\n')),
                                  overflow: TextOverflow.ellipsis)
                              : Text(
                                  suggetions[index].description,
                                  overflow: TextOverflow.ellipsis,
                                ),
                  suggetions[index].createdTime.day == DateTime.now().day &&
                          suggetions[index].createdTime.month ==
                              DateTime.now().month &&
                          suggetions[index].createdTime.year ==
                              DateTime.now().year
                      ? Text(
                          '\n${suggetions[index].createdTime.hour > 12 ? suggetions[index].createdTime.hour - 12 : suggetions[index].createdTime.hour}:${suggetions[index].createdTime.minute} ${suggetions[index].createdTime.hour > 12 ? 'PM' : 'AM'}',
                        )
                      : Text(
                          '\n${suggetions[index].createdTime.day}/${suggetions[index].createdTime.month}/${suggetions[index].createdTime.year}',
                        ),
                ],
              ),
              onTap: () {
                close(context, suggetions[index]);
              },
            ),
          )),
    );
  }
}
