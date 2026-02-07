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

class TaxiDriver extends StatefulWidget {
  const TaxiDriver({
    super.key,
    this.width,
    this.height,
    // do esqueleto
    required this.users,
    required this.rides,
    required this.country,
    this.state,
    this.profileImage,
    this.gradientStart,
    this.gradientEnd,
    this.messagePressed,
    this.callPressed,
    this.emailPressed,
    this.morePressed,
    // nome do motorista (opcional)
    this.driverName,
  });

  final double? width;
  final double? height;

  // Base original
  final DocumentReference users;
  final int rides;
  final String country;
  final String? state;
  final String? profileImage;

  // Estilo
  final Color? gradientStart;
  final Color? gradientEnd;

  // Callbacks
  final Future<void> Function()? messagePressed;
  final Future<void> Function()? callPressed;
  final Future<void> Function()? emailPressed;
  final Future<void> Function()? morePressed;

  // Dados
  final String? driverName;

  @override
  State<TaxiDriver> createState() => _TaxiDriverState();
}

class _TaxiDriverState extends State<TaxiDriver> {
  // Dimensões base
  static const double _cardRadius = 20;
  static const double _wedgeWidth = 118; // largura da faixa preta
  static const double _avatarSize = 64;
  static const double _circleBtnSize = 42;

  Color get _start => widget.gradientStart ?? const Color(0xFFFFA726);
  Color get _end => widget.gradientEnd ?? const Color(0xFFFF8F00);

  @override
  Widget build(BuildContext context) {
    // Altura fixa e segura para evitar overflow
    final double cardHeight =
        widget.height ?? 118; // coerente com o mock (entre 110 e 120)
    final double cardWidth = widget.width ?? double.infinity;

    return SizedBox(
      width: cardWidth,
      height: cardHeight,
      child: _card(cardHeight),
    );
  }

  Widget _card(double height) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(_cardRadius),
      elevation: 6,
      shadowColor: Colors.black.withOpacity(.35),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_cardRadius),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [_start, _end],
          ),
        ),
        child: Stack(
          children: [
            // Faixa preta à esquerda com corte diagonal
            _leftWedge(),
            // Conteúdo principal
            Positioned.fill(child: _content()),
            // Botão de ações
            _topRightActions(),
          ],
        ),
      ),
    );
  }

  Widget _leftWedge() {
    return Align(
      alignment: Alignment.centerLeft,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(_cardRadius),
          bottomLeft: Radius.circular(_cardRadius),
        ),
        child: SizedBox(
          width: _wedgeWidth,
          child: ClipPath(
            clipper: _DiagonalClipper(),
            child: Container(
              color: const Color(0xFF383838),
              child: Center(child: _avatar()),
            ),
          ),
        ),
      ),
    );
  }

  Widget _avatar() {
    final hasImage =
        widget.profileImage != null && widget.profileImage!.trim().isNotEmpty;

    return Container(
      width: _avatarSize,
      height: _avatarSize,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: ClipOval(
        child: hasImage
            ? Image.network(
                widget.profileImage!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _checkboardPlaceholder(),
                loadingBuilder: (c, child, p) =>
                    p == null ? child : _checkboardPlaceholder(),
              )
            : _checkboardPlaceholder(),
      ),
    );
  }

  // Placeholder quadriculado (sem assets externos)
  Widget _checkboardPlaceholder() {
    return CustomPaint(
      painter: _CheckboardPainter(),
      child: Container(color: Colors.transparent),
    );
  }

  Widget _content() {
    final String name =
        (widget.driverName == null || widget.driverName!.trim().isEmpty)
            ? 'Taxi Driver' // título default branco, como você pediu
            : widget.driverName!.trim();

    return Padding(
      // espaço para a faixa preta + respiro
      padding: const EdgeInsets.only(left: _wedgeWidth + 12, right: 16),
      child: Row(
        children: [
          // Nome + botões
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nome do motorista (branco, grande e pesado)
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28, // maior para o look do mock
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 12),
                // Ícones (dentro do card, sem passar da borda)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _roundIconButton(
                      icon: Icons.chat_bubble_outline,
                      onTap: widget.messagePressed,
                    ),
                    const SizedBox(width: 14),
                    _roundIconButton(
                      icon: Icons.phone_iphone,
                      onTap: widget.callPressed,
                    ),
                    const SizedBox(width: 14),
                    _roundIconButton(
                      icon: Icons.email_outlined,
                      onTap: widget.emailPressed,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Rides + Local (alinhado à direita)
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(height: 2),
              Text(
                '${widget.rides} Rides',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'From ${widget.country}${(widget.state != null && widget.state!.trim().isNotEmpty) ? ', ${widget.state}' : ''}',
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
            ],
          ),
        ],
      ),
    );
  }

  Widget _topRightActions() {
    return Positioned(
      top: 8,
      right: 10,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        elevation: 2,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () async {
            if (widget.morePressed != null) {
              await widget.morePressed!();
            }
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Icon(Icons.more_horiz, size: 20, color: Color(0xFF333333)),
          ),
        ),
      ),
    );
  }

  Widget _roundIconButton({
    required IconData icon,
    Future<void> Function()? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap == null ? null : () async => await onTap(),
        child: Ink(
          width: _circleBtnSize,
          height: _circleBtnSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFEDEDED), Color(0xFFD9D9D9)],
            ),
            border: Border.all(color: Colors.white.withOpacity(.9), width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.25),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, size: 22, color: const Color(0xFF333333)),
        ),
      ),
    );
  }
}

// recorta a borda direita da faixa preta com diagonal
class _DiagonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final p = Path();
    // topo esquerdo -> topo (um pouco antes da borda) -> vértice central -> base -> base esquerda
    p.moveTo(0, 0);
    p.lineTo(size.width - 26, 0);
    p.lineTo(size.width, size.height / 2);
    p.lineTo(size.width - 26, size.height);
    p.lineTo(0, size.height);
    p.close();
    return p;
  }

  @override
  bool shouldReclip(_DiagonalClipper oldClipper) => false;
}

/// Placeholder quadriculado para avatar
class _CheckboardPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const light = Color(0xFFE6E6E6);
    const dark = Color(0xFFBDBDBD);
    final paint = Paint();
    const cell = 8.0;
    for (double y = 0; y < size.height; y += cell) {
      for (double x = 0; x < size.width; x += cell) {
        final isDark = (((x / cell).floor() + (y / cell).floor()) % 2 == 0);
        paint.color = isDark ? dark : light;
        canvas.drawRect(Rect.fromLTWH(x, y, cell, cell), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
