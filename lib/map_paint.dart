  import 'package:flutter/material.dart';
  import 'map_load.dart';

  class MapPaint extends StatefulWidget {
    final Mapdata md;
    const MapPaint({super.key, required this.md});

    @override
    State<MapPaint> createState() => _MapPaintState();
  }

  class _MapPaintState extends State<MapPaint> {
    String? selectedNodeId; // Track selected node

    @override
    Widget build(BuildContext context) {
      return GestureDetector(
        onTapUp: (details) {
          final tapPosition = details.localPosition;

          for (var node in widget.md.nodes) {
            final nodePos = Offset(node.x, node.y);
            if ((nodePos - tapPosition).distance <= 15) {
              setState(() {
                selectedNodeId = node.id;
              });
              break;
            }
          }
        },
        child: CustomPaint(
          painter: Painter(widget.md, selectedNodeId),
          size: Size.infinite,
        ),
      );
    }
  }

  class Painter extends CustomPainter {
    final Mapdata md;
    final String? selectedNodeId;

    Painter(this.md, this.selectedNodeId);

    @override
    void paint(Canvas canvas, Size size) {
      final Paint nodePaint = Paint()..color = Colors.blue;
      final Paint selectedPaint = Paint()..color = Colors.red;
      final Paint edgePaint = Paint()
        ..color = Colors.grey
        ..strokeWidth = 2.0;

      final textPainter = TextPainter(
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );

      for (final edge in md.edges) {
        final source = md.nodes.firstWhere((n) => n.id == edge.source);
        final target = md.nodes.firstWhere((n) => n.id == edge.destination);

        canvas.drawLine(
          Offset(source.x, source.y),
          Offset(target.x, target.y),
          edgePaint,
        );
      }

      for (final node in md.nodes) {
        final isSelected = node.id == selectedNodeId;
        final paint = isSelected ? selectedPaint : nodePaint;
        Rect r = Rect.fromCenter(center: Offset(node.x, node.y), width: 80, height: 80);
        canvas.drawRect(r, paint);
  
        textPainter.text = TextSpan(
          text: node.label,
          style: TextStyle(color: Colors.white, fontSize: 10),
        );
        textPainter.layout(minWidth: 30, maxWidth: 60);
        textPainter.paint(
          canvas,
          Offset(node.x - textPainter.width / 2, node.y - textPainter.height / 2),
        );
      }
    }

    @override
    bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
  }
