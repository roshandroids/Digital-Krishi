import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digitalKrishi/CustomComponents/fullPhoto.dart';
import 'package:digitalKrishi/UI/UsersScreens/CommonSCreens/ChatScreens/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class ExpertDetails extends StatefulWidget {
  final String profileImage;
  final String fullName;
  final String email;
  final String userId;
  final String contact;
  final String verificationDocument;
  final String userType;
  final String address;
  final String isVerified;
  final String id;
  final String collectionName;
  final String viewBy;

  ExpertDetails(
      {Key key,
      @required this.viewBy,
      @required this.profileImage,
      @required this.fullName,
      @required this.email,
      @required this.userId,
      @required this.contact,
      @required this.userType,
      @required this.address,
      @required this.isVerified,
      @required this.collectionName,
      @required this.verificationDocument,
      @required this.id})
      : super(key: key);

  @override
  _ExpertDetailsState createState() => _ExpertDetailsState();
}

class _ExpertDetailsState extends State<ExpertDetails> {
  final databaseReference = Firestore.instance;
  String userEmail;
  bool isLoading = false;
  void verifyUser() async {
    setState(() {
      isLoading = true;
    });
    await Firestore.instance
        .collection('users')
        .document(widget.userId)
        .updateData({'isVerified': "Verified"});
    setState(() {
      isLoading = false;
      Fluttertoast.showToast(
          msg: "User verified Successfully",
          textColor: Colors.white,
          backgroundColor: Colors.green);
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    String _phone = widget.contact;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.chevron_left,
              size: 30,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: <Color>[
            Color(0xff1D976C),
            Color(0xff11998e),
            Color(0xff1D976C),
          ])),
        ),
        centerTitle: true,
        title: Text(
          "Expert Details",
          style: TextStyle(),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Column(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    FullPhoto(url: widget.profileImage)));
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height / 3,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              new BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.5),
                                blurRadius: 10.0,
                              ),
                            ]),
                        margin: EdgeInsets.only(top: 20, left: 12, right: 12),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width,
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            imageUrl: widget.profileImage,
                          ),
                        ),
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                new BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.5),
                                  blurRadius: 5.0,
                                ),
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Center(
                                  child: Text(
                                    "Account Details",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Divider(),
                                RichText(
                                  text: TextSpan(
                                    text: 'Full Name : ',
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                        fontSize: 16),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: widget.fullName,
                                          style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 12,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400)),
                                    ],
                                  ),
                                ),
                                Divider(),
                                RichText(
                                  text: TextSpan(
                                    text: 'Email : ',
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                        fontSize: 16),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: widget.email,
                                          style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 12,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400)),
                                    ],
                                  ),
                                ),
                                Divider(),
                                RichText(
                                  text: TextSpan(
                                    text: 'Contact : ',
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                        fontSize: 16),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: widget.contact,
                                          style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 12,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400)),
                                    ],
                                  ),
                                ),
                                Divider(),
                                Row(
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        text: 'Verification Status : ',
                                        style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                            fontSize: 16),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: widget.isVerified,
                                              style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 12,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w400)),
                                        ],
                                      ),
                                    ),
                                    (widget.isVerified == "Verified")
                                        ? Icon(
                                            Icons.verified_user,
                                            size: 15,
                                            color: Colors.green,
                                          )
                                        : Container(),
                                  ],
                                ),
                                Divider(),
                                RichText(
                                  text: TextSpan(
                                    text: 'Contact Expert : ',
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                        fontSize: 16),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: "choose any of below",
                                          style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 12,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400)),
                                    ],
                                  ),
                                ),
                                (widget.viewBy != "Admin")
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          Column(
                                            children: <Widget>[
                                              IconButton(
                                                onPressed: () => setState(() {
                                                  _makePhoneCall('tel:$_phone');
                                                }),
                                                icon: Image.asset(
                                                    'lib/Assets/Images/ring.gif'),
                                              ),
                                              Text(
                                                "Call",
                                                style: TextStyle(),
                                              )
                                            ],
                                          ),
                                          Column(
                                            children: <Widget>[
                                              IconButton(
                                                  icon: Image.asset(
                                                      'lib/Assets/Images/speech.gif'),
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    ChatScreen(
                                                                      peerAvatar:
                                                                          widget
                                                                              .profileImage,
                                                                      peerId: widget
                                                                          .userId,
                                                                    )));
                                                  }),
                                              Text(
                                                "Chat",
                                                style: TextStyle(),
                                              )
                                            ],
                                          )
                                        ],
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    (widget.viewBy == "Admin")
                        ? (widget.verificationDocument == "")
                            ? Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    boxShadow: [
                                      new BoxShadow(
                                        color: Color.fromRGBO(0, 0, 0, 0.08),
                                        blurRadius: 20.0,
                                      ),
                                    ]),
                                margin: EdgeInsets.only(
                                    top: 20, left: 12, right: 12),
                                child: Text(
                                    "The user has't uploaded verification document yet"))
                            : Column(
                                children: <Widget>[
                                  Text(
                                    "Verification Document",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => FullPhoto(
                                                  url: widget
                                                      .verificationDocument)));
                                    },
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              3,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          boxShadow: [
                                            new BoxShadow(
                                              color:
                                                  Color.fromRGBO(0, 0, 0, 0.08),
                                              blurRadius: 20.0,
                                            ),
                                          ]),
                                      margin: EdgeInsets.only(
                                          top: 20, left: 12, right: 12),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          placeholder: (context, url) =>
                                              CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                          imageUrl: widget.verificationDocument,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                        : Container(),
                    (widget.isVerified == "Not Verified")
                        ? InkWell(
                            onTap: () {
                              verifyUser();
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 10),
                              alignment: Alignment.center,
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.green),
                              width: MediaQuery.of(context).size.width / 1.5,
                              child: Text(
                                "Verify This Account",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
            (isLoading)
                ? Center(
                    child: SpinKitHourGlass(
                      color: Colors.green,
                      size: 50,
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
