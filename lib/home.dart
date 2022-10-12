import 'package:bookstore/database/database.dart';
import 'package:bookstore/model/books.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

List<Books> booksList = [];

class _HomeState extends State<Home> {
  TextEditingController bookNameController = TextEditingController();
  TextEditingController authorNameController = TextEditingController();
  TextEditingController coverURLController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              'Book sotre',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
              ),
            ),
          ),
        ),
        body: FutureBuilder<List<Books>>(
          future: BooksProvider.instance.getBooks(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  snapshot.error.toString(),
                ),
              );
            }
            if (snapshot.hasData) {
              booksList = snapshot.data!;
              return ListView.builder(
                shrinkWrap: false,
                itemCount: booksList.length,
                itemBuilder: (context, index) {
                  Books books = booksList[index];
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.grey,
                            ),
                          ),
                          height: 155,
                          width: 125,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              '${books.coverURL}',
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            // height: 220,
                            child: ListTile(
                              title: AutoSizeText(
                                '${books.bookName?.trim()}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 19,
                                ),
                                maxLines: 2,
                              ),
                              subtitle: AutoSizeText(
                                '${books.authorName}',
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              trailing: IconButton(
                                onPressed: () async {
                                  if (books.id != null) {
                                    await BooksProvider.instance
                                        .delete(books.id!);
                                  }
                                  setState(() {});
                                },
                                icon: Icon(
                                  Icons.delete_forever,
                                  size: 45,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
            return Center(
              child: Container(
                height: 100,
                width: 100,
                child: CircularProgressIndicator(),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            size: 40,
          ),
          onPressed: () async {
            bookNameController.clear();
            authorNameController.clear();
            coverURLController.clear();
            await showModalBottomSheet(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40),
                    topLeft: Radius.circular(40)),
              ),
              context: context,
              builder: (BuildContext context) {
                return Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: Container(
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        topLeft: Radius.circular(30),
                      ),
                    ),
                    height: 250,
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextFormField(
                              controller: bookNameController,
                              decoration: InputDecoration(
                                hintText: 'Book Title',
                                hintStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                              ),
                            ),
                            TextFormField(
                              controller: authorNameController,
                              decoration: InputDecoration(
                                hintText: 'Book Author',
                                hintStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                              ),
                            ),
                            TextFormField(
                              controller: coverURLController,
                              decoration: InputDecoration(
                                hintText: 'Book Cover URL',
                                hintStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              height: 40,
                              width: double.infinity,
                              child: RaisedButton(
                                color: Colors.blue,
                                onPressed: () {
                                  setState(() {
                                    BooksProvider.instance.insert(
                                      Books(
                                        bookName: bookNameController.text,
                                        authorName: authorNameController.text,
                                        coverURL: coverURLController.text,
                                      ),
                                    );
                                  });
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'ADD',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
