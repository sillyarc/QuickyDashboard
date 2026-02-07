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

class LifeTime extends StatefulWidget {
  const LifeTime({
    super.key,
    this.width,
    this.height,

    // Extras opcionais (compatibilidade com FF; pode ignorar)
    this.titulo, // se quiser mudar o rótulo (default: "Lifetime")
    this.icone, // "calendar", "time", "date" (default: calendar)
    this.sublinhar, // exibir sublinhado (default: true)
    this.onTapHint, // label de acessibilidade do toque (opcional)

    // params antigos que possam existir na configuração do FF (não usados aqui)
    this.valor,
    this.sufixo,
    this.tendencia,
    this.corDestaque,
  });

  final double? width;
  final double? height;

  // ---- usados neste chip ----
  final String? titulo;
  final String? icone;
  final bool? sublinhar;
  final String? onTapHint;

  // ---- ignorados (compat) ----
  final String? valor;
  final String? sufixo;
  final String? tendencia;
  final Color? corDestaque;

  @override
  State<LifeTime> createState() => _LifeTimeState();
}

class _LifeTimeState extends State<LifeTime> {
  // Paleta próxima ao mock
  static const Color _pill = Color(0xFF343434); // fundo do chip
  static const Color _text = Colors.white; // ícones e texto
  static const Color _shadow = Colors.black; // sombra externa

  @override
  Widget build(BuildContext context) {
    final double w = widget.width ?? 220;
    final double h = widget.height ?? 48;
    final double r = h / 2; // pill

    final String label =
        (widget.titulo == null || widget.titulo!.trim().isEmpty)
            ? 'Lifetime'
            : widget.titulo!.trim();

    final bool underline = widget.sublinhar ?? true;

    final IconData leadingIcon = _iconFromString(widget.icone);

    return Semantics(
      button: true,
      label: widget.onTapHint ?? 'Filtro $label',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(r),
        child: Container(
          width: w,
          height: h,
          decoration: BoxDecoration(
            color: _pill,
            boxShadow: [
              // sombra suave para dar volume como no mock
              BoxShadow(
                color: _shadow.withOpacity(0.45),
                blurRadius: 18,
                spreadRadius: 0,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: _shadow.withOpacity(0.25),
                blurRadius: 8,
                spreadRadius: -2,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // leve brilho superior para dar “vidro” suave
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: h * 0.55,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withOpacity(0.04),
                        Colors.white.withOpacity(0.01),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),

              // conteúdo
              Row(
                children: [
                  SizedBox(width: h * 0.38),
                  Icon(leadingIcon, color: _text, size: h * 0.44),
                  SizedBox(width: h * 0.26),

                  // label
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: FlutterFlowTheme.of(context).titleSmall.copyWith(
                              color: _text,
                              fontWeight: FontWeight.w700,
                              fontSize: h * 0.38, // ~18 em h=48
                              decoration:
                                  underline ? TextDecoration.underline : null,
                              decorationColor:
                                  underline ? _text : Colors.transparent,
                              decorationThickness: underline ? 1.5 : null,
                              height: 1.0,
                            ),
                      ),
                    ),
                  ),

                  // seta
                  Padding(
                    padding: EdgeInsets.only(right: h * 0.34),
                    child: Icon(
                      Icons.expand_more_rounded,
                      color: _text,
                      size: h * 0.42,
                    ),
                  ),
                ],
              ),

              // toque visual (ripple) opcional
              Material(
                type: MaterialType.transparency,
                child: InkWell(
                  borderRadius: BorderRadius.circular(r),
                  splashColor: Colors.white.withOpacity(0.06),
                  highlightColor: Colors.white.withOpacity(0.03),
                  onTap: () {
                    // Deixe vazio para o FF acoplar ações por fora (Gesture Wrapper)
                    // ou use como botão “visual”.
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Converte nome simples em ícone
IconData _iconFromString(String? name) {
  final s = (name ?? 'calendar').toLowerCase();
  if (s.contains('time') || s.contains('lifetime') || s.contains('schedule')) {
    return Icons.schedule_rounded;
  }
  if (s.contains('date') || s.contains('calendar')) {
    return Icons.calendar_month_rounded;
  }
  return Icons.calendar_month_rounded;
}
