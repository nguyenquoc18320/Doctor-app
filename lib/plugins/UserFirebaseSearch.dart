import 'package:doctor_app/models/userFirebase.dart';
import 'package:doctor_app/screens/user/Chat.dart';
import 'package:flutter/material.dart';
import '../services/database.dart';

class UserFirebaseSearch extends SearchDelegate<UserFirebase?> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions

    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
          } else {
            query = '';
            showSuggestions(context);
          }
        },
      )
    ];
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    // TODO: implement appBarTheme
    return super.appBarTheme(context).copyWith(
          appBarTheme: AppBarTheme(
              elevation: 0.5,
              backgroundColor: Color(0xffffffff),
              foregroundColor: Colors.black),
        );
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading

    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
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

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<UserFirebase>>(
        future: DatabaseMethod.searchUsersFirebase(query),
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

  Widget buildSuggestionsSuccess(List<UserFirebase> suggestions) {
    return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];
          final queryText = suggestion.name.substring(0, query.length);
          final remainingText = suggestion.name.substring(query.length);

          return ListTile(
            onTap: () {
              query = suggestion.name;
              //close(context, suggestion);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          ResultUser(receiver: suggestion)));
            },
            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            leading: CircleAvatar(
              radius: 24.0,
              backgroundImage: NetworkImage(suggestion.avatar_url),
            ),
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
            subtitle: Text(suggestion.email),
          );
        });
  }

  Widget buildNoSuggestions() {
    return Center(
      child: Text(
        'No User Found',
        style: TextStyle(
            color: Colors.grey, fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
