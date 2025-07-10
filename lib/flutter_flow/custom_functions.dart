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
