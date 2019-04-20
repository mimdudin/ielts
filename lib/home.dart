import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Completer<WebViewController> _controller = Completer<WebViewController>();
  // final Set<String> _favorites = Set<String>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[Icon(Icons.home), SizedBox(width: 10), Text('HOME')],
        ),
        // This drop down menu demonstrates that Flutter widgets can be shown over the web view.
        actions: <Widget>[
          NavigationControls(_controller.future),
          // Menu(_controller.future),
        ],
      ),
      body: WebView(
        initialUrl: 'http://ielts.org',
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      ),
      // floatingActionButton: _bookmarkButton(model),
    );
  }

  // _bookmarkButton(MainModel model) {
  //   return FutureBuilder<WebViewController>(
  //     future: _controller.future,
  //     builder:
  //         (BuildContext context, AsyncSnapshot<WebViewController> controller) {
  //       if (controller.hasData) {
  //         return FloatingActionButton(
  //           onPressed: () async {
  //             var url = await controller.data.currentUrl();
  //             model.addBookmarkUrl(url);
  //             Scaffold.of(context).showSnackBar(
  //               SnackBar(
  //                   content: Text(
  //                       '$url ${AppLocalizations.of(context).addedToFav}')),
  //             );
  //           },
  //           child: Icon(Icons.favorite),
  //         );
  //       }
  //       return Container();
  //     },
  //   );
  // }
}

// class Menu extends StatelessWidget {
//   Menu(this._webViewControllerFuture);
//   final Future<WebViewController> _webViewControllerFuture;
//   // TODO(efortuna): Come up with a more elegant solution for an accessor to this than a callback.

//   @override
//   Widget build(BuildContext context) {
//    return FutureBuilder(
//           future: _webViewControllerFuture,
//           builder: (BuildContext context,
//               AsyncSnapshot<WebViewController> controller) {
//             if (!controller.hasData) return Container();
//             return PopupMenuButton<String>(
//               onSelected: (String value) async {
//                 if (value == 'Email link') {
//                   var url = await controller.data.currentUrl();
//                   await launch(
//                       'mailto:?subject=Check out this cool Wikipedia page&body=$url');
//                 } else {
//                   var newUrl = await Navigator.push(context,
//                       MaterialPageRoute(builder: (BuildContext context) {
//                     return FavoritesPage(model);
//                   }));
//                   Scaffold.of(context).removeCurrentSnackBar();
//                   if (newUrl != null) controller.data.loadUrl(newUrl);
//                 }
//               },
//               itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
//                     // const PopupMenuItem<String>(
//                     //   value: 'Email link',
//                     //   child: Text('Email link'),
//                     // ),
//                     const PopupMenuItem<String>(
//                       value: 'See Favorites',
//                       child: Text('Favorites'),
//                     ),
//                   ],
//             );
//           },
//         );

//   }
// }

// class FavoritesPage extends StatefulWidget {
//   final MainModel model;

//   FavoritesPage(this.model);

//   @override
//   _FavoritesPageState createState() => _FavoritesPageState();
// }

// class _FavoritesPageState extends State<FavoritesPage> {
//   List<String> _bookmarkList = [];

//   @override
//   void initState() {
//     super.initState();

//     // setState(() {
//     //   _bookmarkList = widget.model.bookmarkList;
//     // });
//     widget.model.getBookmarkUrl().then((onValue) {
//       setState(() {
//         _bookmarkList = onValue;
//         print(_bookmarkList);
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ScopedModelDescendant<MainModel>(
//       builder: (context, child, model) {
//         return Scaffold(
//             backgroundColor: Colors.white,
//             appBar: AppBar(title: Text(AppLocalizations.of(context).favorites)),
//             body: Container(
//               child: _bookmarkList.length == 0
//                   ? Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: <Widget>[
//                           Icon(
//                             Icons.hourglass_empty,
//                             size: 120,
//                             color: Colors.blue[700],
//                           ),
//                           SizedBox(height: 5),
//                           Text(
//                             AppLocalizations.of(context).noUrlFound,
//                             style: Theme.of(context).textTheme.caption.copyWith(
//                                   fontSize: 15,
//                                 ),
//                           )
//                         ],
//                       ),
//                     )
//                   : ListView.builder(
//                       itemCount:
//                           _bookmarkList == null ? 0 : _bookmarkList.length,
//                       itemBuilder: (context, i) {
//                         return Card(
//                             elevation: 2.0,
//                             child: ListTile(
//                               leading: Icon(Icons.web_asset),
//                               trailing: Container(
//                                 padding: EdgeInsets.only(bottom: 25),
//                                 child: GestureDetector(
//                                   child: Icon(
//                                     Icons.favorite,
//                                     color: Colors.red,
//                                     size: 18,
//                                   ),
//                                   onTap: () {
//                                     model.selectedFav(i);
//                                     model.deleteFavUrl();
//                                   },
//                                 ),
//                               ),
//                               title: GestureDetector(
//                                   child: Text(
//                                     _bookmarkList[i],
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .subtitle
//                                         .copyWith(
//                                             fontSize: 15,
//                                             decoration:
//                                                 TextDecoration.underline,
//                                             color: Colors.blue),
//                                   ),
//                                   onTap: () =>
//                                       Navigator.pop(context, _bookmarkList[i])),
//                             ));
//                       },
//                     ),
//             ));
//       },
//     );
//   }
// }

class NavigationControls extends StatelessWidget {
  const NavigationControls(this._webViewControllerFuture)
      : assert(_webViewControllerFuture != null);

  final Future<WebViewController> _webViewControllerFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: _webViewControllerFuture,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
        final bool webViewReady =
            snapshot.connectionState == ConnectionState.done;
        final WebViewController controller = snapshot.data;
        return Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: !webViewReady
                  ? null
                  : () => navigate(context, controller, goBack: true),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: !webViewReady
                  ? null
                  : () => navigate(context, controller, goBack: false),
            ),
          ],
        );
      },
    );
  }

  navigate(BuildContext context, WebViewController controller,
      {bool goBack: false}) async {
    bool canNavigate =
        goBack ? await controller.canGoBack() : await controller.canGoForward();
    if (canNavigate) {
      goBack ? controller.goBack() : controller.goForward();
    } else {
      // Scaffold.of(context).showSnackBar(
      //   SnackBar(
      //       content: Text("No ${goBack ? 'back' : 'forward'} history item")),
      // );
      print("No ${goBack ? 'back' : 'forward'} history item");
    }
  }
}
