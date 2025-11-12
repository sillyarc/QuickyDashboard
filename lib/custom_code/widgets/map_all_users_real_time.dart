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

import '/flutter_flow/flutter_flow_util.dart' as ff;
import '/custom_code/widgets/index.dart';
import '/flutter_flow/custom_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' show base64;

import 'package:google_maps_native_sdk/google_maps_native_sdk.dart' as gmaps;

class MapAllUsersRealTime extends StatefulWidget {
  const MapAllUsersRealTime({
    super.key,
    this.width,
    this.height,
    this.componenteUsersClick,
    this.users,
    this.componenteDriversClick,
    this.componenteDriverSOS,
    this.componenteUsersSOS,
    this.rideOrders,
    this.webApiKey,
  });

  final double? width;
  final double? height;

  final Widget Function(DocumentReference users)? componenteUsersClick;
  final List<UsersRecord>? users;
  final Widget Function(DocumentReference users)? componenteDriversClick;
  final Widget Function(DocumentReference users)? componenteDriverSOS;
  final Widget Function(DocumentReference users)? componenteUsersSOS;
  final List<RideOrdersRecord>? rideOrders;
  final String? webApiKey;

  @override
  State<MapAllUsersRealTime> createState() => _MapAllUsersRealTimeState();
}

class _MapAllUsersRealTimeState extends State<MapAllUsersRealTime> {
  gmaps.GoogleMapController? _controller;
  // Conteúdo do painel inferior (renderizado acima do mapa)
  Widget? _sheetChild;

  // Nassau, Bahamas
  static const _nassau = gmaps.LatLng(25.0443, -77.3504);
  static const _nassauInitial = gmaps.CameraPosition(target: _nassau, zoom: 12);

  // URLs (usadas para drivers online; serão embutidas em data URL)
  static const _rideTaxiUrl =
      'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/ride-899y4i/assets/hlhwt7mbve4j/ChatGPT_Image_3_de_set._de_2025%2C_15_02_50.png';
  static const _rideDriverUrl =
      'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/ride-899y4i/assets/bgmclb0d2bsd/ChatGPT_Image_3_de_set._de_2025%2C_19_17_48.png';

  // Tamanho dos ícones (menor)
  static const int _iconSize = 32;

  final Map<String, String> _dataUrlCache = {};
  final Set<String> _markerIds = <String>{};
  final Map<String, UsersRecord> _byId = {};
  bool _syncQueued = false;

  // Estilo escuro
  static const String _darkMapStyleJson = '''
  [
    {"elementType":"geometry","stylers":[{"color":"#0f0f0f"}]},
    {"elementType":"labels.icon","stylers":[{"visibility":"off"}]},
    {"elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]},
    {"elementType":"labels.text.stroke","stylers":[{"color":"#0f0f0f"}]},
    {"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]},
    {"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#101010"}]},
    {"featureType":"road","elementType":"geometry","stylers":[{"color":"#1c1c1c"}]},
    {"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#2a2a2a"}]},
    {"featureType":"transit","elementType":"geometry","stylers":[{"color":"#1a1f29"}]},
    {"featureType":"water","elementType":"geometry","stylers":[{"color":"#000000"}]}
  ]
  ''';

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  // -------- helpers seguros --------
  bool _b(Map<String, dynamic> d, String k) {
    final v = d[k];
    if (v is bool) return v;
    if (v is num) return v != 0;
    if (v is String) return v.toLowerCase() == 'true';
    return false;
  }

  String _s(Map<String, dynamic> d, String k) {
    final v = d[k];
    return v == null ? '' : v.toString();
  }

  DocumentReference? _r(Map<String, dynamic> d, String k) {
    final v = d[k];
    return v is DocumentReference ? v : null;
  }

  List<String> _ls(Map<String, dynamic> d, String k) {
    final v = d[k];
    if (v is List) {
      return v
          .map((e) => e?.toString() ?? '')
          .where((s) => s.isNotEmpty)
          .toList();
    }
    return const [];
  }

  ff.LatLng? _ff(dynamic v) {
    if (v == null) return null;
    if (v is ff.LatLng) return v;
    if (v is GeoPoint) return ff.LatLng(v.latitude, v.longitude);
    if (v is Map) {
      final lat = v['lat'] ?? v['latitude'];
      final lng = v['lng'] ?? v['longitude'] ?? v['lon'];
      if (lat is num && lng is num)
        return ff.LatLng(lat.toDouble(), lng.toDouble());
    }
    return null;
  }

  gmaps.LatLng? _gm(ff.LatLng? p) =>
      p == null ? null : gmaps.LatLng(p.latitude, p.longitude);

  // -------- ícones (sempre 32×32) --------
  String _initials(String name) {
    final parts =
        name.trim().split(RegExp(r'\s+')).where((s) => s.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    final a = parts.first[0];
    final b = parts.length > 1 ? parts.last[0] : '';
    return (a + b).toUpperCase();
  }

  String _esc(String s) => s
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;');

  String _svgInitialsBlack(String initials) {
    final s = _iconSize;
    final svg = '''
<svg xmlns="http://www.w3.org/2000/svg" width="$s" height="$s">
  <defs><filter id="sh"><feDropShadow dx="0" dy="1.2" stdDeviation="1.8" flood-color="#000" flood-opacity="0.5"/></filter></defs>
  <g filter="url(#sh)">
    <circle cx="${s / 2}" cy="${s / 2}" r="${(s / 2) - 1.2}" fill="#111" stroke="#2a2a2a" stroke-width="1.6"/>
    <text x="${s / 2}" y="${(s / 2) + 5}" font-family="Inter,Roboto,Arial" font-size="${(s * 0.44).toStringAsFixed(0)}"
          font-weight="800" text-anchor="middle" fill="#fff">${_esc(initials)}</text>
  </g>
</svg>
''';
    return 'data:image/svg+xml;utf8,${Uri.encodeComponent(svg)}';
  }

  Future<String> _toDataUrl(String url) async {
    final cached = _dataUrlCache[url];
    if (cached != null) return cached;
    try {
      final res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        String mime = res.headers['content-type'] ?? '';
        if (!mime.startsWith('image/')) {
          final low = url.toLowerCase();
          if (low.endsWith('.png'))
            mime = 'image/png';
          else if (low.endsWith('.jpg') || low.endsWith('.jpeg'))
            mime = 'image/jpeg';
          else
            mime = 'image/png';
        }
        final dataUrl = 'data:$mime;base64,${base64.encode(res.bodyBytes)}';
        _dataUrlCache[url] = dataUrl;
        return dataUrl;
      }
    } catch (e) {
      debugPrint('toDataUrl $url -> $e');
    }
    // fallback: quadrado preto
    return 'data:image/svg+xml;utf8,${Uri.encodeComponent('<svg xmlns="http://www.w3.org/2000/svg" width="$_iconSize" height="$_iconSize"><rect width="$_iconSize" height="$_iconSize" fill="#111"/></svg>')}';
  }

  String _svgCircleWithImageDataUrl(String dataUrl) {
    final s = _iconSize;
    final data = _esc(dataUrl);
    final svg = '''
<svg xmlns="http://www.w3.org/2000/svg" width="$s" height="$s">
  <defs>
    <clipPath id="clip"><circle cx="${s / 2}" cy="${s / 2}" r="${(s / 2) - 2}"/></clipPath>
    <filter id="sh"><feDropShadow dx="0" dy="1.2" stdDeviation="1.8" flood-color="#000" flood-opacity="0.5"/></filter>
  </defs>
  <g filter="url(#sh)">
    <circle cx="${s / 2}" cy="${s / 2}" r="${(s / 2) - 1}" fill="#111" stroke="#2a2a2a" stroke-width="1.6"/>
    <image href="$data" x="2" y="2" width="${s - 4}" height="${s - 4}"
           preserveAspectRatio="xMidYMid slice" clip-path="url(#clip)"/>
  </g>
</svg>
''';
    return 'data:image/svg+xml;utf8,${Uri.encodeComponent(svg)}';
  }

