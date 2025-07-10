// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/custom_code/widgets/index.dart'; // Outros widgets personalizados
import '/flutter_flow/custom_functions.dart';
import 'package:fl_chart/fl_chart.dart';

class KpiPagamentosPorMes extends StatefulWidget {
  const KpiPagamentosPorMes({
    super.key,
    this.width,
    this.height,
    this.pagamento,
  });

  final double? width;
  final double? height;
  final List<PagamentosRecord>? pagamento;

  @override
  State<KpiPagamentosPorMes> createState() => _KpiPagamentosPorMesState();
}

class _KpiPagamentosPorMesState extends State<KpiPagamentosPorMes> {
  Map<int, double> _somarPagamentosPorMes(List<PagamentosRecord> pagamentos) {
    final Map<int, double> somaPorMes = {};

    for (var pag in pagamentos) {
      final data = pag.data;
      if (data == null || pag.valor == null) continue;

      final mes = data.month; // 1 a 12
      somaPorMes[mes] = (somaPorMes[mes] ?? 0) + pag.valor!;
    }

    return somaPorMes;
  }

  List<FlSpot> _gerarPontos(Map<int, double> somaPorMes) {
    final mesesOrdenados = somaPorMes.keys.toList()..sort();
    return mesesOrdenados.map((mes) {
      return FlSpot(mes.toDouble(), somaPorMes[mes]!);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final pagamentos = widget.pagamento ?? [];
    final somaPorMes = _somarPagamentosPorMes(pagamentos);
    final spots = _gerarPontos(somaPorMes);

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
                getTitlesWidget: (value, meta) {
                  final mes = value.toInt();
                  const nomesMeses = [
                    '',
                    'Jan',
                    'Fev',
                    'Mar',
                    'Abr',
                    'Mai',
                    'Jun',
                    'Jul',
                    'Ago',
                    'Set',
                    'Out',
                    'Nov',
                    'Dez'
                  ];
                  return Text(nomesMeses[mes], style: TextStyle(fontSize: 10));
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
              dotData: FlDotData(show: true),
            ),
          ],
        ),
      ),
    );
  }
}
