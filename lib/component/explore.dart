import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../models/book.dart';

class ExploreView extends StatefulWidget {
  const ExploreView({super.key});

  @override
  State<ExploreView> createState() => _ExploreState();
}

class _ExploreState extends State<ExploreView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Explore")),
      body: Column(children: [_buildSearchBar(), _buildViewCard()]),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: SearchAnchor(
        builder: (BuildContext context, SearchController controller) {
          return SearchBar(
            padding: WidgetStatePropertyAll(
              EdgeInsetsDirectional.symmetric(horizontal: 20),
            ),
            controller: controller,
            onTap: () {
              controller.openView();
            },
            onChanged: (_) {
              controller.openView();
            },
            leading: Icon(Icons.search),
          );
        },
        suggestionsBuilder: (
          BuildContext context,
          SearchController controller,
        ) {
          return List<ListTile>.generate(5, (int index) {
            final String item = 'item $index';
            return ListTile(
              title: Text(item),
              onTap: () {
                setState(() {
                  controller.closeView(item);
                });
              },
            );
          });
        },
      ),
    );
  }

  Widget _buildViewCard() {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 28.0),
        itemCount: books.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.only(bottom: 16.0), // spacing between cards
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Image.asset(
                    books[index].image,
                    width: 130,
                    height: 190,
                    fit: BoxFit.fill,
                  ),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 190,
                        child: Text(
                          books[index].title,
                          style: TextStyle(
                            fontFamily: 'Circular',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text("Author", style: TextStyle(fontFamily: 'Circular')),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Icon(Icons.favorite_border_rounded),
                          Text("1.2K"),
                          SizedBox(width: 7),
                          Icon(Icons.remove_red_eye_outlined),
                          Text("1.2K"),
                        ],
                      ),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              minimumSize: Size(40, 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.0),
                                ),
                              ),
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                            ),
                            child: Text(
                              "Read",
                              style: TextStyle(fontFamily: 'Circular'),
                            ),
                          ),
                          SizedBox(width: 15),
                          Icon(Icons.bookmark_border_outlined),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
