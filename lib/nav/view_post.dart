import 'package:flutter/material.dart';

import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

import '../model.dart';

final bucketGlobal = PageStorageBucket();

class ListPost extends StatefulWidget {
  const ListPost({Key? key}) : super(key: key);

  @override
  _ListPostState createState() => _ListPostState();
}

class _ListPostState extends State<ListPost> with AutomaticKeepAliveClientMixin<ListPost> {
  late ScrollController _controller;

  List<Post> posts = [];
  int postAmount = 6;
  bool loading = false, allLoaded = false;

  // At the beginning, we fetch the first 20 posts
  int _page = 0;

  // There is next page or not
  bool _hasNextPage = true;

  // Used to display loading indicators when _firstLoad function is running
  bool _isFirstLoadRunning = false;

  // Used to display loading indicators when _loadMore function is running
  bool _isLoadMoreRunning = false;

  Future getPost() async {
    if (allLoaded) {
      return;
    }
    setState(() {
      loading = true;
    });
    QueryBuilder<ParseObject> queryPost = QueryBuilder<ParseObject>(
      ParseObject('Post'),
    )
      ..orderByDescending('createdAt')
      ..setLimit(postAmount)
      ..setAmountToSkip(postAmount);
    final ParseResponse apiResponse = await queryPost.query();

    if (apiResponse.success && apiResponse.results != null) {
      for (final ParseObject t in apiResponse.results!) {
        print('yes');
        Post team = Post(
          post: t.get<String>('post'),
        );
        posts.add(team);
      }
      print('returning');

      loading = false;

      allLoaded = true;
      setState(() {});
      return posts;
    } else {
      print('nothing here');
      return [];
    }
  }

  void getMeMore() async {
    setState(() {
      _isFirstLoadRunning = true;
    });
    QueryBuilder<ParseObject> queryPost = QueryBuilder<ParseObject>(
      ParseObject('Post'),
    );
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.pixels >= _controller.position.maxScrollExtent) {
      setState(() {
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });
      _page += 1;

      queryPost.setAmountToSkip(postAmount);
      queryPost.setLimit(postAmount);
      queryPost.orderByDescending('createdAt');
    }
    final ParseResponse apiResponse = await queryPost.query();

    if (apiResponse.success && apiResponse.results != null) {
      for (final ParseObject t in apiResponse.results!) {
        print('yes');
        Post team = Post(
          post: t.get<String>('post'),
        );
        print('done looping it');
        posts.add(team);
      }
      print('returning');
    } else {
      setState(() {
        _hasNextPage = false;
      });
      print('nothing here');
    }

    setState(() {
      _isLoadMoreRunning = false;
    });
  }

  @override
  @override
  void initState() {
    super.initState();
    getPost();
    _controller = new ScrollController()..addListener(getMeMore);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PageStorage(
      bucket: bucketGlobal,
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            if (posts.isNotEmpty) {
              print('not empty');
              return RefreshIndicator(
                onRefresh: _handleRefresh,
                child: ListView.builder(
                  controller: _controller,
                  physics: const AlwaysScrollableScrollPhysics(),
                  addAutomaticKeepAlives: true,
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final pos = posts[index];
                    return Card(
                      child: ListTile(
                        title: Text(pos.post ?? 'empty'),
                      ),
                    );
                  },
                ),
              );
            } else {
              print('it is empty');
              return Center(child: CircularProgressIndicator(),);
            }
          },
        ),
      ),
    );
  }

  Future<Null> _handleRefresh() async {
    await Future.delayed(Duration(seconds: 3)).then((_) {
      setState(() {
        getPost();
      });
      return null;
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
