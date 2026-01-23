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

import 'package:fl_chart/fl_chart.dart';

import '/custom_code/widgets/index.dart';
import '/flutter_flow/custom_functions.dart';
import 'package:fl_chart/fl_chart.dart';

class PagamentosChart extends StatefulWidget {
  const PagamentosChart({
    super.key,
    this.width,
    this.height,
    this.pagamentos,
  });

  final double? width;
  final double? height;
  final List<PagamentosRecord>? pagamentos;

  @override
  State<PagamentosChart> createState() => _PagamentosChartState();
}

class _PagamentosChartState extends State<PagamentosChart> {
  // Função para acumular os pagamentos por mês
  Map<DateTime, double> _acumularPagamentosPorMes(
      List<PagamentosRecord> pagamentos) {
    final Map<DateTime, double> porMes = {};

    for (var pagamento in pagamentos) {
      final dataPagamento =
          pagamento.data; // Supondo que 'data' seja do tipo DateTime
      final valorPagamento = pagamento.valor; // Valor do pagamento

      if (dataPagamento == null || valorPagamento == null) continue;

      // Obtendo o mês e o ano
      final primeiroDiaMes =
          DateTime(dataPagamento.year, dataPagamento.month, 1);

      // Acumulando os valores de pagamentos por mês
      porMes[primeiroDiaMes] = (porMes[primeiroDiaMes] ?? 0) + valorPagamento;
    }

    // Ordenar por data
    final mesesOrdenados = porMes.keys.toList()..sort();
    final Map<DateTime, double> acumuladoPorMes = {};

    for (final mes in mesesOrdenados) {
      acumuladoPorMes[mes] = porMes[mes]!;
    }

    return acumuladoPorMes;
  }

  // Função para gerar os pontos para o gráfico
  List<FlSpot> _gerarPontos(Map<DateTime, double> acumuladoPorMes) {
    final meses = acumuladoPorMes.keys.toList()..sort();
    final inicio = meses.first;

    return meses.map((mes) {
      final diffMeses =
          mes.difference(inicio).inDays / 30.0; // Convertendo para meses
      return FlSpot(diffMeses, acumuladoPorMes[mes]!.toDouble());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final pagamentos = widget.pagamentos ?? [];
    if (pagamentos.isEmpty) {
      return const Center(child: Text('Nenhum pagamento disponível.'));
    }

    final acumulado = _acumularPagamentosPorMes(pagamentos);
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
                  final mesesOrdenados = acumulado.keys.toList()..sort();
                  if (mesesOrdenados.isEmpty) return const Text('');
                  final dataBase = mesesOrdenados.first;
                  final data = dataBase.add(Duration(
                      days: (value * 30)
                          .toInt())); // Convertendo de volta para a data
                  return Text(
                    '${data.month}/${data.year}',
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
