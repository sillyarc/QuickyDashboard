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

class LocalsTourists extends StatefulWidget {
  const LocalsTourists({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  State<LocalsTourists> createState() => _LocalsTouristsState();
}

class _LocalsTouristsState extends State<LocalsTourists> {
  // Colors
  final Color _panel = const Color(0xFF3C3C3C);
  final Color _shadow = Colors.black26;

  // Palette
  static const Color _localsFill = Colors.white;
  static const Color _touristsFill = Color(0xFFFFA000);
  static const Color _donutTrack = Colors.white;
  static const Color _donutArc = Color(0xFFFFA000);

  // Months
  final List<String> _months = const ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];

  // Fake data (0..10)
  final List<double> _locals = const [3.0, 9.5, 6.2, 3.4, 8.2, 6.0];
  final List<double> _tourists = const [5.2, 3.6, 4.1, 6.1, 3.0, 4.4];

  // Donut percent
  final double _donutPct = 0.72;

  double _scaleFor(double h) => ((h / 150.0)).clamp(0.85, 1.2);

  @override
  Widget build(BuildContext context) {
    final double w = widget.width ?? double.infinity;
    final double h = widget.height ?? 150.0;
    final double s = _scaleFor(h);

    final double gapLR = 22.0 * s;

    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: _panel,
        borderRadius: BorderRadius.circular(14 * s),
        boxShadow: [
          BoxShadow(
              blurRadius: 8 * s, offset: Offset(0, 3 * s), color: _shadow),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      padding: EdgeInsets.symmetric(horizontal: 12 * s, vertical: 8 * s),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left: Users bars
          Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.only(right: gapLR),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TinyTitle('Users', scale: s),
                  SizedBox(height: 4 * s),
                  Expanded(
                    child: _GroupedBars(
                      months: _months,
                      locals: _locals,
                      tourists: _tourists,
                      localsColor: _localsFill,
                      touristsColor: _touristsFill,
                      scale: s,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Right: Donut + legend
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.only(left: gapLR),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TinyTitle('Top Selling', scale: s),
                  SizedBox(height: 6 * s),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (_, c) {
                        final double donutSize =
                            _donutSize(c.maxWidth, c.maxHeight, s);
                        final double stroke =
                            (donutSize * 0.24).clamp(12.0 * s, 18.0 * s);

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: donutSize,
                              height: donutSize,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  CustomPaint(
                                    size: Size.square(donutSize),
                                    painter: _DonutPainter(
                                      pct: _donutPct,
                                      track: _donutTrack,
                                      arc: _donutArc,
                                      stroke: stroke,
                                    ),
                                  ),
                                  Text(
                                    '150',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      fontSize: (16 * s).clamp(13, 18),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 14 * s),
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: _Legend(scale: s),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 6 * s, top: 4 * s),
                    child: Text(
                      'Lorem ipsum',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: (11 * s).clamp(10, 13),
                        fontWeight: FontWeight.w800,
                        letterSpacing: .1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _donutSize(double maxW, double maxH, double s) {
    final double byW = maxW * 0.52;
    final double byH = maxH * 0.80;
    final double t = byW < byH ? byW : byH;
    return t.clamp(64.0 * s, 98.0 * s);
  }
}

// ---------------- Bars (no border, small radius) ----------------

class _GroupedBars extends StatelessWidget {
  const _GroupedBars({
    required this.months,
    required this.locals,
    required this.tourists,
    required this.localsColor,
    required this.touristsColor,
    required this.scale,
  });

  final List<String> months;
  final List<double> locals; // 0..10
  final List<double> tourists; // 0..10
  final Color localsColor;
  final Color touristsColor;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final double barW = (14 * scale).clamp(10.0, 18.0);
    final double topRadius = (3 * scale).clamp(2.0, 4.0);
    final double baseRadius = (1 * scale).clamp(0.5, 2.0);
    final double innerGap = (8 * scale).clamp(6.0, 10.0);

    return LayoutBuilder(
      builder: (_, c) {
        final double labelH = (26.0 * scale).clamp(20.0, 32.0);
        final double barsH = (c.maxHeight - labelH).clamp(40.0, c.maxHeight);

        return Column(
          children: [
            SizedBox(
              height: barsH,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(months.length, (i) {
                  final double lRatio = (locals[i] / 10).clamp(0.0, 1.0);
                  final double tRatio = (tourists[i] / 10).clamp(0.0, 1.0);

                  return Expanded(
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _SolidBar(
                            heightFactor: 0.78 * lRatio + 0.12,
                            width: barW,
                            topRadius: topRadius,
                            bottomRadius: baseRadius,
                            color: localsColor,
                          ),
                          SizedBox(width: innerGap),
                          _SolidBar(
                            heightFactor: 0.78 * tRatio + 0.12,
                            width: barW,
                            topRadius: topRadius,
                            bottomRadius: baseRadius,
                            color: touristsColor,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
            SizedBox(height: 6 * scale),
            SizedBox(
              height: labelH - (6 * scale),
              child: Row(
                children: List.generate(months.length, (i) {
                  return Expanded(
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          months[i],
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.95),
                            fontSize: (12 * scale).clamp(11, 14),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SolidBar extends StatelessWidget {
  const _SolidBar({
    required this.heightFactor,
    required this.width,
    required this.topRadius,
    required this.bottomRadius,
    required this.color,
  });

  final double heightFactor; // 0..1
  final double width;
  final double topRadius;
  final double bottomRadius;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        heightFactor: heightFactor,
        alignment: Alignment.bottomCenter,
        child: Container(
          width: width,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(topRadius),
              topRight: Radius.circular(topRadius),
              bottomLeft: Radius.circular(bottomRadius),
              bottomRight: Radius.circular(bottomRadius),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------- Titles, legend and donut ----------------

class _TinyTitle extends StatelessWidget {
  const _TinyTitle(this.text, {required this.scale});
  final String text;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white70,
        fontWeight: FontWeight.w700,
        fontSize: (12 * scale).clamp(11, 13),
        letterSpacing: .2,
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.scale});
  final double scale;

  @override
  Widget build(BuildContext context) {
    const Color locals = Colors.white;
    const Color tourists = Color(0xFFFFA000);
    final double dot = (10.0 * scale).clamp(8.0, 12.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _LegendItem(color: locals, label: 'Locals', scale: scale, dot: dot),
        SizedBox(height: (10 * scale).clamp(8.0, 12.0)),
        _LegendItem(color: tourists, label: 'Tourists', scale: scale, dot: dot),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.color,
    required this.label,
    required this.scale,
    required this.dot,
  });

  final Color color;
  final String label;
  final double scale;
  final double dot;

  @override
  Widget build(BuildContext context) {
    final double font = (14 * scale).clamp(12.0, 16.0);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            width: dot,
            height: dot,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        SizedBox(width: (10 * scale).clamp(8.0, 12.0)),
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: font,
            fontWeight: FontWeight.w800,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}

class _DonutPainter extends CustomPainter {
  _DonutPainter({
    required this.pct,
    required this.track,
    required this.arc,
    required this.stroke,
  });

  final double pct; // 0..1
  final Color track; // donut track color
  final Color arc; // donut arc color
  final double stroke; // donut thickness

  @override
  void paint(Canvas canvas, Size size) {
    final double r = (size.shortestSide - stroke) / 2;

    final Paint trackPaint = Paint()
      ..color = track
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    final Paint arcPaint = Paint()
      ..color = arc
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    final Rect rect =
        Rect.fromCircle(center: size.center(Offset.zero), radius: r);

    canvas.drawArc(rect, 0, 2 * 3.1415926535, false, trackPaint);
    final double start = -3.1415926535 / 2;
    final double sweep = (2 * 3.1415926535) * pct;
    canvas.drawArc(rect, start, sweep, false, arcPaint);
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) {
    return oldDelegate.pct != pct ||
        oldDelegate.stroke != stroke ||
        oldDelegate.arc != arc ||
        oldDelegate.track != track;
  }
}
