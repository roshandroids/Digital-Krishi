// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:url_launcher/url_launcher.dart';

// class PlantDetails extends StatefulWidget {
//   final String image;
//   final String name;
//   final String cost;
//   final String quality;
//   final String soldBy;
//   final String contact;
//   PlantDetails(
//       {@required this.contact,
//       @required this.cost,
//       @required this.image,
//       @required this.name,
//       @required this.quality,
//       @required this.soldBy});
//   @override
//   _PlantDetailsState createState() => _PlantDetailsState();
// }

// class _PlantDetailsState extends State<PlantDetails> {
//   @override
//   Widget build(BuildContext context) {
//     String _phone = widget.contact;
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         centerTitle: true,
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//               gradient: LinearGradient(colors: <Color>[
//             Color(0xff1D976C),
//             Color(0xff11998e),
//             Color(0xff1D976C),
//           ])),
//         ),
//         title: Text("Plant Details"),
//         leading: IconButton(
//             icon: Icon(
//               Icons.chevron_left,
//               size: 30,
//             ),
//             onPressed: () async {
//               Navigator.of(context).pop();
//             }),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Container(
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: Colors.white,
//                   boxShadow: [
//                     BoxShadow(
//                         blurRadius: 1.0, color: Color.fromRGBO(0, 0, 0, .5))
//                   ]),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(10),
//                 child: CachedNetworkImage(
//                   imageUrl: widget.image,
//                   fit: BoxFit.contain,
//                   placeholder: (context, url) => SpinKitWave(
//                     color: Colors.blue,
//                     size: 50.0,
//                   ),
//                   errorWidget: (context, url, error) => Icon(Icons.error),
//                 ),
//               ),
//             ),
//             Container(
//               width: MediaQuery.of(context).size.width,
//               margin: EdgeInsets.all(10),
//               padding: EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: Colors.white,
//                   boxShadow: [
//                     BoxShadow(
//                         blurRadius: 1.0, color: Color.fromRGBO(0, 0, 0, .5))
//                   ]),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       Text(
//                         "Plant Name: " + widget.name,
//                         style: TextStyle(
//                             fontSize: 20, fontWeight: FontWeight.w600),
//                       ),
//                       Text(
//                         "Quality Grade: " + widget.quality,
//                         style: TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.w500),
//                       ),
//                       Text(
//                         "Cost per plant: Rs." + widget.cost,
//                         style: TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.w500),
//                       ),
//                       Text(
//                         "Sold By: " + widget.soldBy,
//                         style: TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.w500),
//                       ),
//                       Text(
//                         "Contact to buy: " + widget.contact,
//                         style: TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.w500),
//                       ),
//                     ],
//                   ),
//                   Expanded(
//                     child: InkWell(
//                       onTap: () {
//                         if (mounted)
//                           setState(() {
//                             _makePhoneCall('tel:$_phone');
//                           });
//                       },
//                       child: Container(
//                         alignment: Alignment.center,
//                         height: 50,
//                         width: 100,
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             color: Colors.green),
//                         margin: EdgeInsets.all(10),
//                         child: Text(
//                           "Order Now",
//                           style: TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.w600,
//                               color: Colors.white),
//                         ),
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _makePhoneCall(String url) async {
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }
// }
