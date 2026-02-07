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
  bool _showingHistoryList = true;
  ChatRecord? _selectedHistoryChat;
  bool _initializedSelection = false;
  DocumentReference? _selectedSosChatRef;
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

  String _formatMessageText(String text) {
    final lower = text.toLowerCase();
    if (!lower.contains('resumo autom')) {
      return text;
    }

    var result = text;

    // Header
    result = result.replaceAll(
        RegExp(r'Resumo autom[^\n]*', caseSensitive: false),
        'Automatic SOS summary from the safety screen:');

    // Sections
    result = result.replaceAll(
        RegExp(r'Motivos selecionados:? ?', caseSensitive: false),
        'Selected reasons:');
    result = result.replaceAll(
        RegExp(r'Perguntas r[^\n]*:', caseSensitive: false),
        'Quick questions:');

    // Reasons (common options)
    result = result.replaceAll('Motorista inseguro', 'Unsafe driver');
    result = result.replaceAll('Assédio sexual', 'Sexual harassment');
    result = result.replaceAll('Ass�dio sexual', 'Sexual harassment');
    result = result.replaceAll('Não é meu motorista', 'Not my driver');
    result = result.replaceAll('N�o � meu motorista', 'Not my driver');
    result = result.replaceAll('Entrei no carro errado', 'I entered the wrong car');

    // Questions
    result = result.replaceAll(
      RegExp(
          r'Você está em perigo físico imediato\?\s*',
          caseSensitive: false),
      'Are you in immediate physical danger? ',
    );
    result = result.replaceAll(
      RegExp(
          r'Há risco de perder seus pertences\?\s*',
          caseSensitive: false),
      'Is there a risk of losing your belongings? ',
    );
    result = result.replaceAll(
      RegExp(
          r'O motorista sabe que você contatou a RIDE\?\s*',
          caseSensitive: false),
      'Does the driver know you contacted RIDE? ',
    );
    result = result.replaceAll(
      RegExp(
          r'Você está dentro do veículo agora\?\s*',
          caseSensitive: false),
      'Are you inside the vehicle now? ',
    );

    // Yes/No
    result = result.replaceAll(RegExp(r'\bSim\b', caseSensitive: false), 'Yes');
    result = result.replaceAll(RegExp(r'\bNão\b', caseSensitive: false), 'No');
    result = result.replaceAll(RegExp(r'\bN�o\b', caseSensitive: false), 'No');

    return result;
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
            gradient: const LinearGradient(
              colors: [
                Color(0xFFFF643A),
                Color(0xFFFF501F),
                Color(0xFFDF3A2E),
              ],
              begin: AlignmentDirectional(-1.0, 0.0),
              end: AlignmentDirectional(1.0, 0.0),
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
            color: Color(0xFFFF643A),
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
                _selectedHistoryChat = null;
                _showingHistoryList = true;
                _initializedSelection = false;
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
      width: 72.0,
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
                  'No active SOS messages',
                  textAlign: TextAlign.center,
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                        font: GoogleFonts.poppins(
                          fontWeight:
                              FlutterFlowTheme.of(context).bodySmall.fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodySmall.fontStyle,
                        ),
                        color: Colors.white,
                        letterSpacing: 0.0,
                      ),
                ),
              ),
            );
          }

          // Ordena pela �ltima mensagem (mais antiga primeiro)
          // Agrupa por conversa (chat) e usa o primeiro SOS de cada uma.
          final Map<DocumentReference, ChatHistoryRecord> byUser = {};
          for (final msg in history) {
            final userRef = msg.documentUser;
            if (userRef == null) continue;
            final existing = byUser[userRef];
            if (existing == null) {
              byUser[userRef] = msg;
            } else {
              final existingTime =
                  existing.horario ?? DateTime.fromMillisecondsSinceEpoch(0);
              final newTime =
                  msg.horario ?? DateTime.fromMillisecondsSinceEpoch(0);
              if (newTime.isBefore(existingTime)) {
                byUser[userRef] = msg;
              }
            }
          }

          // Ordena pela hora do SOS (mais antigo primeiro).
          final sortedSos = byUser.values.toList()
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
                  _selectedSosChatRef != null &&
                  _selectedSosChatRef!.path == chatRef.path;
              return FutureBuilder<UsersRecord>(
                future: sos.documentUser != null
                    ? UsersRecord.getDocumentOnce(sos.documentUser!)
                    : null,
                builder: (context, userSnap) {
                  final user = userSnap.data;
                  final name = user?.displayName.isNotEmpty == true
                      ? user!.displayName
                      : 'User';
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
                        _selectedSosChatRef = chatRef;
                        _showingHistoryList = true;
                        _selectedHistoryChat = null;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF242424),
                        borderRadius: BorderRadius.circular(10.0),
                        border: isSelected
                            ? Border.all(
                                color: FlutterFlowTheme.of(context).primary,
                                width: 1.2,
                              )
                            : null,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (user?.photoUrl.isNotEmpty ?? false)
                            CircleAvatar(
                              radius: 22.0,
                              backgroundColor:
                                  FlutterFlowTheme.of(context).accent2,
                              backgroundImage:
                                  NetworkImage(user!.photoUrl),
                            )
                          else
                            Container(
                              width: 44.0,
                              height: 44.0,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFFFF643A),
                                    Color(0xFFFF501F),
                                    Color(0xFFDF3A2E),
                                  ],
                                  begin: AlignmentDirectional(-1.0, 0.0),
                                  end: AlignmentDirectional(1.0, 0.0),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
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
      return _buildGlobalHistoryList(context);
    }

    if (_selectedChat!.userDocument == null) {
      return _buildChatDetailView(context);
    }

    if (_showingHistoryList) {
      return _buildUserChatHistoryList(context, _selectedChat!.userDocument!);
    }

    return _buildChatDetailView(context);
  }

  Widget _buildGlobalHistoryList(BuildContext context) {
    return StreamBuilder<List<ChatHistoryRecord>>(
      stream: queryChatHistoryRecord(
        queryBuilder: (history) => history
            .where('rideSOS', isEqualTo: true)
            .orderBy('horario', descending: true),
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

        final allMessages = snapshot.data!;
        if (allMessages.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'No active SOS messages',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.poppins(
                        fontWeight: FlutterFlowTheme.of(context)
                            .bodyMedium
                            .fontWeight,
                        fontStyle: FlutterFlowTheme.of(context)
                            .bodyMedium
                            .fontStyle,
                      ),
                      color: Colors.white,
                      letterSpacing: 0.0,
                    ),
              ),
            ),
          );
        }

        final Map<DocumentReference, ChatHistoryRecord> lastByUser = {};
        for (final msg in allMessages) {
          final userRef = msg.documentUser;
          if (userRef == null) continue;
          if (!lastByUser.containsKey(userRef)) {
            lastByUser[userRef] = msg;
          }
        }

        if (lastByUser.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'No active SOS messages',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.poppins(
                        fontWeight: FlutterFlowTheme.of(context)
                            .bodyMedium
                            .fontWeight,
                        fontStyle: FlutterFlowTheme.of(context)
                            .bodyMedium
                            .fontStyle,
                      ),
                      color: Colors.white,
                      letterSpacing: 0.0,
                    ),
              ),
            ),
          );
        }

        final items = lastByUser.values.toList()
          ..sort((a, b) {
            final aTime =
                a.horario ?? DateTime.fromMillisecondsSinceEpoch(0);
            final bTime =
                b.horario ?? DateTime.fromMillisecondsSinceEpoch(0);
            return bTime.compareTo(aTime);
          });

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 8.0),
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 4.0),
          itemBuilder: (context, index) {
            final msg = items[index];
            final userRef = msg.documentUser;
            final chatRef = msg.parentReference;

            return FutureBuilder<UsersRecord>(
              future: userRef != null
                  ? UsersRecord.getDocumentOnce(userRef)
                  : null,
              builder: (context, userSnap) {
                final user = userSnap.data;
                final name = (user?.displayName.isNotEmpty ?? false)
                    ? user!.displayName
                    : 'User';
                final lastMsg = msg.msg;

                return InkWell(
                  onTap: () {
                    final chat = ChatRecord.getDocumentFromData(
                      {
                        if (userRef != null) 'userDocument': userRef,
                        'rideSOS': true,
                      },
                      chatRef,
                    );
                    setState(() {
                      _selectedChat = chat;
                      _selectedSosChatRef = chatRef;
                      _showingHistoryList = true;
                      _selectedHistoryChat = null;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 4.0,
                      vertical: 4.0,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 8.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (user?.photoUrl.isNotEmpty ?? false)
                          CircleAvatar(
                            radius: 14.0,
                            backgroundColor:
                                FlutterFlowTheme.of(context).accent2,
                            backgroundImage:
                                NetworkImage(user!.photoUrl),
                          )
                        else
                          Container(
                            width: 28.0,
                            height: 28.0,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFFFF643A),
                                  Color(0xFFFF501F),
                                  Color(0xFFDF3A2E),
                                ],
                                begin: AlignmentDirectional(-1.0, 0.0),
                                end: AlignmentDirectional(1.0, 0.0),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              _buildInitialsFromName(name),
                              style: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .override(
                                    font: GoogleFonts.poppins(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
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
                                      fontSize: 14.0,
                                      color: Colors.white,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FontStyle.italic,
                                    ),
                              ),
                              if (lastMsg.isNotEmpty)
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 2.0),
                                  child: Text(
                                    lastMsg,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
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
                                          color:
                                              FlutterFlowTheme.of(context)
                                                  .secondaryText,
                                          fontSize: 12.0,
                                          letterSpacing: 0.0,
                                        ),
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
    );
  }

  Widget _buildUserChatHistoryList(
      BuildContext context, DocumentReference userRef) {
    return FutureBuilder<UsersRecord>(
      future: UsersRecord.getDocumentOnce(userRef),
      builder: (context, userSnap) {
        final user = userSnap.data;
        final displayName = (user?.displayName.isNotEmpty ?? false)
            ? user!.displayName
            : 'User';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: StreamBuilder<List<ChatRecord>>(
                stream: queryChatRecord(
                  queryBuilder: (chat) =>
                      chat.where('userDocument', isEqualTo: userRef),
                ),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Error loading history.',
                          textAlign: TextAlign.center,
                          style: FlutterFlowTheme.of(context)
                              .bodySmall
                              .override(
                                font: GoogleFonts.poppins(
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .bodySmall
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodySmall
                                      .fontStyle,
                                ),
                                letterSpacing: 0.0,
                              ),
                        ),
                      ),
                    );
                  }

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

                  final chats = snapshot.data!..sort((a, b) {
                      final aTime =
                          a.ultimaMsg ?? DateTime.fromMillisecondsSinceEpoch(0);
                      final bTime =
                          b.ultimaMsg ?? DateTime.fromMillisecondsSinceEpoch(0);
                      return bTime.compareTo(aTime);
                    });
                  if (chats.isEmpty) {
                    return Center(
                      child: Text(
                        'No chat history for this user.',
                        style: FlutterFlowTheme.of(context)
                            .bodySmall
                            .override(
                              font: GoogleFonts.poppins(
                                fontWeight: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .fontStyle,
                              ),
                              letterSpacing: 0.0,
                            ),
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
                    itemCount: chats.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 4.0),
                    itemBuilder: (context, index) {
                      final chat = chats[index];
                      final isSelectedHistory =
                          _selectedHistoryChat != null &&
                              _selectedHistoryChat!.reference.path ==
                                  chat.reference.path;

                      return StreamBuilder<List<ChatHistoryRecord>>(
                        stream: queryChatHistoryRecord(
                          parent: chat.reference,
                          queryBuilder: (history) => history
                              .orderBy('horario', descending: true),
                          limit: 1,
                          singleRecord: true,
                        ),
                        builder: (context, historySnap) {
                          String lastMsg = '';
                          if (historySnap.hasData &&
                              historySnap.data!.isNotEmpty) {
                            lastMsg = historySnap.data!.first.msg;
                          }

                          return InkWell(
                            onTap: () {
                              setState(() {
                                _selectedChat = chat;
                                _selectedHistoryChat = chat;
                                _showingHistoryList = false;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isSelectedHistory
                                    ? const Color(0xFF2E2E2E)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 8.0,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  if (user?.photoUrl.isNotEmpty ?? false)
                                    CircleAvatar(
                                      radius: 14.0,
                                      backgroundColor:
                                          FlutterFlowTheme.of(context)
                                              .accent2,
                                      backgroundImage:
                                          NetworkImage(user!.photoUrl),
                                    )
                                  else
                                    Container(
                                      width: 28.0,
                                      height: 28.0,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xFFFF643A),
                                            Color(0xFFFF501F),
                                            Color(0xFFDF3A2E),
                                          ],
                                          begin:
                                              AlignmentDirectional(-1.0, 0.0),
                                          end: AlignmentDirectional(1.0, 0.0),
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        _buildInitialsFromName(displayName),
                                        style: FlutterFlowTheme.of(context)
                                            .bodySmall
                                            .override(
                                              font: GoogleFonts.poppins(
                                                fontWeight:
                                                    FlutterFlowTheme.of(
                                                            context)
                                                        .bodySmall
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(
                                                            context)
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          displayName,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                font: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w600,
                                                  fontStyle: FontStyle.italic,
                                                ),
                                                fontSize: 14.0,
                                                color: Colors.white,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w600,
                                                fontStyle: FontStyle.italic,
                                              ),
                                        ),
                                        if (lastMsg.isNotEmpty)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 2.0),
                                            child: Text(
                                              lastMsg,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodySmall
                                                  .override(
                                                    font: GoogleFonts.poppins(
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodySmall
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodySmall
                                                              .fontStyle,
                                                    ),
                                                    color:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .secondaryText,
                                                    fontSize: 12.0,
                                                    letterSpacing: 0.0,
                                                  ),
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
            ),
          ],
        );
      },
    );
  }

  Widget _buildChatDetailView(BuildContext context) {
    if (_selectedChat == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'No active SOS messages',
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
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: const Color(0xFF242424),
            border: Border(
              bottom: BorderSide(
                color: FlutterFlowTheme.of(context).alternate.withOpacity(0.3),
                width: 0.5,
              ),
            ),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                  size: 20.0,
                ),
                onPressed: () {
                  setState(() {
                    _showingHistoryList = true;
                  });
                },
              ),
              const SizedBox(width: 4.0),
              if (_selectedChat!.userDocument != null)
                FutureBuilder<UsersRecord>(
                  future: UsersRecord.getDocumentOnce(
                      _selectedChat!.userDocument!),
                  builder: (context, snap) {
                    final user = snap.data;
                    final name = (user?.displayName.isNotEmpty ?? false)
                        ? user!.displayName
                        : 'User';
                    return Row(
                      children: [
                        if (user?.photoUrl.isNotEmpty ?? false)
                          CircleAvatar(
                            radius: 12.0,
                            backgroundColor:
                                FlutterFlowTheme.of(context).accent2,
                            backgroundImage:
                                NetworkImage(user!.photoUrl),
                          )
                        else
                          Container(
                            width: 24.0,
                            height: 24.0,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFFFF643A),
                                  Color(0xFFFF501F),
                                  Color(0xFFDF3A2E),
                                ],
                                begin: AlignmentDirectional(-1.0, 0.0),
                                end: AlignmentDirectional(1.0, 0.0),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              _buildInitialsFromName(name),
                              style: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .override(
                                    font: GoogleFonts.poppins(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .fontStyle,
                                    ),
                                    color: Colors.white,
                                    letterSpacing: 0.0,
                                  ),
                            ),
                          ),
                        const SizedBox(width: 8.0),
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
                                fontSize: 14.0,
                                color: Colors.white,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w600,
                                fontStyle: FontStyle.italic,
                              ),
                        ),
                      ],
                    );
                  },
                ),
            ],
          ),
        ),
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
                    'No messages in this conversation.',
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          font: GoogleFonts.poppins(
                            fontWeight:
                                FlutterFlowTheme.of(context).bodySmall.fontWeight,
                            fontStyle:
                                FlutterFlowTheme.of(context).bodySmall.fontStyle,
                          ),
                          color: Colors.white,
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
                  final isSystem = msg.msgdosystema;
                  final isMine =
                      msg.documentUser != null &&
                      msg.documentUser == currentUserReference;

                  final displayText = _formatMessageText(msg.msg);

                  if (isSystem) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4.0,
                        horizontal: 8.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            displayText,
                            textAlign: TextAlign.center,
                            style: FlutterFlowTheme.of(context)
                                .bodySmall
                                .override(
                                  font: GoogleFonts.poppins(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodySmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodySmall
                                        .fontStyle,
                                  ),
                                  color:
                                      FlutterFlowTheme.of(context).secondaryText,
                                  letterSpacing: 0.0,
                                ),
                          ),
                          const SizedBox(height: 2.0),
                          if (msg.horario != null)
                            Text(
                              dateTimeFormat(
                                'HH:mm',
                                msg.horario,
                                locale:
                                    FFLocalizations.of(context).languageCode,
                              ),
                              style: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .override(
                                    font: GoogleFonts.poppins(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .fontStyle,
                                    ),
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText
                                        .withOpacity(0.8),
                                    fontSize: 10.0,
                                    letterSpacing: 0.0,
                                  ),
                            ),
                        ],
                      ),
                    );
                  }

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
                        color: isMine ? const Color(0xFFF5F5F5) : null,
                        gradient: isMine
                            ? null
                            : const LinearGradient(
                                colors: [
                                  Color(0xFFFF643A),
                                  Color(0xFFFF501F),
                                  Color(0xFFDF3A2E),
                                ],
                                begin: AlignmentDirectional(-1.0, 0.0),
                                end: AlignmentDirectional(1.0, 0.0),
                              ),
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (displayText.isNotEmpty)
                            Text(
                              displayText,
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
                hintText: 'Write a message...',
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
              color: Color(0xFFFF643A),
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
