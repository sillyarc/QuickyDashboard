// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:fl_chart/fl_chart.dart'; // gráfico

class Orderskpis extends StatefulWidget {
  const Orderskpis({
    super.key,
    this.width,
    this.height,
    this.orderRequest,
    this.orderCompleted,
  });

  final double? width;
  final double? height;
  final List<int>? orderRequest;
  final List<int>? orderCompleted;

  @override
  State<Orderskpis> createState() => _OrderskpisState();
}

class _OrderskpisState extends State<Orderskpis> {
  List<FlSpot> _generateSpots(List<int>? data) {
    if (data == null) return [];

    return List.generate(data.length, (index) {
      return FlSpot(index.toDouble(), data[index].toDouble());
    });
  }

  @override
  Widget build(BuildContext context) {
    final requestSpots = _generateSpots(widget.orderRequest);
    final completedSpots = _generateSpots(widget.orderCompleted);

    return Container(
      width: widget.width ?? double.infinity,
      height: widget.height ?? 300,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
          ),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            LineChartBarData(
              spots: requestSpots,
              isCurved: true,
              gradient: LinearGradient(colors: [Colors.orange]),
              barWidth: 3,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [Colors.orange.withOpacity(0.3)],
                ),
              ),
            ),
            LineChartBarData(
              spots: completedSpots,
              isCurved: true,
              gradient: LinearGradient(colors: [Colors.green]),
              barWidth: 3,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [Colors.green.withOpacity(0.3)],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
