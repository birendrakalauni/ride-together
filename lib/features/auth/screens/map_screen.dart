// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';

// class MapScreen extends StatelessWidget {
//   const MapScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('rideTogether'),
//       ),
//       body: FlutterMap(
//         options: const MapOptions(
//           initialCenter: LatLng(27.7172, 85.3240),
//           initialZoom: 13,
//         ),
//         children: [
//           TileLayer(
//             urlTemplate:
//                 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//             userAgentPackageName: 'com.example.ride_together',
//           ),

//           RichAttributionWidget(
//             attributions: [
//               TextSourceAttribution(
//                 'OpenStreetMap contributors',
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }