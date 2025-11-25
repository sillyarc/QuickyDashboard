import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminSosChatWidget extends StatefulWidget {
  const AdminSosChatWidget({super.key});

  @override
  State<AdminSosChatWidget> createState() => _AdminSosChatWidgetState();
}

class _AdminSosChatWidgetState extends State<AdminSosChatWidget> {
  bool _isOpen = false;
  ChatRecord? _selectedChat;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _messagesScrollController = ScrollController();

  String _buildInitialsFromName(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      return '?';
    }
    final parts = trimmed.split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    final first = parts.first.substring(0, 1);
    final last = parts.last.substring(0, 1);
    return (first + last).toUpperCase();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _messagesScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isOpen ? _buildChatPanel(context) : _buildChatButton(context),
      ),
    );
  }

  Widget _buildChatButton(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 6.0,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: () => setState(() => _isOpen = true),
        customBorder: const CircleBorder(),
        child: Container(
          width: 56.0,
          height: 56.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                FlutterFlowTheme.of(context).error,
                FlutterFlowTheme.of(context).accent2,
              ],
              begin: const AlignmentDirectional(-1.0, 0.0),
              end: const AlignmentDirectional(1.0, 0.0),
            ),
          ),
          child: Icon(
            Icons.support_agent_rounded,
            color: Colors.white,
            size: 28.0,
          ),
        ),
      ),
    );
  }

  Widget _buildChatPanel(BuildContext context) {
    const bgColor = Color(0xFF242424);
    return Material(
      elevation: 10.0,
      borderRadius: BorderRadius.circular(16.0),
      child: Container(
        width: 420.0,
        height: 520.0,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: FlutterFlowTheme.of(context).alternate.withOpacity(0.5),
            width: 1.0,
          ),
        ),
        child: Column(
          children: [
            _buildHeader(context),
            const Divider(height: 1.0),
            Expanded(
              child: Row(
                children: [
                  _buildConversationsList(context),
                  VerticalDivider(
                    width: 1.0,
                    color: FlutterFlowTheme.of(context).alternate,
                  ),
                  Expanded(child: _buildMessagesArea(context)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: const Color(0xFF242424),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.bolt_rounded,
            color: FlutterFlowTheme.of(context).accent2,
          ),
          const SizedBox(width: 8.0),
          Text(
            'Ride SOS',
            style: FlutterFlowTheme.of(context).titleSmall.override(
                  font: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic,
                  ),
                  color: Colors.white,
                  fontSize: 16.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                ),
          ),
          const Spacer(),
          IconButton(
            icon: Icon(
              Icons.close_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _isOpen = false;
                _selectedChat = null;
                _messageController.clear();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildConversationsList(BuildContext context) {
    return SizedBox(
      width: 160.0,
      child: StreamBuilder<List<ChatHistoryRecord>>(
        stream: queryChatHistoryRecord(
          queryBuilder: (history) =>
              history.where('rideSOS', isEqualTo: true).orderBy('horario'),
        ),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: SizedBox(
                width: 32.0,
                height: 32.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    FlutterFlowTheme.of(context).primary,
                  ),
                ),
              ),
            );
          }

          final history = snapshot.data!;
          if (history.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  'Sem SOS ativos',
                  textAlign: TextAlign.center,
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                        font: GoogleFonts.poppins(
                          fontWeight:
                              FlutterFlowTheme.of(context).bodySmall.fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodySmall.fontStyle,
                        ),
                        color: FlutterFlowTheme.of(context).secondaryText,
                        letterSpacing: 0.0,
                      ),
                ),
              ),
            );
          }

          // Ordena pela �ltima mensagem (mais antiga primeiro)
          // Agrupa por conversa (chat) e usa o primeiro SOS de cada uma.
          final Map<DocumentReference, ChatHistoryRecord> byChat = {};
          for (final msg in history) {
            final parent = msg.parentReference;
            final existing = byChat[parent];
            if (existing == null) {
              byChat[parent] = msg;
            } else {
              final existingTime =
                  existing.horario ?? DateTime.fromMillisecondsSinceEpoch(0);
              final newTime =
                  msg.horario ?? DateTime.fromMillisecondsSinceEpoch(0);
              if (newTime.isBefore(existingTime)) {
                byChat[parent] = msg;
              }
            }
          }

          // Ordena pela hora do SOS (mais antigo primeiro).
          final sortedSos = byChat.values.toList()
            ..sort((a, b) {
              final aTime = a.horario ?? DateTime.fromMillisecondsSinceEpoch(0);
              final bTime = b.horario ?? DateTime.fromMillisecondsSinceEpoch(0);
              return aTime.compareTo(bTime);
            });

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            itemCount: sortedSos.length,
            separatorBuilder: (_, __) => const SizedBox(height: 4.0),
            itemBuilder: (context, index) {
              // index (0,1,2,3...) representa a ordem de atendimento
              final sos = sortedSos[index];
              final chatRef = sos.parentReference;
              final isSelected =
                  _selectedChat != null &&
                  _selectedChat!.reference.path == chatRef.path;
              return FutureBuilder<UsersRecord>(
                future: sos.documentUser != null
                    ? UsersRecord.getDocumentOnce(sos.documentUser!)
                    : null,
                builder: (context, userSnap) {
                  final user = userSnap.data;
                  final name = user?.displayName.isNotEmpty == true
                      ? user!.displayName
                      : 'Usuário';
                  return InkWell(
                    onTap: () async {
                      final chat = await ChatRecord.getDocumentOnce(chatRef);
                      if (currentUserReference != null &&
                          chat.user2Document != currentUserReference) {
                        final now = DateTime.now();

                        await chatRef.update(
                          mapToFirestore(<String, dynamic>{
                            'user2Document': currentUserReference,
                            'ultimaMsg': now,
                          }),
                        );

                        await ChatHistoryRecord.createDoc(chatRef).set(
                          createChatHistoryRecordData(
                            msg:
                                'Agent $currentUserDisplayName has joined the chat.',
                            horario: now,
                            msgdosystema: true,
                          ),
                        );
                      }
                      if (!mounted) return;
                      setState(() {
                        _selectedChat = chat;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF242424),
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          color: isSelected
                              ? FlutterFlowTheme.of(context).primary
                              : FlutterFlowTheme.of(context)
                                  .alternate
                                  .withOpacity(0.4),
                          width: isSelected ? 1.2 : 0.8,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 8.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 14.0,
                            backgroundColor:
                                FlutterFlowTheme.of(context).accent2,
                            backgroundImage: (user?.photoUrl.isNotEmpty ?? false)
                                ? NetworkImage(user!.photoUrl)
                                : null,
                            child: (user?.photoUrl.isNotEmpty ?? false)
                                ? null
                                : Text(
                                    _buildInitialsFromName(name),
                                    style: FlutterFlowTheme.of(context)
                                        .bodySmall
                                        .override(
                                          font: GoogleFonts.poppins(
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .bodySmall
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodySmall
                                                    .fontStyle,
                                          ),
                                          color: Colors.white,
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                          ),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          fontStyle: FontStyle.italic,
                                        ),
                                        fontSize: 16.0,
                                        color: Colors.white,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FontStyle.italic,
                                      ),
                                ),
                                if (sos.horario != null)
                                  Text(
                                    dateTimeFormat(
                                      'HH:mm',
                                      sos.horario,
                                      locale:
                                          FFLocalizations.of(context).languageCode,
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodySmall
                                        .override(
                                          font: GoogleFonts.poppins(
                                            fontWeight: FontWeight.normal,
                                            fontStyle: FontStyle.normal,
                                          ),
                                          fontSize: 12.0,
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildMessagesArea(BuildContext context) {
    if (_selectedChat == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Selecione uma conversa SOS',
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  font: GoogleFonts.poppins(
                    fontWeight:
                        FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                  ),
                  letterSpacing: 0.0,
                ),
          ),
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: StreamBuilder<List<ChatHistoryRecord>>(
            stream: queryChatHistoryRecord(
              parent: _selectedChat!.reference,
              queryBuilder: (history) =>
                  history.orderBy('horario', descending: false),
            ),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: SizedBox(
                    width: 32.0,
                    height: 32.0,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        FlutterFlowTheme.of(context).primary,
                      ),
                    ),
                  ),
                );
              }

              final messages = snapshot.data!;
              if (messages.isEmpty) {
                return Center(
                  child: Text(
                    'Sem mensagens nesta conversa.',
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          font: GoogleFonts.poppins(
                            fontWeight:
                                FlutterFlowTheme.of(context).bodySmall.fontWeight,
                            fontStyle:
                                FlutterFlowTheme.of(context).bodySmall.fontStyle,
                          ),
                          letterSpacing: 0.0,
                        ),
                  ),
                );
              }

              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (_messagesScrollController.hasClients) {
                  _messagesScrollController.jumpTo(
                    _messagesScrollController.position.maxScrollExtent,
                  );
                }
              });

              return ListView.builder(
                controller: _messagesScrollController,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 8.0,
                ),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];
                  final isMine =
                      msg.documentUser != null &&
                      msg.documentUser == currentUserReference;

                  return Align(
                    alignment: isMine
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 4.0,
                        horizontal: 4.0,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 8.0,
                      ),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.sizeOf(context).width * 0.28,
                      ),
                      decoration: BoxDecoration(
                        color: isMine
                            ? const Color(0xFFF5F5F5)
                            : FlutterFlowTheme.of(context).accent2,
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (msg.msg.isNotEmpty)
                            Text(
                              msg.msg,
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: GoogleFonts.poppins(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    color: isMine
                                        ? const Color(0xFF101213)
                                        : Colors.white,
                                    letterSpacing: 0.0,
                                  ),
                            ),
                          const SizedBox(height: 4.0),
                          Text(
                            dateTimeFormat(
                              'HH:mm',
                              msg.horario,
                              locale:
                                  FFLocalizations.of(context).languageCode,
                            ),
                            style:
                                FlutterFlowTheme.of(context).bodySmall.override(
                                      font: GoogleFonts.poppins(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .fontStyle,
                                      ),
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      letterSpacing: 0.0,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        const Divider(height: 1.0),
        _buildInputArea(context),
      ],
    );
  }

  Widget _buildInputArea(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              minLines: 1,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Escrever mensagem...',
                hintStyle: FlutterFlowTheme.of(context).bodySmall.override(
                      font: GoogleFonts.poppins(
                        fontWeight:
                            FlutterFlowTheme.of(context).bodySmall.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodySmall.fontStyle,
                      ),
                      color: FlutterFlowTheme.of(context).secondaryText,
                      letterSpacing: 0.0,
                    ),
                filled: true,
                fillColor: FlutterFlowTheme.of(context).primaryBackground,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(
                    color: FlutterFlowTheme.of(context).alternate,
                    width: 1.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(
                    color: FlutterFlowTheme.of(context).alternate,
                    width: 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(
                    color: FlutterFlowTheme.of(context).primary,
                    width: 1.5,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 8.0, horizontal: 12.0),
              ),
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    font: GoogleFonts.poppins(
                      fontWeight:
                          FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
                    letterSpacing: 0.0,
                  ),
            ),
          ),
          const SizedBox(width: 4.0),
          IconButton(
            onPressed: _onSendPressed,
            icon: Icon(
              Icons.send_rounded,
              color: FlutterFlowTheme.of(context).accent2,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onSendPressed() async {
    if (_selectedChat == null) return;
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final now = DateTime.now();

    await ChatHistoryRecord.createDoc(_selectedChat!.reference).set(
      createChatHistoryRecordData(
        msg: text,
        horario: now,
        documentUser: currentUserReference,
      ),
    );

    await _selectedChat!.reference.update(
      mapToFirestore(<String, dynamic>{
        'ultimaMsg': now,
      }),
    );

    _messageController.clear();
  }
}
