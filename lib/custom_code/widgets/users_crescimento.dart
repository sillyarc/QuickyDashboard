// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/custom_code/widgets/index.dart';
import '/flutter_flow/custom_functions.dart';
import 'package:fl_chart/fl_chart.dart';

class UsersCrescimento extends StatefulWidget {
  const UsersCrescimento({
    super.key,
    this.width,
    this.height,
    this.users,
  });

  final double? width;
  final double? height;
  final List<UsersRecord>? users;

  @override
  State<UsersCrescimento> createState() => _UsersCrescimentoState();
}

class _UsersCrescimentoState extends State<UsersCrescimento> {
  Map<DateTime, int> _acumularUsuariosPorDia(List<UsersRecord> users) {
    final Map<DateTime, int> porDia = {};

    for (var user in users) {
      final createdTime = user.createdTime;
      if (createdTime == null) continue;

      final dia =
          DateTime(createdTime.year, createdTime.month, createdTime.day);

      porDia[dia] = (porDia[dia] ?? 0) + 1;
    }

    // Ordenar e acumular os valores
    final diasOrdenados = porDia.keys.toList()..sort();
    int acumulado = 0;
    final Map<DateTime, int> acumuladoPorDia = {};

    for (final dia in diasOrdenados) {
      acumulado += porDia[dia]!;
      acumuladoPorDia[dia] = acumulado;
    }

    return acumuladoPorDia;
  }

  List<FlSpot> _gerarPontos(Map<DateTime, int> acumuladoPorDia) {
    final dias = acumuladoPorDia.keys.toList()..sort();
    final inicio = dias.first;

    return dias.map((dia) {
      final diffDias = dia.difference(inicio).inDays.toDouble();
      return FlSpot(diffDias, acumuladoPorDia[dia]!.toDouble());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final users = widget.users ?? [];
    if (users.isEmpty) {
      return const Center(child: Text('Nenhum usuário disponível.'));
    }

    final acumulado = _acumularUsuariosPorDia(users);
    final spots = _gerarPontos(acumulado);

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
              sideTitles: SideTitles(
                showTitles: true,
                interval: (spots.length / 4).ceilToDouble(),
                getTitlesWidget: (value, meta) {
                  final diasOrdenados = acumulado.keys.toList()..sort();
                  if (diasOrdenados.isEmpty) return const Text('');
                  final dataBase = diasOrdenados.first;
                  final data = dataBase.add(Duration(days: value.toInt()));
                  return Text(
                    '${data.day}/${data.month}',
                    style: const TextStyle(fontSize: 10),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: const Color(0xFFAC996D),
              barWidth: 3,
              belowBarData: BarAreaData(
                show: true,
                color: const Color(0xFF98B28E).withOpacity(0.3),
              ),
              dotData: FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}
