import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

final bucketGlobal = PageStorageBucket();

class ViewPost extends StatefulWidget {
  const ViewPost({Key? key}) : super(key: key);

  @override
  _ViewPostState createState() => _ViewPostState();
}

class _ViewPostState extends State<ViewPost>
    with AutomaticKeepAliveClientMixin<ViewPost> {
  Future<List<ParseObject>>? myFuture;
  int postAmount = 8;

  Future<List<ParseObject>> getPost() async {
    QueryBuilder<ParseObject> queryPost = QueryBuilder<ParseObject>(
      ParseObject('Post'),
    )
      ..orderByAscending('createdAt')
      ..setLimit(postAmount);
    final ParseResponse apiResponse = await queryPost.query();

    if (apiResponse.success && apiResponse.results != null) {
      return apiResponse.results as List<ParseObject>;
    } else {
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    // initialize();
    myFuture = getPost();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PageStorage(
      bucket: bucketGlobal,
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Expanded(
                child: FutureBuilder<List<ParseObject>>(
                    future: myFuture,
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        default:
                          if (snapshot.hasError) {
                            return Center(
                              child: Text("Error..."),
                            );
                          }
                          if (!snapshot.hasData) {
                            return Center(
                              child: Text("No post..."),
                            );
                          } else {
                            return RefreshIndicator(
                              onRefresh: _handleRefresh,
                              child: ListView.builder(
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  final getPost = snapshot.data![index];

                                  final post = getPost.get('post');

                                  return (post != null)
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Text(
                                                      '$post',
                                                      style: TextStyle(
                                                        wordSpacing: 1,
                                                        overflow:
                                                            TextOverflow.clip,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Divider(
                                              color: Colors.grey.shade400,
                                            ),
                                          ],
                                        )
                                      : Container();
                                },
                              ),
                            );
                          }
                      }
                    }))
          ],
        ),
      ),
    );
  }

  Future<Null> _handleRefresh() async {
    await Future.delayed(Duration(seconds: 3)).then((_) {
      setState(() {
        myFuture = getPost();
      });
      return null;
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
