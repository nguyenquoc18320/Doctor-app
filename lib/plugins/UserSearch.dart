import 'package:flutter/material.dart';

import '../screens/user/ResultPage.dart';
import '../services/database.dart';

class UserSearch extends SearchDelegate<String> {
  final users = ['Test', 'Test User', 'Hello', 'Hello World', 'Hello See'];

  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions

    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          if (query.isEmpty) {
            close(context, '');
          } else {
            query = '';
            showSuggestions(context);
          }
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading

    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => close(context, ''),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return Center(
      child: Column(children: [
        Icon(Icons.location_city, size: 120),
        SizedBox(
          height: 48,
        ),
        Text(
          query,
          style: TextStyle(fontWeight: FontWeight.bold),
        )
      ]),
    );
  }

  // @override
  // Widget buildSuggestions(BuildContext context) {
  //   final suggestions = query.isEmpty
  //       ? users
  //       : users.where((element) {
  //           final userLower = element.toLowerCase();
  //           final queryLower = query.toLowerCase();
  //           return userLower.startsWith(queryLower);
  //         }).toList();
  //   return buildSuggestionsSuccess(suggestions);
  // }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<String>>(
        future: DatabaseMethod.searchUsers(query),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
            default:
              if (snapshot.hasError || snapshot.data!.isEmpty) {
                return buildNoSuggestions();
              }
              return buildSuggestionsSuccess(snapshot.data!);
          }
        });
  }

  Widget buildSuggestionsSuccess(List<String> suggestions) {
    return ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];
          final queryText = suggestion.substring(0, query.length);
          final remainingText = suggestion.substring(query.length);

          return ListTile(
            onTap: () {
              query = suggestion;
              //close(context, suggestion);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          ResultPage(result: suggestion)));
            },
            leading: Icon(Icons.location_city),
            // title: Text(suggestion),
            title: RichText(
                text: TextSpan(
                    text: queryText,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 18),
                    children: [
                  TextSpan(
                      text: remainingText, style: TextStyle(color: Colors.grey))
                ])),
          );
        });
  }

  Widget buildNoSuggestions() {
    return Center(
      child: Text(
        'Empty Here!',
        style: TextStyle(
            color: Colors.grey, fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
