import 'dart:convert';
import 'package:flutter/services.dart';

class Mapnode {
  final String id;
  final String label;
  final double x;
  final double y;

  Mapnode({
    required this.id,
    required this.label,
    required this.x,
    required this.y,
  });
}

class Mapedge {
  final String source;
  final String destination;

  Mapedge({
    required this.source,
    required this.destination,
  });
}

class Mapdata {
  final List<Mapnode> nodes;
  final List<Mapedge> edges;

  Mapdata({
    required this.nodes,
    required this.edges,
  });
}

Future<Mapdata> loadmapdata() async {
  // Load JSON from assets
  final String jsonstring =
  await rootBundle.loadString('assets/graph-export.json');
  final json = jsonDecode(jsonstring);

  // Parse all nodes from JSON
  final List<Mapnode> nodes = (json['nodes'] as List)
      .where((node) =>
  node != null &&
      node['id'] != null &&
      node['data'] != null &&
      node['data']['label'] != null &&
      node['position'] != null)
      .map((node) => Mapnode(
    id: node['id'],
    label: node['data']['label'],
    x: node['position']['x'] * 1.0,
    y: node['position']['y'] * 1.0,
  ))
      .toList();


  nodes.sort((a, b) => a.id.compareTo(b.id));

  // Parse and filter valid edges only
  final List<Mapedge> edges = (json['edges'] as List)
      .where((edge) =>
  edge != null &&
      edge.containsKey('source') &&
      edge.containsKey('target'))
      .map((edge) => Mapedge(
    source: edge['source'],
    destination: edge['target'],
  ))
      .toList();

  return Mapdata(nodes: nodes, edges: edges);
}
