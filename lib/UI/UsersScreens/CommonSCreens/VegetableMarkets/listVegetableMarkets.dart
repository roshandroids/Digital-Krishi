import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalKrishi/CustomComponents/offline.dart';
import 'package:digitalKrishi/UI/UsersScreens/CommonSCreens/VegetableMarkets/locationPicker.dart';
import 'package:digitalKrishi/UI/UsersScreens/CommonSCreens/VegetableMarkets/placeDetails.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:page_transition/page_transition.dart';

class ListVegetableMarkets extends StatefulWidget {
  @override
  _ListVegetableMarketsState createState() => _ListVegetableMarketsState();
}

class _ListVegetableMarketsState extends State<ListVegetableMarkets>
    with SingleTickerProviderStateMixin {
  Widget _buildListMarkets(
      BuildContext context, DocumentSnapshot document, String collectionName) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.fade,
              child: PlaceDetails(
                thumbNail: document['thumbNail'],
                shopName: document['shopName'],
                locationCoords: LatLng(document['locationCoords'].latitude,
                    document['locationCoords'].longitude),
                description: document['description'],
              ),
            ));
      },
      child: Container(
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              new BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.5),
                blurRadius: 1.0,
              ),
            ],
            borderRadius: BorderRadius.circular(5)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      document['shopName'],
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    onPressed: () async {
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext bc) {
                            return OfflineBuilder(
                              connectivityBuilder: (
                                BuildContext context,
                                ConnectivityResult connectivity,
                                Widget child,
                              ) {
                                bool connected =
                                    connectivity != ConnectivityResult.none;
                                return connected
                                    ? Container(
                                        color: Colors.black.withOpacity(.1),
                                        child: Wrap(
                                          children: <Widget>[
                                            ListTile(
                                                leading: Icon(
                                                  Icons.warning,
                                                  color: Colors.red,
                                                ),
                                                title:
                                                    Text('Delete This Market'),
                                                onTap: () async {
                                                  Navigator.of(context).pop();
                                                  await FirebaseStorage.instance
                                                      .getReferenceFromUrl(
                                                          document['thumbNail'])
                                                      .then((value) =>
                                                          value.delete())
                                                      .catchError((onError) {
                                                    print(onError);
                                                  });
                                                  await Firestore.instance
                                                      .collection('shops')
                                                      .document(
                                                          document.documentID)
                                                      .delete();

                                                  Fluttertoast.showToast(
                                                      msg:
                                                          "Deleted Successfully",
                                                      toastLength:
                                                          Toast.LENGTH_LONG,
                                                      backgroundColor:
                                                          Colors.green,
                                                      textColor: Colors.white);
                                                }),
                                            Divider(
                                              color: Colors.blueGrey,
                                              thickness: 1,
                                              indent: 20,
                                              endIndent: 10,
                                            ),
                                            ListTile(
                                              leading: Icon(
                                                Icons.cancel,
                                                color: Colors.blue,
                                              ),
                                              title: Text('Cancel'),
                                              onTap: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(
                                        height: 100,
                                        child: Offline(),
                                      );
                              },
                              child: Container(),
                            );
                          });
                    })
              ],
            ),
            ClipRRect(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5)),
              child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  placeholder: (context, url) => SpinKitWave(
                        color: Colors.blue,
                        size: 60.0,
                      ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  imageUrl: document['thumbNail']),
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
        title: Text("Available Vegetable Markets"),
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
                  stream: Firestore.instance.collection('shops').snapshots(),
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
                              "There are no Markets Located Nearby",
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
                      itemBuilder: (context, index) => _buildListMarkets(
                          context, snapshot.data.documents[index], 'shops'),
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
                  type: PageTransitionType.fade, child: LocationPicker()));
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