  // -------- regras de negócio --------
  bool _isDriverOnline(UsersRecord u) {
    final d = _b(u.snapshotData, 'driver');
    final on = _b(u.snapshotData, 'driverOnline');
    return d && on;
  }

  String _photoUrl(UsersRecord u) {
    final p1 = _s(u.snapshotData, 'photo_url');
    if (p1.isNotEmpty) return p1;
    final p2 = _s(u.snapshotData, 'photoUrl');
    if (p2.isNotEmpty) return p2;
    final p3 = _s(u.snapshotData, 'photoURL');
    if (p3.isNotEmpty) return p3;
    return '';
  }

  String _name(UsersRecord u) {
    final d1 = _s(u.snapshotData, 'display_name');
    if (d1.isNotEmpty) return d1;
    final d2 = _s(u.snapshotData, 'displayName');
    if (d2.isNotEmpty) return d2;
    return u.displayName ?? '';
  }

  List<String> _platforms(UsersRecord u) {
    final all = <String>[
      ..._ls(u.snapshotData, 'plataform'),
      ..._ls(u.snapshotData, 'platform'),
      ..._ls(u.snapshotData, 'plataforma'),
    ];
    return all.map((e) => e.toLowerCase().trim()).toList();
  }

  Iterable<RideOrdersRecord> _ordersFor(DocumentReference ref) sync* {
    final list = widget.rideOrders ?? const <RideOrdersRecord>[];
    for (final r in list) {
      final dRef = _r(r.snapshotData, 'driver');
      final uRef = _r(r.snapshotData, 'user');
      if (dRef == ref || uRef == ref) yield r;
    }
  }

  bool _hasSOS(DocumentReference ref) {
    for (final r in _ordersFor(ref)) {
      if (_b(r.snapshotData, 'sos')) return true;
    }
    return false;
  }

  bool _isInRide(DocumentReference ref) {
    for (final r in _ordersFor(ref)) {
      final active = _b(r.snapshotData, 'isActive');
      final status = (r.snapshotData['status'] ?? '').toString().toLowerCase();
      if (active ||
          status == 'searching' ||
          status == 'accepted' ||
          status == 'in_progress') {
        return true;
      }
    }
    return _ordersFor(ref).isNotEmpty;
  }

  // Decide o ícone final (32×32), sempre data URL para tamanho estável.
  Future<String> _iconFor(UsersRecord u, bool hasSOS) async {
    if (hasSOS) {
      final s = _iconSize;
      final svg =
          '<svg xmlns="http://www.w3.org/2000/svg" width="$s" height="$s"><circle cx="${s / 2}" cy="${s / 2}" r="${(s / 2) - 1}" fill="#ff1744"/></svg>';
      return 'data:image/svg+xml;utf8,${Uri.encodeComponent(svg)}';
    }

    if (_isDriverOnline(u)) {
      final plats = _platforms(u);
      final remote = (plats.contains('ride taxi') || plats.contains('taxi'))
          ? _rideTaxiUrl
          : _rideDriverUrl;
      final data = await _toDataUrl(remote); // baixa a URL pedida
      return _svgCircleWithImageDataUrl(data); // embute e fixa 32 px
    }

    final photo = _photoUrl(u);
    if (photo.isNotEmpty) {
      final data = await _toDataUrl(photo);
      return _svgCircleWithImageDataUrl(data);
    }

    return _svgInitialsBlack(_initials(_name(u)));
  }

