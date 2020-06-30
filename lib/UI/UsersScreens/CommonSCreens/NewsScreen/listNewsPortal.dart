import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalKrishi/UI/UsersScreens/CommonSCreens/NewsScreen/addNewsPortal.dart';
import 'package:digitalKrishi/UI/UsersScreens/CommonSCreens/NewsScreen/readNews.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:page_transition/page_transition.dart';

class ListNewsPortal extends StatefulWidget {
  @override
  _ListNewsPortalState createState() => _ListNewsPortalState();
}

class _ListNewsPortalState extends State<ListNewsPortal>
    with SingleTickerProviderStateMixin {
  Widget _buildListBooks(
      BuildContext context, DocumentSnapshot document, String collectionName) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.fade,
                child: ReadNews(
                  url: document['url'],
                )));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
            border: Border.all(width: .5),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: <Widget>[
            CachedNetworkImage(
              imageUrl: document['siteLogo'],
              fit: BoxFit.cover,
              placeholder: (context, url) => SpinKitWave(
                color: Colors.blue,
                size: 50.0,
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            Text(
              document['siteName'],
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Available News Portals"),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: <Color>[
            Color(0xff1D976C),
            Color(0xff11998e),
            Color(0xff1D976C),
          ])),
        ),
        leading: IconButton(
            icon: Icon(
              Icons.chevron_left,
              size: 30,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                  stream:
                      Firestore.instance.collection('newsPortal').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return LinearProgressIndicator(
                        backgroundColor: Colors.black12,
                      );
                    if (snapshot.data.documents.length <= 0)
                      return Stack(
                        children: [
                          LinearProgressIndicator(
                            backgroundColor: Colors.green,
                          ),
                          Container(
                            alignment: Alignment.center,
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              "There are no books uploaded yet",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      );
                    return ListView.builder(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) => _buildListBooks(
                          context, snapshot.data.documents[index], 'Books'),
                    );
                  }),
            ),
          ],
        ),
      ),
      floatingActionButton: InkWell(
        onTap: () {
          Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.fade, child: AddNewsPortal()));
        },
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.blue, borderRadius: BorderRadius.circular(30)),
          height: 60.0,
          width: 60.0,
          child: Icon(
            Icons.add,
            size: 30,
          ),
        ),
      ),
    );
  }
}
