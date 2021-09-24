import 'package:aquabuildr/Fish%20Home/available_aquabuildr_fish_list_view_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class DataSearch extends SearchDelegate<AquabuildrFishViewModel> {
  final List<AquabuildrFishViewModel> aquabuildrfishes;
  AquabuildrFishViewModel result;

  DataSearch(this.aquabuildrfishes);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    //Show some result based on the selection

    final suggestionList = query.isEmpty
        ? aquabuildrfishes
        : aquabuildrfishes
            .where((fish) =>
                fish.species.toLowerCase().contains(query.toLowerCase()))
            .toList();

    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
      //  selectedTileColor: Colors.red,
        onTap: () {
          print("on Tap clicked in build results = ");
          print("index clicked = " + index.toString());
          print("fish clicked = " + suggestionList[index].species);
          //showResults(context);
          result = suggestionList[index];
          close(context, result);
        },
        //leading: Icon(Icons.location_city),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: CachedNetworkImage(
              imageUrl: suggestionList[index].photoURL,
              height: 100,
              width: 100,
              fit: BoxFit.scaleDown),
        ),
        title: RichText(
          text: TextSpan(
              text: suggestionList[index].species.substring(0, query.length),
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                    text: suggestionList[index].species.substring(query.length),
                    style: TextStyle(color: Colors.grey))
              ]),
        ),
      ),
      itemCount: suggestionList.length,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //Show when someone searches for something

    final suggestionList = query.isEmpty
        ? aquabuildrfishes
        : aquabuildrfishes
            .where((fish) =>
                fish.species.toLowerCase().contains(query.toLowerCase()))
            .toList();

    return ListView.builder(
    
      itemExtent: 60,
      itemBuilder: (context, index) => ListTile(
        tileColor: Colors.white,
        onTap: () {
          print("on Tap clicked in build suggestions = ");
          print("index clicked = " + index.toString());
          print("fish clicked = " + suggestionList[index].species);
          //showResults(context);
          result = suggestionList[index];
          close(context, result);
        },
        //leading: Icon(Icons.location_city),
        leading: Container(
          //color: Colors.red,
          height: 300,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: CachedNetworkImage(
                imageUrl: suggestionList[index].photoURL,
                height: 100,
                width: 100,
                fit: BoxFit.scaleDown),
          ),
        ),
        title: RichText(
          text: TextSpan(
            children:
                highlightOccurrences(suggestionList[index].species, query),
            style: TextStyle(color: Colors.black54, fontSize: 16, fontWeight: FontWeight.bold,)
          ),
        ),

        // RichText(
        //   text: TextSpan(
        //       text: suggestionList[index].species.substring(0, query.length),
        //       style: TextStyle(
        //         color: Colors.black,
        //         fontWeight: FontWeight.bold,
        //       ),
        //       children: [
        //         TextSpan(
        //             text: suggestionList[index].species.substring(query.length),
        //             style: TextStyle(color: Colors.grey))
        //       ]),
        // ),
      ),
      itemCount: suggestionList.length,
    );
  }

  List<TextSpan> highlightOccurrences(String source, String query) {
    if (query == null || query.isEmpty) {
      return [TextSpan(text: source)];
    }

    var matches = <Match>[];
    for (final token in query.trim().toLowerCase().split(' ')) {
      matches.addAll(token.allMatches(source.toLowerCase()));
    }

    if (matches.isEmpty) {
      return [TextSpan(text: source)];
    }
    matches.sort((a, b) => a.start.compareTo(b.start));

    int lastMatchEnd = 0;
    final List<TextSpan> children = [];
    for (final match in matches) {
      if (match.end <= lastMatchEnd) {
        // already matched -> ignore
      } else if (match.start <= lastMatchEnd) {
        children.add(TextSpan(
          text: source.substring(lastMatchEnd, match.end),
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ));
      } else if (match.start > lastMatchEnd) {
        children.add(TextSpan(
          text: source.substring(lastMatchEnd, match.start),
        ));

        children.add(TextSpan(
          text: source.substring(match.start, match.end),
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ));
      }

      if (lastMatchEnd < match.end) {
        lastMatchEnd = match.end;
      }
    }

    if (lastMatchEnd < source.length) {
      children.add(TextSpan(
        text: source.substring(lastMatchEnd, source.length),
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),

      ));
    }

    return children;
  }
}
