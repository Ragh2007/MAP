import 'package:flutter/material.dart';
import 'map_load.dart';
import 'map_paint.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Campus Map',
      home: Scaffold(
        appBar: AppBar(title: Text('Campus Navigator')),
        body: FutureBuilder<Mapdata>(
          future: loadmapdata(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return InteractiveViewer(
                  boundaryMargin: EdgeInsets.all(100),
                  minScale: 0.1,
                  maxScale: 5,
                  child: MapPaint(md: snapshot.data!),
                );
              } else {
                return Center(child: Text('Error loading map data'));
              }
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
