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

/// Clean, parse-safe widget that matches the second image exactly.
///
/// Fixes: all texts WHITE, smoother gradients, no clipped edge, no overflow,
/// icons slightly smaller, and Rides/From placed under rightmost icon.
class RidersLocalTaxi extends StatefulWidget {
  const RidersLocalTaxi({
    super.key,
    this.width,
    this.height,
    required this.users,
    required this.rides,
    required this.country,
    this.state,
    this.profileImage,
    this.mansegePressed,
    this.callPressed,
    this.emailPressed,
    this.showSectionTitle = false,
    this.sectionTitle = 'Riders',
  });

  final double? width;
  final double? height;
  final DocumentReference users; // UsersRecord reference
  final int rides;
  final String country;
  final String? state;
  final String? profileImage;
  final Future Function()? mansegePressed;
  final Future Function()? callPressed;
  final Future Function()? emailPressed;

  final bool showSectionTitle;
  final String sectionTitle;

  @override
  State<RidersLocalTaxi> createState() => _RidersLocalTaxiState();
}

class _RidersLocalTaxiState extends State<RidersLocalTaxi> {
  // === Helpers ===
  Widget _metalBtn(
      {required IconData icon,
      required double size,
      required double iconSize,
      Future Function()? onTap}) {
    return InkWell(
      onTap: onTap == null ? null : () async => onTap!.call(),
      customBorder: const CircleBorder(),
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFEAF1F8), Color(0xFFB5C0CB)],
          ),
          boxShadow: [
            BoxShadow(
                color: Color(0x55000000), blurRadius: 10, offset: Offset(0, 4))
          ],
        ),
        child: Icon(icon, size: iconSize, color: Colors.black87),
      ),
    );
  }

  Widget _squareBadge(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFF232323), width: 1.8),
        borderRadius: BorderRadius.circular(6),
        boxShadow: const [
          BoxShadow(
              color: Color(0x33000000), blurRadius: 3, offset: Offset(0, 1))
        ],
      ),
    );
  }

  Widget _toggle(double scale) {
    final w = (48 * scale).clamp(36, 56).toDouble();
    final s = (18 * scale).clamp(12, 22).toDouble();
    return Container(
      width: w,
      height: w * 0.78,
      padding: EdgeInsets.all((8 * scale).clamp(6, 10)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
              color: Color(0x55000000), blurRadius: 10, offset: Offset(0, 4))
        ],
      ),
      child: Stack(children: [
        Positioned(right: 0, top: 0, child: _squareBadge(s)),
        Positioned(left: 0, bottom: 0, child: _squareBadge(s)),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    // NOT using theme colors for text — force pure white to avoid black/purple
    const kWhite = Colors.white;

    return StreamBuilder<UsersRecord>(
      stream: UsersRecord.getDocument(widget.users),
      builder: (context, snapshot) {
        final maxW = widget.width ?? MediaQuery.sizeOf(context).width;
        final baseW =
            maxW.isFinite && maxW > 0 ? maxW : MediaQuery.sizeOf(context).width;

        final scale = (baseW / 768).clamp(0.70, 1.10);
        final cardH = (134.0 * scale).clamp(124.0, 176.0);
        final radius = 26.0 * scale;
        final toggleW = (48 * scale).clamp(36, 56).toDouble();
        final contentRightPad = 20 * scale + toggleW + 12 * scale;

        final user = snapshot.data;
        final name = (user?.displayName?.isNotEmpty ?? false)
            ? user!.displayName
            : 'Enzo Godoy';
        final photo = (widget.profileImage != null &&
                widget.profileImage!.trim().isNotEmpty)
            ? widget.profileImage!.trim()
            : (user?.photoUrl ?? '');

        // Optional white header above card
        final header = widget.showSectionTitle
            ? Padding(
                padding: EdgeInsets.only(left: 4 * scale, bottom: 10 * scale),
                child: Text(
                  widget.sectionTitle,
                  style: const TextStyle(
                    color: kWhite,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    fontStyle: FontStyle.italic,
                    letterSpacing: 0.2,
                  ),
                ),
              )
            : const SizedBox.shrink();

        final leftW = (cardH * 0.70).clamp(72.0, 118.0);
        final avatarSize = (cardH * 0.50).clamp(54.0, 86.0);

        final card = SizedBox(
          width: widget.width ?? double.infinity,
          height: widget.height ?? cardH,
          child: Stack(children: [
            // MAIN CARD with proper clip so corners never look "cortados"
            ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF3A3A3A), Color(0xFF464646)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Row(children: [
                  // LEFT STRIP — smoother gradient + left soft edge + diagonal fade
                  SizedBox(
                    width: leftW,
                    height: cardH,
                    child: Stack(children: [
                      Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [Color(0xFF232323), Color(0xFF3B3B3B)],
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(radius),
                            bottomLeft: Radius.circular(radius),
                            topRight: Radius.circular(radius * 0.35),
                            bottomRight: Radius.circular(radius * 0.35),
                          ),
                        ),
                      ),
                      // soft highlight at extreme left to fix "edge cut" look
                      Positioned(
                          left: 0,
                          top: 0,
                          bottom: 0,
                          child: Container(
                            width: 16,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [Color(0x22000000), Color(0x00000000)],
                              ),
                            ),
                          )),
                      // diagonal fade overlay — more gradient
                      Positioned.fill(
                          child: CustomPaint(
                              painter: _ChamferFadeStrongPainter())),

                      // centered avatar
                      Positioned.fill(
                        child: Center(
                          child: Container(
                            width: avatarSize,
                            height: avatarSize,
                            decoration:
                                const BoxDecoration(shape: BoxShape.circle),
                            clipBehavior: Clip.antiAlias,
                            child: photo.trim().isNotEmpty
                                ? Image.network(photo, fit: BoxFit.cover)
                                : Container(color: const Color(0xFF6B6B6B)),
                          ),
                        ),
                      ),
                    ]),
                  ),

                  // CONTENT
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                          16 * scale, 12 * scale, contentRightPad, 12 * scale),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // NAME — pure WHITE, bold + italic
                          Text(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: kWhite,
                              fontSize: (30 * scale).clamp(22, 36),
                              fontWeight: FontWeight.w900,
                              fontStyle: FontStyle.italic,
                              letterSpacing: 0.4,
                            ),
                          ),

                          // Bottom: icons row and right-aligned small meta below
                          Column(children: [
                            Row(children: [
                              _metalBtn(
                                  icon: Icons.chat_bubble_outline_rounded,
                                  size: (42 * scale).clamp(34, 48).toDouble(),
                                  iconSize:
                                      (18 * scale).clamp(16, 22).toDouble(),
                                  onTap: widget.mansegePressed),
                              SizedBox(
                                  width: (10 * scale).clamp(8, 12).toDouble()),
                              _metalBtn(
                                  icon: Icons.phone_android_rounded,
                                  size: (42 * scale).clamp(34, 48).toDouble(),
                                  iconSize:
                                      (18 * scale).clamp(16, 22).toDouble(),
                                  onTap: widget.callPressed),
                              SizedBox(
                                  width: (10 * scale).clamp(8, 12).toDouble()),
                              _metalBtn(
                                  icon: Icons.mail_outline_rounded,
                                  size: (42 * scale).clamp(34, 48).toDouble(),
                                  iconSize:
                                      (18 * scale).clamp(16, 22).toDouble(),
                                  onTap: widget.emailPressed),
                              const Spacer(),
                            ]),
                            SizedBox(height: 6 * scale),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: const [
                                  // smaller text under last icon
                                  Text(
                                    '0 Rides',
                                    style: TextStyle(
                                        color: kWhite,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w800),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'From US, Florida',
                                    style: TextStyle(
                                        color: kWhite,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
            ),

            // Toggle at top-right
            Positioned(
                right: 10 * scale, top: 8 * scale, child: _toggle(scale)),
          ]),
        );

        if (!widget.showSectionTitle) return card;
        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [header, card]);
      },
    );
  }
}

// Stronger diagonal fade painter to enhance the left wedge gradient
class _ChamferFadeStrongPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final path = Path()
      ..moveTo(w * 0.78, 0)
      ..lineTo(w, 0)
      ..lineTo(w, h)
      ..lineTo(w * 0.62, h)
      ..close();

    final rect = Rect.fromLTWH(w * 0.52, 0, w * 0.48, h);
    final paint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.centerRight,
        end: Alignment.centerLeft,
        colors: [Color(0xCC000000), Color(0x00000000)],
      ).createShader(rect);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
