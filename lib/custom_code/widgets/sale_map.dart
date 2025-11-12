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

class SaleMap extends StatefulWidget {
  final double? width;
  final double? height;

  /// Caminho do SEU asset de mapa (ex.: "assets/images/world_flat_dark.png")
  final String? mapAsset;

  /// URL do mapa (opcional)
  final String? mapUrl;

  const SaleMap({
    Key? key,
    this.width,
    this.height,
    this.mapAsset,
    this.mapUrl,
  }) : super(key: key);

  @override
  State<SaleMap> createState() => _SaleMapState();
}

class _SaleMapState extends State<SaleMap> {
  // Cores
  static const Color _panel = Color(0xFF3C3C3C);
  static const Color _mapBg = Color(0xFF161616);
  static const Color _pillBg = Color(0xFF2B2B2B);
  static const Color _pillTxt = Colors.white;
  static const Color _taxiColor = Color(0xFFFFA000);
  static const Color _driversColor = Color(0xFF1FA6FF);
  static const Color _clientsColor = Color(0xFFE53935);

  // Default paths (para garantir que um mapa apareça)
  static const String _defaultMapAsset = 'assets/images/world_flat_dark.png';
  static const String _defaultMapUrl =
      'https://upload.wikimedia.org/wikipedia/commons/thumb/5/51/BlankMap-World6.svg/1280px-BlankMap-World6.svg.png';

  // Pins (0..1)
  static const List<Map<String, dynamic>> _pins = [
    {"fx": 0.16, "fy": 0.40, "label": "100 sale", "color": _taxiColor},
    {"fx": 0.24, "fy": 0.42, "label": "302 sale", "color": _driversColor},
    {"fx": 0.53, "fy": 0.34, "label": "120 sale", "color": _taxiColor},
    {"fx": 0.49, "fy": 0.42, "label": "45 sale", "color": _driversColor},
    {"fx": 0.83, "fy": 0.33, "label": "79 sale", "color": _taxiColor},
    {"fx": 0.89, "fy": 0.65, "label": "408 sale", "color": _taxiColor},
    {"fx": 0.76, "fy": 0.52, "label": "20 sale", "color": _clientsColor},
    {"fx": 0.35, "fy": 0.63, "label": "130 sale", "color": _clientsColor},
  ];

  @override
  Widget build(BuildContext context) {
    final double w = widget.width ?? double.infinity;
    final double h = widget.height ?? 260.0;

    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: _panel,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
              blurRadius: 12, offset: Offset(0, 6), color: Colors.black26),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          const Positioned(
            left: 16,
            top: 12,
            child: Text(
              'Sale Map',
              style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w700,
                  fontSize: 13),
            ),
          ),

          // MAPA + PINS
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 30, 14, 64),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: LayoutBuilder(
                  builder: (context, c) {
                    final mapW = c.maxWidth;
                    final mapH = c.maxHeight;
                    return Stack(
                      children: [
                        // fundo com fallback em cascata
                        Positioned.fill(child: _mapBackground()),

                        // pins
                        for (final p in _pins)
                          Positioned(
                            left: (p["fx"] as double) * mapW + 6,
                            top: (p["fy"] as double) * mapH - 6,
                            child: _pill(
                              label: p["label"] as String,
                              color: p["color"] as Color,
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),

          // LEGENDA
          Positioned(
            left: 0,
            right: 0,
            bottom: 10,
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                decoration: BoxDecoration(
                    color: const Color(0xFF2E2E2E),
                    borderRadius: BorderRadius.circular(6)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _legend(_taxiColor, 'Taxi Drivers'),
                    const SizedBox(width: 26),
                    _legend(_driversColor, 'Drivers'),
                    const SizedBox(width: 26),
                    _legend(_clientsColor, 'Clients'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --------------- MAP BACKGROUND (cascata de fallbacks) ---------------
  Widget _mapBackground() {
    // 1) usar mapAsset informado
    final asset = widget.mapAsset?.trim();
    if (asset != null && asset.isNotEmpty) {
      return Image.asset(
        asset,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _tryDefaultAssetOrUrl(),
      );
    }
    // 2) tentar asset padrão
    return Image.asset(
      _defaultMapAsset,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _tryDefaultAssetOrUrl(),
    );
  }

  Widget _tryDefaultAssetOrUrl() {
    // 3) se default asset não existir, tenta mapUrl informado
    final url = widget.mapUrl?.trim();
    if (url != null && url.isNotEmpty) {
      return Image.network(url,
          fit: BoxFit.cover, errorBuilder: (_, __, ___) => _tryDefaultUrl());
    }
    // 4) tenta URL padrão
    return _tryDefaultUrl();
  }

  Widget _tryDefaultUrl() {
    return Image.network(
      _defaultMapUrl,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => const ColoredBox(color: _mapBg),
    );
  }

  // ----------------- HELPERS UI -----------------
  static Widget _pill({required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _pillBg,
        borderRadius: BorderRadius.circular(6),
        boxShadow: const [
          BoxShadow(blurRadius: 6, offset: Offset(0, 2), color: Colors.black38)
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                  color: color, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 6),
          Text(label,
              style: const TextStyle(
                  color: _pillTxt, fontWeight: FontWeight.w700, fontSize: 11)),
        ],
      ),
    );
  }

  static Widget _legend(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 8),
        Text(label,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 12)),
      ],
    );
  }
}
