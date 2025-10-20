// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
//
// class OrderTrackingPage extends StatefulWidget {
//   const OrderTrackingPage({Key? key}) : super(key: key);
//
//   @override
//   State<OrderTrackingPage> createState() => OrderTrackingPageState();
// }
//
// class OrderTrackingPageState extends State<OrderTrackingPage> {
//   final MapController _mapController = MapController();
//
//   static final LatLng sourceLocation = LatLng(37.33500926, -122.03272188);
//   static final LatLng destination = LatLng(37.33429383, -122.0660055);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: const Text(
//           "Track order",
//           style: TextStyle(color: Colors.black, fontSize: 16),
//         ),
//       ),
//       body: FlutterMap(
//         mapController: _mapController,
//         options: MapOptions(
//           center: sourceLocation, // center of the map
//           zoom: 14.5,
//         ),
//         children: [
//           TileLayer(
//             urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
//             subdomains: const ['a', 'b', 'c'],
//             userAgentPackageName: 'com.example.app',
//           ),
//           MarkerLayer(
//             markers: [
//               Marker(
//                 point: sourceLocation,
//                 width: 80,
//                 height: 80,
//                 builder: (context) => const Icon(
//                   Icons.location_on,
//                   color: Colors.green,
//                   size: 40,
//                 ),
//               ),
//               Marker(
//                 point: destination,
//                 width: 80,
//                 height: 80,
//                 builder: (context) => const Icon(
//                   Icons.location_on,
//                   color: Colors.red,
//                   size: 40,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
