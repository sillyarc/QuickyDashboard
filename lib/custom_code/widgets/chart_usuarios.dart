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

class ChartUsuarios extends StatefulWidget {
  const ChartUsuarios({
    super.key,
    this.width,
    this.height,
    this.usuarios,
  });

  final double? width;
  final double? height;
  final List<UsersRecord>? usuarios;

  @override
  State<ChartUsuarios> createState() => _ChartUsuariosState();
}

class _ChartUsuariosState extends State<ChartUsuarios> {
  // ---------- Dados fictícios (Jan..Dec) ----------
  static const List<double> _vals = <double>[
    3500.0,
    4200.0,
    1800.0,
    21000.0,
    19000.0,
    20000.0,
    17000.0,
    16000.0,
    34000.0,
    22000.0,
    20000.0,
    15000.0,
  ];
  static const List<String> _months = <String>[
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  // ---------- Estilo ----------
  static const Color _panel = Color(0xFF3E3E3E);
  static const Color _card = Color(0xFF4A4A4A);
  static const Color _axisBar = Color(0xFFF6A21A);
  static const Color _grid = Colors.white24;
  static const Color _fillTop = Color(0xFFFFC242);
  static const Color _fillBottom = Color(0xFFCC8A10);
  static const Color _line = Color(0xFFFFB000);
  static const Color _dot = Color(0xFFFF6F00);

  int? _hoverIndex;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final double w = widget.width ?? 560.0;
    final double h = widget.height ?? 200.0;
    // Monta valores a partir da lista de usuários (por mês do ano corrente)
    final List<double> vals = _buildValsFromUsers(widget.usuarios);
    final List<String> months = const <String>[
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];

    final double maxY = _niceMax(vals);
    const List<int> yTicks = <int>[0, 5000, 10000, 15000, 20000, 30000, 40000];

    const double leftBarW = 56.0;
    const double bottomH = 26.0;
    const double radius = 12.0;

    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: _panel,
        borderRadius: BorderRadius.circular(radius),
      ),
      padding: const EdgeInsets.all(10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Container(
          decoration: BoxDecoration(
            color: _card,
            borderRadius: BorderRadius.circular(radius),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black45, blurRadius: 10, offset: Offset(0, 6))
            ],
          ),
          child: Row(
            children: [
              // Barra lateral Y (0..40k)
              Container(
                width: leftBarW,
                decoration: BoxDecoration(
                  color: _axisBar,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(radius),
                    bottomLeft: Radius.circular(radius),
                  ),
                ),
                padding: const EdgeInsets.only(left: 8, right: 6),
                child: const _YAxisLabels(
                  ticks: <int>[0, 5000, 10000, 15000, 20000, 30000, 40000],
                ),
              ),

              // Gráfico + meses
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, c) {
                          final double chartW = c.maxWidth;
                          final double chartH = c.maxHeight;

                          return MouseRegion(
                            onHover: (e) {
                              final int idx = _xToIndex(
                                  e.localPosition.dx, chartW, vals.length);
                              setState(() => _hoverIndex = idx);
                            },
                            onExit: (_) => setState(() => _hoverIndex = null),
                            child: GestureDetector(
                              onPanDown: (d) {
                                final int idx = _xToIndex(
                                    d.localPosition.dx, chartW, vals.length);
                                setState(() => _hoverIndex = idx);
                              },
                              onPanUpdate: (d) {
                                final int idx = _xToIndex(
                                    d.localPosition.dx, chartW, vals.length);
                                setState(() => _hoverIndex = idx);
                              },
                              onPanEnd: (_) =>
                                  setState(() => _hoverIndex = null),
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  CustomPaint(
                                    painter: _AreaChartPainter(
                                      values: vals,
                                      maxY: maxY,
                                      gridColor: _grid,
                                      lineColor: _line,
                                      fillTop: _fillTop,
                                      fillBottom: _fillBottom,
                                      dotColor: _dot,
                                      highlightIndex: _hoverIndex,
                                    ),
                                    size: Size(chartW, chartH),
                                  ),
                                  if (_hoverIndex != null)
                                    _TooltipPositioned(
                                      idx: _hoverIndex!,
                                      vals: vals,
                                      chartW: chartW,
                                      chartH: chartH,
                                      maxY: maxY,
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: bottomH,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 2, 10, 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(months.length, (i) {
                            return Expanded(
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Text(
                                  months[i],
                                  style: theme.bodySmall.copyWith(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Converte X absoluto do Stack para índice (respeitando margens internas).
  int _xToIndex(double x, double fullWidth, int n) {
    final double minX = _ChartInsets.left;
    final double maxX = fullWidth - _ChartInsets.right;
    final double clamped = x < minX ? minX : (x > maxX ? maxX : x);
    final double usable = fullWidth - _ChartInsets.left - _ChartInsets.right;
    if (usable <= 0) return 0;
    final double t = ((clamped - _ChartInsets.left) / usable);
    final int idx = (t * (n - 1)).round();
    return idx.clamp(0, n - 1);
  }
}

/// Padding compartilhado para painter/tooltip
class _ChartInsets {
  static const double top = 8.0;
  static const double right = 10.0;
  static const double bottom = 10.0;
  static const double left = 10.0;
}

/// ---------- Pintor do gráfico ----------
class _AreaChartPainter extends CustomPainter {
  _AreaChartPainter({
    required this.values,
    required this.maxY,
    required this.gridColor,
    required this.lineColor,
    required this.fillTop,
    required this.fillBottom,
    required this.dotColor,
    required this.highlightIndex,
  });

  final List<double> values;
  final double maxY;
  final Color gridColor;
  final Color lineColor;
  final Color fillTop;
  final Color fillBottom;
  final Color dotColor;
  final int? highlightIndex;

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    final Rect chart = Rect.fromLTWH(
      _ChartInsets.left,
      _ChartInsets.top,
      w - _ChartInsets.left - _ChartInsets.right,
      h - _ChartInsets.top - _ChartInsets.bottom,
    );

    // Grid horizontal suave
    final Paint gridPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = gridColor.withOpacity(.6);
    const int gridCount = 5;
    for (int i = 1; i <= gridCount; i++) {
      final double y = chart.top + chart.height * i / (gridCount + 1);
      canvas.drawLine(Offset(chart.left, y), Offset(chart.right, y), gridPaint);
    }

    // Pontos
    final List<Offset> pts = <Offset>[];
    final int n = values.length;
    for (int i = 0; i < n; i++) {
      final double x = chart.left + chart.width * (i / (n - 1));
      final double y = _valToY(values[i], chart.height, maxY) + chart.top;
      pts.add(Offset(x, y));
    }
    if (pts.isEmpty) return;

    // Curva suave
    final Path path = Path()..moveTo(pts.first.dx, pts.first.dy);
    for (int i = 0; i < pts.length - 1; i++) {
      final Offset p0 = i == 0 ? pts[i] : pts[i - 1];
      final Offset p1 = pts[i];
      final Offset p2 = pts[i + 1];
      final Offset p3 = (i + 2 < pts.length) ? pts[i + 2] : pts[i + 1];

      const double t = 0.2;
      final Offset cp1 =
          Offset(p1.dx + (p2.dx - p0.dx) * t, p1.dy + (p2.dy - p0.dy) * t);
      final Offset cp2 =
          Offset(p2.dx - (p3.dx - p1.dx) * t, p2.dy - (p3.dy - p1.dy) * t);
      path.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, p2.dx, p2.dy);
    }

    // Área (degradê)
    final Path area = Path.from(path)
      ..lineTo(chart.right, chart.bottom)
      ..lineTo(chart.left, chart.bottom)
      ..close();
    final Paint fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[fillTop, fillBottom],
      ).createShader(chart);
    canvas.drawPath(area, fillPaint);

    // Linha
    final Paint linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..color = lineColor;
    canvas.drawPath(path, linePaint);

    // Destaque (linha vertical + ponto)
    if (highlightIndex != null) {
      final int i = highlightIndex!.clamp(0, pts.length - 1);
      final Offset p = pts[i];

      final Paint guide = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..color = Colors.white70;
      canvas.drawLine(
          Offset(p.dx, chart.top), Offset(p.dx, chart.bottom), guide);

      final Paint dotStroke = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = Colors.white;
      final Paint dotFill = Paint()..color = dotColor;
      canvas.drawCircle(p, 4.5, dotFill);
      canvas.drawCircle(p, 4.5, dotStroke);
    }
  }

  @override
  bool shouldRepaint(covariant _AreaChartPainter old) {
    return old.values != values ||
        old.maxY != maxY ||
        old.highlightIndex != highlightIndex ||
        old.gridColor != gridColor ||
        old.lineColor != lineColor ||
        old.fillTop != fillTop ||
        old.fillBottom != fillBottom ||
        old.dotColor != dotColor;
  }
}

/// Tooltip posicionado com os mesmos offsets do chart
class _TooltipPositioned extends StatelessWidget {
  const _TooltipPositioned({
    required this.idx,
    required this.vals,
    required this.chartW,
    required this.chartH,
    required this.maxY,
  });

  final int idx;
  final List<double> vals;
  final double chartW;
  final double chartH;
  final double maxY;

  @override
  Widget build(BuildContext context) {
    final double usableW = chartW - _ChartInsets.left - _ChartInsets.right;
    final double usableH = chartH - _ChartInsets.top - _ChartInsets.bottom;
    final double step = usableW / (vals.length - 1);
    final double x = _ChartInsets.left + step * idx;
    final double y = _ChartInsets.top + _valToY(vals[idx], usableH, maxY);

    double left = x - 60.0;
    if (left < 0) left = 0;
    if (left > chartW - 120.0) left = chartW - 120.0;

    double top = y - 38.0;
    if (top < 0) top = 0;
    if (top > chartH - 24.0) top = chartH - 24.0;

    return Positioned(
      left: left,
      top: top,
      child: _ToolTip(text: '${_fmt(vals[idx])} Visitor'),
    );
  }
}

/// Labels da barra Y (0..40k)
class _YAxisLabels extends StatelessWidget {
  const _YAxisLabels({required this.ticks});
  final List<int> ticks;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[];
    for (int i = ticks.length - 1; i >= 0; i--) {
      children.add(Expanded(
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            _fmt(ticks[i].toDouble()),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ),
      ));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}

class _ToolTip extends StatelessWidget {
  const _ToolTip({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: Colors.white,
        shape: StadiumBorder(),
        shadows: [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 2))
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Text(
          text,
          style: const TextStyle(
              color: Colors.black87, fontWeight: FontWeight.w700, fontSize: 11),
        ),
      ),
    );
  }
}

// ---------- Helpers ----------
List<double> _buildValsFromUsers(List<UsersRecord>? users) {
  if (users == null || users.isEmpty) {
    // Fallback para dados padrão do widget
    return const <double>[
      3500.0, 4200.0, 1800.0, 21000.0, 19000.0, 20000.0,
      17000.0, 16000.0, 34000.0, 22000.0, 20000.0, 15000.0,
    ];
  }
  final List<double> counts = List<double>.filled(12, 0);
  final int currentYear = DateTime.now().year;
  for (final u in users) {
    final DateTime? dt = u.createdTime ?? u.data ?? u.tempo;
    if (dt == null) continue;
    if (dt.year == currentYear) {
      final int mi = dt.month - 1;
      if (mi >= 0 && mi < 12) counts[mi] = counts[mi] + 1;
    }
  }
  return counts;
}
double _niceMax(List<double> vals) {
  double m = 0.0;
  for (final v in vals) {
    if (v > m) m = v;
  }
  const double step = 5000.0;
  final int k = ((m + step - 1) ~/ step);
  final double r = k * step;
  return r < 40000.0 ? 40000.0 : r;
}

double _valToY(double v, double chartH, double maxY) {
  final double t = (v / maxY).clamp(0.0, 1.0);
  return chartH * (1.0 - t);
}

String _fmt(double v) {
  if (v >= 1000.0) {
    final int k = (v / 1000.0).round();
    return '${k}k';
  }
  return v.toStringAsFixed(0);
}