  // -------- markers --------
  Future<void> _syncMarkers() async {
    final c = _controller;
    if (c == null) return;

    final users = widget.users ?? const <UsersRecord>[];
    _byId
      ..clear()
      ..addEntries(users.map((u) => MapEntry(u.reference.id, u)));

    final alive = <String>{};

    for (final u in users) {
      final id = u.reference.id;
      final pos = _gm(_ff(u.snapshotData['location']));
      if (pos == null) continue;

      final isDriver = _isDriverOnline(u);
      final hasSOS = _hasSOS(u.reference);
      final inRide = _isInRide(u.reference);

      final name = _name(u);
      final title = name.isNotEmpty ? name : (isDriver ? 'Driver' : 'Usuário');

      final snippet = hasSOS
          ? '🚨 SOS ativo'
          : isDriver
              ? (inRide ? 'Em corrida' : 'Disponível')
              : (inRide ? 'Passageiro em corrida' : 'Passageiro');

      final iconUrl = await _iconFor(u, hasSOS);

      final opts = gmaps.MarkerOptions(
        id: id,
        position: pos,
        title: title,
        snippet: snippet,
        iconUrl: iconUrl,
        zIndex: hasSOS ? 3 : (isDriver ? 2 : 1),
      );

      if (_markerIds.contains(id)) {
        await c.removeMarker(id);
      }
      await c.addMarker(opts);
      _markerIds.add(id);
      alive.add(id);
    }

    for (final id in _markerIds.difference(alive).toList()) {
      await c.removeMarker(id);
      _markerIds.remove(id);
    }
  }

  // -------- clique (somente onMarkerTap; 0.9.x não expõe onInfoWindowTap) --------
  void _wireTap(gmaps.GoogleMapController c) {
    c.onMarkerTap.listen((event) {
      String? id;
      if (event is String) {
        id = event;
      } else {
        try {
          final d = event as dynamic;
          id = (d.id ??
                  d.markerId ??
                  d.marker?.id ??
                  (d is Map ? d['id'] : null))
              ?.toString();
        } catch (_) {}
      }
      debugPrint('onMarkerTap => $id');
      if (id != null) _openFor(id);
    });
  }

  void _openFor(String markerId) {
    final u = _byId[markerId];
    if (u == null) return;

    final isDriver = _isDriverOnline(u);
    final hasSOS = _hasSOS(u.reference);

    Widget? child;
    if (hasSOS) {
      child = isDriver
          ? widget.componenteDriverSOS?.call(u.reference)
          : widget.componenteUsersSOS?.call(u.reference);
    } else {
      child = isDriver
          ? widget.componenteDriversClick?.call(u.reference)
          : widget.componenteUsersClick?.call(u.reference);
    }

    if (child != null) {
      // Renderiza dentro do mesmo widget (acima do PlatformView do mapa),
      // evitando problemas de z-order em algumas plataformas.
      setState(() {
        _sheetChild = child;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Marker clicado, mas nenhum componente foi passado.')),
      );
    }
  }

  // Atualiza markers quando props mudarem (sem recriar no build)
  @override
  void didUpdateWidget(covariant MapAllUsersRealTime oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_controller != null) {
      if (_syncQueued) return;
      _syncQueued = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        _syncQueued = false;
        await _syncMarkers();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? double.infinity,
      height: widget.height ?? 500,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: gmaps.GoogleMapView(
              webApiKey: widget.webApiKey,
              initialCameraPosition: _nassauInitial,
              buildingsEnabled: true,
              trafficEnabled: false,
              onMapCreated: (gmaps.GoogleMapController c) async {
                _controller = c;

                // tema preto (fallbacks 0.6.x/0.9.x)
                try {
                  (c as dynamic).setMapStyleJson(_darkMapStyleJson);
                } catch (_) {
                  try {
                    (c as dynamic).setMapStyle(_darkMapStyleJson);
                  } catch (_) {
                    try {
                      (c as dynamic).setMapColor(const Color(0xFF000000));
                    } catch (_) {}
                  }
                }

                _wireTap(c);
                await c.onMapLoaded;
                await _syncMarkers();
              },
            ),
          ),

          // Painel inferior sobreposto
          if (_sheetChild != null)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SafeArea(
                top: false,
                child: Container(
                  margin: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 16,
                        offset: Offset(0, 8),
                        color: Colors.black26,
                      )
                    ],
                  ),
                  child: _sheetChild!,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
