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

import 'package:cloud_firestore/cloud_firestore.dart';

class LocalDriver extends StatefulWidget {
  const LocalDriver({
    super.key,
    this.width,
    this.height,
    required this.users, // DocumentReference do motorista
    required this.rides, // Nº de corridas
    required this.country, // País
    this.state, // Estado (opcional)
    this.profileImege, // URL da foto (opcional; mantém nome do base)
    this.messagePressed, // Callback chat
    this.callPressed, // Callback telefone
    this.emailPressed, // Callback e-mail
    this.actionPressed, // Callback do botão quadradinhos (opcional)
  });

  final double? width;
  final double? height;
  final DocumentReference users;
  final int rides;
  final String country;
  final String? state;
  final String? profileImege;

  final Future Function()? messagePressed;
  final Future Function()? callPressed;
  final Future Function()? emailPressed;
  final Future Function()? actionPressed;

  @override
  State<LocalDriver> createState() => _LocalDriverState();
}

class _LocalDriverState extends State<LocalDriver> {
  static const _gold = Color(0xFFE0B64A); // dourado do contorno
  static const _cardRadius = 20.0;

  @override
  Widget build(BuildContext context) {
    final ffTheme = FlutterFlowTheme.of(context);
    final ref = widget.users as DocumentReference<Object?>;

    return StreamBuilder<DocumentSnapshot<Object?>>(
      stream: ref.snapshots(),
      builder: (context, snap) {
        String name = 'Driver';
        String? photoUrl;

        if (snap.hasData && snap.data!.exists) {
          final data = snap.data!.data() as Map<String, dynamic>?;
          photoUrl = (widget.profileImege != null &&
                  widget.profileImege!.trim().isNotEmpty)
              ? widget.profileImege
              : (data?['photo_url'] as String? ??
                  data?['photoUrl'] as String? ??
                  data?['avatar'] as String?);

          final n = (data?['display_name'] ??
              data?['displayName'] ??
              data?['name'] ??
              '') as String?;
          if (n != null && n.trim().isNotEmpty) name = n.trim();
        }

        final location = (widget.state == null || widget.state!.trim().isEmpty)
            ? 'From ${widget.country}'
            : 'From ${widget.country}, ${widget.state}';

        return LayoutBuilder(builder: (context, constraints) {
          final maxW = widget.width ??
              (constraints.hasBoundedWidth
                  ? constraints.maxWidth
                  : MediaQuery.sizeOf(context).width);
          final scale = ((maxW) / 390).clamp(0.85, 1.35);
          final cardH = (widget.height ?? 120.0) * scale;

          return ConstrainedBox(
            constraints: BoxConstraints(minHeight: cardH),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // CARD PRINCIPAL (branco)
                Container(
                  width: widget.width ?? double.infinity,
                  height: cardH,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(_cardRadius),
                    border: Border.all(color: const Color(0x11000000)),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 16,
                        offset: Offset(0, 8),
                        color: Color(0x1A000000),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // FAIXA ESQUERDA ESCURA COM CHANFRO BRANCO + AVATAR
                      _LeftPane(
                        height: cardH,
                        scale: scale,
                        imageUrl: photoUrl,
                      ),
                      // CONTEÚDO
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                              14 * scale, 14 * scale, 16 * scale, 14 * scale),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // NOME
                              Text(
                                name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: ffTheme.titleLarge.copyWith(
                                  color: const Color(0xFF2B2B2B),
                                  fontSize: (22 * scale).clamp(18, 28),
                                  fontWeight: FontWeight.w800,
                                  fontStyle: FontStyle.italic,
                                  letterSpacing: 0.2,
                                ),
                              ),
                              SizedBox(height: 10 * scale),
                              // AÇÕES + INFO
                              Expanded(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    _ActionButtonsRow(
                                      scale: scale,
                                      onChat: widget.messagePressed,
                                      onCall: widget.callPressed,
                                      onEmail: widget.emailPressed,
                                    ),
                                    const Spacer(),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          '${widget.rides} Rides',
                                          style: ffTheme.bodyLarge.copyWith(
                                            color: const Color(0xFF2B2B2B),
                                            fontWeight: FontWeight.w700,
                                            fontSize:
                                                (14 * scale).clamp(12, 18),
                                          ),
                                        ),
                                        SizedBox(height: 4 * scale),
                                        Text(
                                          location,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: ffTheme.bodyMedium.copyWith(
                                            color: const Color(0xFF4D4D4D),
                                            fontWeight: FontWeight.w600,
                                            fontSize:
                                                (12 * scale).clamp(11, 16),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // BOTÃO DE AÇÕES (dois quadradinhos contorno dourado)
                Positioned(
                  right: 10 * scale,
                  top: 8 * scale,
                  child: _TwinSquaresActionButton(
                    scale: scale,
                    gold: _gold,
                    onTap: widget.actionPressed,
                  ),
                ),

                // Skeleton simples enquanto carrega
                if (!(snap.hasData && snap.data!.exists))
                  Positioned.fill(
                    child: IgnorePointer(
                      ignoring: true,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(_cardRadius),
                          color: Colors.white.withOpacity(0.02),
                        ),
                        child: const Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        });
      },
    );
  }
}

/* ==================== PARTES VISUAIS ==================== */

class _LeftPane extends StatelessWidget {
  const _LeftPane({
    required this.height,
    required this.scale,
    this.imageUrl,
  });

  final double height;
  final double scale;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    const leftBg = Color(0xFF2F2F2F); // <- agora a cor está local
    final paneW = (height * 0.78).clamp(84.0, 138.0);
    final avatarSize = (height * 0.46).clamp(44.0, 84.0);
    final wedge = (22.0 * scale).clamp(16.0, 30.0); // largura do chanfro branco

    return SizedBox(
      width: paneW,
      height: height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Bloco escuro arredondado
          Container(
            width: paneW,
            decoration: BoxDecoration(
              color: leftBg,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(28 * scale),
                bottomLeft: Radius.circular(28 * scale),
                topRight: Radius.circular(12 * scale),
                bottomRight: Radius.circular(12 * scale),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x22000000),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
          ),
          // Chanfro branco
          Positioned.fill(
            child: CustomPaint(
              painter: _WhiteChamferPainter(
                color: Colors.white,
                wedge: wedge,
              ),
            ),
          ),
          // Avatar centralizado
          Positioned.fill(
            child: Center(
              child: _Avatar(
                size: avatarSize,
                imageUrl: imageUrl,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.size, this.imageUrl});
  final double size;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl != null && imageUrl!.trim().isNotEmpty;

    final placeholder = ClipOval(
      child: CustomPaint(
        size: Size.square(size),
        painter: _CheckerPainter(),
      ),
    );

    if (!hasImage) {
      return SizedBox(width: size, height: size, child: placeholder);
    }

    return ClipOval(
      child: Image.network(
        imageUrl!,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            SizedBox(width: size, height: size, child: placeholder),
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return SizedBox(
            width: size,
            height: size,
            child:
                const Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        },
      ),
    );
  }
}

/// Botões metálicos (chat / call / mail)
class _ActionButtonsRow extends StatelessWidget {
  const _ActionButtonsRow({
    required this.scale,
    this.onChat,
    this.onCall,
    this.onEmail,
  });

  final double scale;
  final Future Function()? onChat;
  final Future Function()? onCall;
  final Future Function()? onEmail;

  @override
  Widget build(BuildContext context) {
    final btnSize = (44 * scale).clamp(36, 56).toDouble();
    final iconSize = (22 * scale).clamp(18, 26).toDouble();
    final gap = (10 * scale).clamp(6, 14).toDouble();

    return Row(
      children: [
        _MetalCircleButton(
          size: btnSize,
          icon: Icons.chat_bubble_outline_rounded,
          iconSize: iconSize,
          onTap: onChat,
        ),
        SizedBox(width: gap),
        _MetalCircleButton(
          size: btnSize,
          icon: Icons.phone_android_rounded,
          iconSize: iconSize,
          onTap: onCall,
        ),
        SizedBox(width: gap),
        _MetalCircleButton(
          size: btnSize,
          icon: Icons.mail_outline_rounded,
          iconSize: iconSize,
          onTap: onEmail,
        ),
      ],
    );
  }
}

class _MetalCircleButton extends StatelessWidget {
  const _MetalCircleButton({
    required this.size,
    required this.icon,
    required this.iconSize,
    this.onTap,
  });

  final double size;
  final IconData icon;
  final double iconSize;
  final Future Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap == null ? null : () async => onTap!.call(),
        child: Container(
          width: size,
          height: size,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFE8EEF4), Color(0xFFB7C1CB)],
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0x2A000000),
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Icon(icon, size: iconSize, color: Colors.black87),
        ),
      ),
    );
  }
}

