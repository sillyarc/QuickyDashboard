import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/backend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/backend/schema/structs/index.dart';
import '/auth/firebase_auth/auth_util.dart';

double? mediadevaloresmes(List<PagamentosRecord> pagamento) {
  // mostre somente o pagamento.valor de 30 dias baseando em pagamento.data
  DateTime now = DateTime.now();
  DateTime thirtyDaysAgo = now.subtract(Duration(days: 30));
  double totalValor = 0.0;
  int count = 0;

  for (var record in pagamento) {
    if (record.hasData() && record.data!.isAfter(thirtyDaysAgo)) {
      totalValor += record.valor;
      count++;
    }
  }

  return count > 0 ? totalValor / count : null;
}

String retornListMsmLinha(List<String> plataforms) {
  // retorne o list "1, 2, 3"
  return plataforms.join(', ');
}

bool verifyEmail(String email) {
  // se o email for diferente de emails que sejam desse tipo começa com "quicky" depois o @ vem um nome da pessoa e ".admin" "quicky@nomedapessoa.admin" retorne false
  // Verifica se o email começa com "quicky" e termina com ".admin"
  if (email.startsWith('quicky') && email.endsWith('.admin')) {
    return false;
  }
  return true;
}

String listaVirgula(List<String> list) {
  // separe todo conteudo da lista assim " conteudo - conteudo - conteudo...'
  return list.join(' - ');
}

double quantodetokentem(double? value) {
  // baseando-se que cada token é 2.5 e 4 tokens é $10, 10 é $25, 20 é $50 e 50 é $125 retorne os tokens baseado no valor mas tem q ser o exato baseado q cada token é 2.5
  if (value == null || value < 2.5) {
    return 0;
  }
  return (value / 2.5).floorToDouble();
}

int indexList1(String indexList) {
  // faça q quando o indexlist retornar 0 no front end ser 1 e etc
  int index =
      int.tryParse(indexList) ?? 0; // Convert string to int, default to 0
  return index + 1; // Increment index by 1
}
