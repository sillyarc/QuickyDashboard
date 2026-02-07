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

import 'dart:ui' as ui show TextDirection;

class ContainerInformacoesPrincipais extends StatefulWidget {
  const ContainerInformacoesPrincipais({
    super.key,
    this.width,
    this.height,
    this.titulo,
    this.subTitulo,
    this.descricao,
    this.iconPrincipal,
    this.iconCalculo,
  });

  final double? width;
  final double? height;
  final String? titulo; // ex.: "Rides" / "Growth" / "Revenue"
  final String? subTitulo; // ex.: "350" / "25%" / "$ 1.000,0..."
  final String? descricao; // ex.: "+$1,200 from last month"
  final Widget? iconPrincipal;
  final Widget? iconCalculo;

  @override
  State<ContainerInformacoesPrincipais> createState() =>
      _ContainerInformacoesPrincipaisState();
}

class _ContainerInformacoesPrincipaisState
    extends State<ContainerInformacoesPrincipais> {
  // -------- Paleta / layout --------
  static const Color _card = Color(0xFF3A3A3A);
  static const Color _leftPane = Color(0xFF1F1F1F); // cor igual ao mock 2
  static const Color _badgeBg = Color(0xFF2F2F2F);
  static const Color _text = Colors.white;
  static const Color _accentDown = Color(0xFFEF4444);
  static const Color _accentUp = Color(0xFF22C55E);

  // ===== Tamanhos fixos p/ uniformidade =====
  static const double _subtitleFontPx = 18.0; // subtítulo menor e igual
  static const double _titleFontPx = 12.0;
  static const double _descFontPx = 12.0; // descrição um pouco maior

  // Compressão horizontal mínima
  static const double _minHScale = 0.70;

  // Força tamanho e cor BRANCA em qualquer widget de ícone/imagem.
  Widget _whiteIconEnforced(Widget? icon, IconData fallback, double size) {
    if (icon == null) {
      return Icon(fallback, size: size, color: _text);
    }
    if (icon is Icon) {
      // Enforce tamanho/cor mesmo que o Icon original tenha outra cor
      return Icon(icon.icon, size: size, color: _text);
    }
    // Para outros widgets (ex.: imagens, FaIcon, SVG wrapped), garantimos:
    return SizedBox(
      width: size,
      height: size,
      child: ColorFiltered(
        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        child: IconTheme(
          data: IconThemeData(size: size, color: _text),
          child: FittedBox(child: icon),
        ),
      ),
    );
  }

  // Calcula scaleX para caber na largura mantendo a ALTURA da fonte
  double _horizontalScaleToFit({
    required BuildContext context,
    required String text,
    required TextStyle style,
    required double maxWidth,
  }) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: ui.TextDirection.ltr,
      textScaleFactor: MediaQuery.of(context).textScaleFactor,
    )..layout();
    final w = tp.width;
    if (w <= maxWidth) return 1.0;
    return (maxWidth / w).clamp(_minHScale, 1.0);
  }

  Color _inferTrendColor(String? desc) {
    if (desc == null) return _accentDown;
    final s = desc.replaceAll('−', '-');
    if (s.contains('+')) return _accentUp;
    if (s.contains('-')) return _accentDown;
    return _accentDown;
  }

  @override
  Widget build(BuildContext context) {
    final double w = widget.width ?? 216.0;
    final double h = widget.height ?? 72.0;
    const double r = 14.0;

    final String title = (widget.titulo?.trim().isNotEmpty ?? false)
        ? widget.titulo!.trim()
        : 'Título';
    final String? bigValue = (widget.subTitulo?.trim().isNotEmpty ?? false)
        ? widget.subTitulo!.trim()
        : null;
    final String? smallDesc = (widget.descricao?.trim().isNotEmpty ?? false)
        ? widget.descricao!.trim()
        : null;

    final double paneW = (h * 1.22).clamp(64.0, w * 0.50);
    final Color trendColor = _inferTrendColor(smallDesc);

    // ===== Estilos (px fixos) =====
    final titleStyle = FlutterFlowTheme.of(context).bodySmall.copyWith(
          color: Colors.white.withOpacity(.92),
          fontWeight: FontWeight.w700,
          fontSize: _titleFontPx,
          letterSpacing: .2,
          height: 1.0,
        );

    final subtitleStyle = FlutterFlowTheme.of(context).bodyMedium.copyWith(
          color: _text,
          fontWeight: FontWeight.w800,
          fontSize: _subtitleFontPx,
          height: 1.0,
          letterSpacing: -0.2,
        );

    final descStyle = FlutterFlowTheme.of(context).bodySmall.copyWith(
          color: Colors.white.withOpacity(.90),
          fontSize: _descFontPx,
          fontStyle: FontStyle.italic,
          height: 1.05,
        );

    return ClipRRect(
      borderRadius: BorderRadius.circular(r),
      child: Container(
        width: w,
        height: h,
        decoration: const BoxDecoration(
          color: _card,
          boxShadow: [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 10,
              offset: Offset(0, 5),
            )
          ],
        ),
        child: Row(
          children: [
            // ---------- Painel esquerdo ----------
            SizedBox(
              width: paneW,
              height: double.infinity,
              child: ClipPath(
                clipper: _LeftBevelClipper(cutAt: 0.80),
                child: Container(
                  color: _leftPane,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: paneW * 0.10),
                  // Ícone principal: maior e SEMPRE branco
                  child: _whiteIconEnforced(
                    widget.iconPrincipal,
                    Icons.person,
                    h * 0.32, // ↑ maior, uniforme com o card
                  ),
                ),
              ),
            ),

            // ---------------------- Centro ----------------------
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: h * 0.12,
                  vertical: h * 0.08,
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final maxW = constraints.maxWidth;

                    final subScaleX = (bigValue == null)
                        ? 1.0
                        : _horizontalScaleToFit(
                            context: context,
                            text: bigValue!,
                            style: subtitleStyle,
                            maxWidth: maxW,
                          );

                    final descScaleX = (smallDesc == null)
                        ? 1.0
                        : _horizontalScaleToFit(
                            context: context,
                            text: smallDesc!,
                            style: descStyle,
                            maxWidth: maxW,
                          );

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textHeightBehavior: const TextHeightBehavior(
                            applyHeightToFirstAscent: false,
                            applyHeightToLastDescent: false,
                          ),
                          style: titleStyle,
                        ),
                        SizedBox(height: h * 0.02),

                        if (bigValue != null)
                          SizedBox(
                            width: maxW,
                            child: Transform(
                              alignment: Alignment.centerLeft,
                              transform:
                                  Matrix4.diagonal3Values(subScaleX, 1.0, 1.0),
                              child: Text(
                                bigValue!,
                                maxLines: 1,
                                softWrap: false,
                                overflow: TextOverflow.visible,
                                textHeightBehavior: const TextHeightBehavior(
                                  applyHeightToFirstAscent: false,
                                  applyHeightToLastDescent: false,
                                ),
                                style: subtitleStyle,
                              ),
                            ),
                          ),

                        // Menor espaço para aproximar da badge (como no mock)
                        if (smallDesc != null) ...[
                          SizedBox(height: h * 0.05),
                          SizedBox(
                            width: maxW,
                            child: Transform(
                              alignment: Alignment.centerLeft,
                              transform:
                                  Matrix4.diagonal3Values(descScaleX, 1.0, 1.0),
                              child: Text(
                                smallDesc!,
                                maxLines: 1,
                                softWrap: false,
                                overflow: TextOverflow.visible,
                                textHeightBehavior: const TextHeightBehavior(
                                  applyHeightToFirstAscent: false,
                                  applyHeightToLastDescent: false,
                                ),
                                style: descStyle,
                              ),
                            ),
                          ),
                        ],
                      ],
                    );
                  },
                ),
              ),
            ),

            // ---------------- Badge direito (um pouco mais alto) ----------------
            Padding(
              padding: EdgeInsets.only(right: h * 0.14),
              child: Transform.translate(
                offset: Offset(0, -h * 0.06), // sobe um pouquinho
                child: Container(
                  width: h * 0.38,
                  height: h * 0.38,
                  decoration: BoxDecoration(
                    color: _badgeBg,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.28),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: _whiteIconEnforced(
                      widget.iconCalculo,
                      Icons.arrow_upward_rounded, // fallback
                      h * 0.17, // menor e proporcional
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LeftBevelClipper extends CustomClipper<Path> {
  const _LeftBevelClipper({this.cutAt = 0.80});
  final double cutAt;

  @override
  Path getClip(Size size) {
    final double w = size.width;
    final double h = size.height;
    final double cut = w * cutAt;
    return Path()
      ..moveTo(0, 0)
      ..lineTo(cut, 0)
      ..lineTo(cut - (h * 0.20), h)
      ..lineTo(0, h)
      ..close();
  }

  @override
  bool shouldReclip(covariant _LeftBevelClipper oldClipper) => false;
}