/// Botão com **dois quadradinhos** (preto com contorno dourado), como no mock.
class _TwinSquaresActionButton extends StatelessWidget {
  const _TwinSquaresActionButton({
    required this.scale,
    required this.gold,
    this.onTap,
  });

  final double scale;
  final Color gold;
  final Future Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final w = (46 * scale).clamp(36, 52).toDouble();
    final s = (18 * scale).clamp(14, 22).toDouble();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap == null ? null : () async => onTap!.call(),
        child: Container(
          width: w,
          height: w * 0.82,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: const [
              BoxShadow(
                color: Color(0x26000000),
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          padding: EdgeInsets.all((6 * scale).clamp(4, 8)),
          child: Stack(
            children: [
              Positioned(
                right: 2,
                top: 2,
                child: _GoldSquare(size: s, gold: gold),
              ),
              Positioned(
                left: 2,
                bottom: 2,
                child: _GoldSquare(size: s, gold: gold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GoldSquare extends StatelessWidget {
  const _GoldSquare({required this.size, required this.gold});
  final double size;
  final Color gold;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFF1B1B1B),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: gold, width: 2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
    );
  }
}

/// Triângulo branco que cria o chanfro na faixa esquerda.
class _WhiteChamferPainter extends CustomPainter {
  const _WhiteChamferPainter({required this.color, required this.wedge});
  final Color color;
  final double wedge;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final paint = Paint()..color = color;

    final path = Path()
      ..moveTo(w - wedge, 0)
      ..lineTo(w, 0)
      ..lineTo(w, h)
      ..lineTo(w - (wedge * 0.65), h)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _WhiteChamferPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.wedge != wedge;
}

/// Placeholder xadrez do avatar (igual ao mock).
class _CheckerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const c1 = Color(0xFF6B6B6B);
    const c2 = Color(0xFF9A9A9A);
    final paint1 = Paint()..color = c1;
    final paint2 = Paint()..color = c2;

    const cells = 6;
    final cellW = size.width / cells;
    final cellH = size.height / cells;

    for (int y = 0; y < cells; y++) {
      for (int x = 0; x < cells; x++) {
        final rect = Rect.fromLTWH(x * cellW, y * cellH, cellW, cellH);
        canvas.drawRect(rect, ((x + y) % 2 == 0) ? paint1 : paint2);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
