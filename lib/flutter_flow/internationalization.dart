import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kLocaleStorageKey = '__locale_key__';

class FFLocalizations {
  FFLocalizations(this.locale);

  final Locale locale;

  static FFLocalizations of(BuildContext context) =>
      Localizations.of<FFLocalizations>(context, FFLocalizations)!;

  static List<String> languages() => ['en', 'id', 'ms'];

  static late SharedPreferences _prefs;
  static Future initialize() async =>
      _prefs = await SharedPreferences.getInstance();
  static Future storeLocale(String locale) =>
      _prefs.setString(_kLocaleStorageKey, locale);
  static Locale? getStoredLocale() {
    final locale = _prefs.getString(_kLocaleStorageKey);
    return locale != null && locale.isNotEmpty ? createLocale(locale) : null;
  }

  String get languageCode => locale.toString();
  String? get languageShortCode =>
      _languagesWithShortCode.contains(locale.toString())
          ? '${locale.toString()}_short'
          : null;
  int get languageIndex => languages().contains(languageCode)
      ? languages().indexOf(languageCode)
      : 0;

  String getText(String key) =>
      (kTranslationsMap[key] ?? {})[locale.toString()] ?? '';

  String getVariableText({
    String? enText = '',
    String? idText = '',
    String? msText = '',
  }) =>
      [enText, idText, msText][languageIndex] ?? '';

  static const Set<String> _languagesWithShortCode = {
    'ar',
    'az',
    'ca',
    'cs',
    'da',
    'de',
    'dv',
    'en',
    'es',
    'et',
    'fi',
    'fr',
    'gr',
    'he',
    'hi',
    'hu',
    'it',
    'km',
    'ku',
    'mn',
    'ms',
    'no',
    'pt',
    'ro',
    'ru',
    'rw',
    'sv',
    'th',
    'uk',
    'vi',
  };
}

/// Used if the locale is not supported by GlobalMaterialLocalizations.
class FallbackMaterialLocalizationDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const FallbackMaterialLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => _isSupportedLocale(locale);

  @override
  Future<MaterialLocalizations> load(Locale locale) async =>
      SynchronousFuture<MaterialLocalizations>(
        const DefaultMaterialLocalizations(),
      );

  @override
  bool shouldReload(FallbackMaterialLocalizationDelegate old) => false;
}

/// Used if the locale is not supported by GlobalCupertinoLocalizations.
class FallbackCupertinoLocalizationDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const FallbackCupertinoLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => _isSupportedLocale(locale);

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      SynchronousFuture<CupertinoLocalizations>(
        const DefaultCupertinoLocalizations(),
      );

  @override
  bool shouldReload(FallbackCupertinoLocalizationDelegate old) => false;
}

class FFLocalizationsDelegate extends LocalizationsDelegate<FFLocalizations> {
  const FFLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => _isSupportedLocale(locale);

  @override
  Future<FFLocalizations> load(Locale locale) =>
      SynchronousFuture<FFLocalizations>(FFLocalizations(locale));

  @override
  bool shouldReload(FFLocalizationsDelegate old) => false;
}

Locale createLocale(String language) => language.contains('_')
    ? Locale.fromSubtags(
        languageCode: language.split('_').first,
        scriptCode: language.split('_').last,
      )
    : Locale(language);

bool _isSupportedLocale(Locale locale) {
  final language = locale.toString();
  return FFLocalizations.languages().contains(
    language.endsWith('_')
        ? language.substring(0, language.length - 1)
        : language,
  );
}

final kTranslationsMap = <Map<String, Map<String, String>>>[
  // Login
  {
    'd4vwpi9q': {
      'en': 'Quicky Solutions LLC',
      'id': '',
      'ms': '',
    },
    'xkz4xjo6': {
      'en': 'Use your admin account',
      'id': 'Gunakan formulir di bawah ini untuk mengakses akun Anda.',
      'ms': 'Gunakan borang di bawah untuk mengakses akaun anda.',
    },
    'k9u5spqi': {
      'en': '',
      'id': 'Alamat email',
      'ms': 'Alamat emel',
    },
    'f4xxyrqv': {
      'en': 'Enter your email here...',
      'id': 'Masukkan email Anda disini...',
      'ms': 'Masukkan e-mel anda di sini...',
    },
    'lfzvgi5q': {
      'en': '',
      'id': 'Kata sandi',
      'ms': 'Kata laluan',
    },
    'wt8sx5du': {
      'en': 'Enter your password here...',
      'id': 'Masukkan kata sandi Anda di sini...',
      'ms': 'Masukkan kata laluan anda di sini...',
    },
    's8bicxzh': {
      'en': 'Quicky B2B',
      'id': 'Tidak ingat kata sandi?',
      'ms': 'Lupa kata laluan?',
    },
    'm9klj9ah': {
      'en': 'Login',
      'id': 'Gabung',
      'ms': 'Log masuk',
    },
    'iha5socs': {
      'en': 'Home',
      'id': 'Rumah',
      'ms': 'Rumah',
    },
  },
  // createAccount
  {
    'fqka5yg1': {
      'en': 'Quicky Soltuions LLC',
      'id': '',
      'ms': '',
    },
    'l2xxy1gf': {
      'en': 'Get Started',
      'id': 'Memulai',
      'ms': 'Mulakan',
    },
    '59g0bt96': {
      'en': 'Use the form below to get started.',
      'id': 'Gunakan formulir di bawah ini untuk memulai.',
      'ms': 'Gunakan borang di bawah untuk bermula.',
    },
    'seheok8a': {
      'en': 'Email Address',
      'id': 'Alamat email',
      'ms': 'Alamat emel',
    },
    '0uknk55c': {
      'en': 'Enter your email here...',
      'id': 'Masukkan email Anda disini...',
      'ms': 'Masukkan e-mel anda di sini...',
    },
    'wwxuev1r': {
      'en': 'Password',
      'id': 'Kata sandi',
      'ms': 'Kata laluan',
    },
    'eextb60x': {
      'en': 'Enter your email here...',
      'id': 'Masukkan email Anda disini...',
      'ms': 'Masukkan e-mel anda di sini...',
    },
    'kx2trk1o': {
      'en': 'Confirm Password',
      'id': 'konfirmasi sandi',
      'ms': 'Sahkan Kata Laluan',
    },
    'k8c3y3u7': {
      'en': 'Enter your email here...',
      'id': 'Masukkan email Anda disini...',
      'ms': 'Masukkan e-mel anda di sini...',
    },
    '29ut49wi': {
      'en': 'Create Account',
      'id': 'Buat Akun',
      'ms': 'Buat akaun',
    },
    '07gxzzhq': {
      'en': 'Use a social platform to continue',
      'id': 'Gunakan platform sosial untuk melanjutkan',
      'ms': 'Gunakan platform sosial untuk meneruskan',
    },
    'ysqhbhpe': {
      'en': 'Already have an account?',
      'id': 'Sudah memiliki akun?',
      'ms': 'Sudah mempunyai akaun?',
    },
    'ud92zl8z': {
      'en': 'Log In',
      'id': 'Gabung',
      'ms': 'Log masuk',
    },
    'zuuuklky': {
      'en': 'Home',
      'id': 'Rumah',
      'ms': 'Rumah',
    },
  },
  // quickysolutionsllcdashboard
  {
    '3bi54x5g': {
      'en': 'Dashboard',
      'id': 'Dasbor',
      'ms': 'Papan pemuka',
    },
    'nnv46x35': {
      'en': 'Welcome to Quicky Dashboard.',
      'id': 'Di bawah ini adalah ringkasan aktivitas tim Anda.',
      'ms': 'Di bawah ialah ringkasan aktiviti pasukan anda.',
    },
    'ktivjiti': {
      'en': 'All Users\nPlataform',
      'id': 'pelanggan baru',
      'ms': 'pelanggan baru',
    },
    'wq6fn2u7': {
      'en': 'Tasks\nIn Quicky Tasks',
      'id': 'Kontrak Baru',
      'ms': 'Kontrak Baru',
    },
    'lf3gnx2p': {
      'en': 'Communities',
      'id': 'Kontrak Kedaluwarsa',
      'ms': 'Kontrak Tamat',
    },
    'uuhwuuxx': {
      'en': 'Earnings /month',
      'id': 'Kontrak Kedaluwarsa',
      'ms': 'Kontrak Tamat',
    },
    'ljuv889s': {
      'en': 'All Tickets',
      'id': 'Kontrak Kedaluwarsa',
      'ms': 'Kontrak Tamat',
    },
    'tpwh9dqf': {
      'en': '4300',
      'id': '4300',
      'ms': '4300',
    },
    'kphqz3hi': {
      'en': 'Quicky Plataform',
      'id': 'Proyek',
      'ms': 'Projek',
    },
    'g0kj4v5y': {
      'en': 'Status',
      'id': '',
      'ms': '',
    },
    'ph0agme8': {
      'en': 'Quicky Tasks',
      'id': 'Aktivitas Kontrak',
      'ms': 'Aktiviti Kontrak',
    },
    'lz9jmnh7': {
      'en': 'All information about the Quicky Tasks app.',
      'id': 'Di bawah ini adalah ringkasan kegiatan.',
      'ms': 'Di bawah ialah ringkasan aktiviti.',
    },
    'gxxpy5m1': {
      'en': 'Status',
      'id': '',
      'ms': '',
    },
    '9j0vrfh9': {
      'en': 'Quicky Tasks',
      'id': 'Aktivitas Kontrak',
      'ms': 'Aktiviti Kontrak',
    },
    'kem72pud': {
      'en': 'All information about the \nQuicky Tasks app.',
      'id': 'Di bawah ini adalah ringkasan kegiatan.',
      'ms': 'Di bawah ialah ringkasan aktiviti.',
    },
    'tzuvmho2': {
      'en': 'Status',
      'id': '',
      'ms': '',
    },
    'hak6pwb5': {
      'en': 'Off',
      'id': '',
      'ms': '',
    },
    '9ezid24o': {
      'en': 'Quicky Essencials',
      'id': 'Aktivitas Kontrak',
      'ms': 'Aktiviti Kontrak',
    },
    'abdglv13': {
      'en': 'All information about the \nQuicky Essencials app.',
      'id': 'Di bawah ini adalah ringkasan kegiatan.',
      'ms': 'Di bawah ialah ringkasan aktiviti.',
    },
    '9hc8tr4f': {
      'en': 'Dashboard Quicky B2B',
      'id': 'Dasbor',
      'ms': 'Papan pemuka',
    },
    'uehbzuts': {
      'en': 'Balance - 0 Qs',
      'id': '',
      'ms': '',
    },
    's8h364mm': {
      'en': 'Approved\nTasks',
      'id': 'pelanggan baru',
      'ms': 'pelanggan baru',
    },
    'mtxi6ab2': {
      'en': '24',
      'id': '24',
      'ms': '24',
    },
    'ykhwtvxl': {
      'en': 'Tasks being \nPerformed',
      'id': 'Kontrak Baru',
      'ms': 'Kontrak Baru',
    },
    '4klvzqbz': {
      'en': '50',
      'id': '3.200',
      'ms': '3,200',
    },
    'qunhlzju': {
      'en': 'Completed \nTasks',
      'id': 'Kontrak Kedaluwarsa',
      'ms': 'Kontrak Tamat',
    },
    'h59irx65': {
      'en': '4300',
      'id': '4300',
      'ms': '4300',
    },
    'mo7ll3tj': {
      'en': 'Earnings',
      'id': 'Kontrak Kedaluwarsa',
      'ms': 'Kontrak Tamat',
    },
    'epgjggqi': {
      'en': '10 Qs',
      'id': '4300',
      'ms': '4300',
    },
    'sbnrylhs': {
      'en': 'Business \nReviews',
      'id': 'Kontrak Kedaluwarsa',
      'ms': 'Kontrak Tamat',
    },
    'hczcmf6p': {
      'en': '4300',
      'id': '4300',
      'ms': '4300',
    },
    'kndfpe4d': {
      'en': 'Community',
      'id': '',
      'ms': '',
    },
    'gtmdz1wb': {
      'en': 'Search...',
      'id': '',
      'ms': '',
    },
    'b1kqu71r': {
      'en': 'Option 1',
      'id': '',
      'ms': '',
    },
    '4cler0ht': {
      'en': 'Option 2',
      'id': '',
      'ms': '',
    },
    '13epkr22': {
      'en': 'Option 3',
      'id': '',
      'ms': '',
    },
    'kpv0xnno': {
      'en': 'STEPS',
      'id': 'Randy Alcorn',
      'ms': 'Randy Alcorn',
    },
    '0o4069hq': {
      'en': 'Status',
      'id': '',
      'ms': '',
    },
    'y9j9sie7': {
      'en': 'Quicky Tasks',
      'id': 'Aktivitas Kontrak',
      'ms': 'Aktiviti Kontrak',
    },
    'zdn5eydc': {
      'en': 'All information about the \nQuicky Tasks app.',
      'id': 'Di bawah ini adalah ringkasan kegiatan.',
      'ms': 'Di bawah ialah ringkasan aktiviti.',
    },
    '05fl8l6f': {
      'en': 'Status',
      'id': '',
      'ms': '',
    },
    '5ztyd7sc': {
      'en': 'Off',
      'id': '',
      'ms': '',
    },
    'rxd3kq23': {
      'en': 'Quicky Essencials',
      'id': 'Aktivitas Kontrak',
      'ms': 'Aktiviti Kontrak',
    },
    'rdlrchuw': {
      'en': 'All information about the \nQuicky Essencials app.',
      'id': 'Di bawah ini adalah ringkasan kegiatan.',
      'ms': 'Di bawah ialah ringkasan aktiviti.',
    },
    'ea5f64kq': {
      'en': 'OOPS! You do not have permission to access our dashboard.',
      'id': '',
      'ms': '',
    },
    'y24lcr13': {
      'en': 'Dashboard',
      'id': 'Dasbor',
      'ms': 'Papan pemuka',
    },
    'xdxbdj20': {
      'en': '__',
      'id': '__',
      'ms': '__',
    },
  },
  // dashboardQuickyTasks
  {
    'ghw6y9ib': {
      'en': 'Quicky Tasks Dashboard',
      'id': 'Kontrak',
      'ms': 'Kontrak',
    },
    'mrajtsee': {
      'en': 'Test Quicky Tasks',
      'id': '',
      'ms': '',
    },
    'pzi92och': {
      'en': 'Status',
      'id': '',
      'ms': '',
    },
    'tqd8dgyc': {
      'en': 'Quicky Tasks Dashboard',
      'id': 'Kontrak',
      'ms': 'Kontrak',
    },
    '278eck7u': {
      'en': 'Test Quicky Tasks',
      'id': '',
      'ms': '',
    },
    'b0am1gak': {
      'en': 'Status',
      'id': '',
      'ms': '',
    },
    'le4nopeu': {
      'en': 'Quicky Actions',
      'id': 'Proyek',
      'ms': 'Projek',
    },
    'mpntnjk1': {
      'en': 'All Users',
      'id': 'Desain Platform Tanpa Kode',
      'ms': 'Reka Bentuk Platform Tanpa Kod',
    },
    'cuzp0icr': {
      'en': 'Create a Task',
      'id': 'Dokumen Tim Desain',
      'ms': 'Dokumen Pasukan Reka Bentuk',
    },
    'benywaxl': {
      'en': 'Quicky Calendar',
      'id': 'Dokumen Tim Desain',
      'ms': 'Dokumen Pasukan Reka Bentuk',
    },
    '27pcydhh': {
      'en': 'Create a Mesh',
      'id': 'Dokumen Tim Desain',
      'ms': 'Dokumen Pasukan Reka Bentuk',
    },
    '5vupkjra': {
      'en': 'App Analytics',
      'id': 'Dokumen Tim Desain',
      'ms': 'Dokumen Pasukan Reka Bentuk',
    },
    '143i8tde': {
      'en': 'Push Notifications',
      'id': 'Dokumen Tim Desain',
      'ms': 'Dokumen Pasukan Reka Bentuk',
    },
    'emutpkke': {
      'en': 'Payments',
      'id': 'Dokumen Tim Desain',
      'ms': 'Dokumen Pasukan Reka Bentuk',
    },
    '6yfqf3jj': {
      'en': 'Support',
      'id': 'Dokumen Tim Desain',
      'ms': 'Dokumen Pasukan Reka Bentuk',
    },
    'xf5inflw': {
      'en': 'Earnings per month',
      'id': '',
      'ms': '',
    },
    'l6jc0uat': {
      'en': 'Users per month',
      'id': '',
      'ms': '',
    },
    'o8yr1fxd': {
      'en': 'Manage Tasks',
      'id': 'Kontrak',
      'ms': 'Kontrak',
    },
    'uxauwau4': {
      'en': 'Searching Tasker',
      'id': '',
      'ms': '',
    },
    'kcut1rru': {
      'en': 'ACME Co.',
      'id': 'ACME Co.',
      'ms': 'ACME Co.',
    },
    'nhk4ppw9': {
      'en': 'Contracts for New Opportunities',
      'id': 'Kontrak untuk Peluang Baru',
      'ms': 'Kontrak untuk Peluang Baru',
    },
    'jhfoupn6': {
      'en': 'Next Action',
      'id': 'Tindakan Selanjutnya',
      'ms': 'Tindakan Seterusnya',
    },
    'gmpc58le': {
      'en': 'Tuesday, 10:00am',
      'id': 'Selasa, 10:00',
      'ms': 'Selasa, 10:00 pagi',
    },
    'n5wl0ulw': {
      'en': 'In Progress',
      'id': 'Sedang berlangsung',
      'ms': 'Sedang Berlangsung',
    },
    'ezbfjpb0': {
      'en': 'ACME Co.',
      'id': 'ACME Co.',
      'ms': 'ACME Co.',
    },
    'ephpw6cz': {
      'en': 'Contracts for New Opportunities',
      'id': 'Kontrak untuk Peluang Baru',
      'ms': 'Kontrak untuk Peluang Baru',
    },
    'htgl9t5y': {
      'en': 'Next Action',
      'id': 'Tindakan Selanjutnya',
      'ms': 'Tindakan Seterusnya',
    },
    'di1gazac': {
      'en': 'Tuesday, 10:00am',
      'id': 'Selasa, 10:00',
      'ms': 'Selasa, 10:00 pagi',
    },
    'b4c3m7h6': {
      'en': 'In Progress',
      'id': 'Sedang berlangsung',
      'ms': 'Sedang Berlangsung',
    },
    'o3dp9tss': {
      'en': '__',
      'id': '__',
      'ms': '__',
    },
  },
  // edittask
  {
    '4wpaslre': {
      'en': 'More About the Task',
      'id': '',
      'ms': '',
    },
    'srln7kwe': {
      'en': 'Add more steps...',
      'id': '',
      'ms': '',
    },
    'g3x6ebco': {
      'en': 'Add',
      'id': '',
      'ms': '',
    },
    'rkh9mbcq': {
      'en': 'Book \nNow',
      'id': '',
      'ms': '',
    },
    'yezthspx': {
      'en': 'Category',
      'id': '',
      'ms': '',
    },
    '3nhq5vcu': {
      'en': 'Description',
      'id': '',
      'ms': '',
    },
    'd5ek1q3r': {
      'en': 'Select Category...',
      'id': '',
      'ms': '',
    },
    'nux51jan': {
      'en': 'Search...',
      'id': '',
      'ms': '',
    },
    'mystnqmm': {
      'en': 'Option 1',
      'id': '',
      'ms': '',
    },
    '4itdo1cr': {
      'en': 'Option 2',
      'id': '',
      'ms': '',
    },
    't3649hwf': {
      'en': 'Option 3',
      'id': '',
      'ms': '',
    },
    'v5gt1zgm': {
      'en': 'Price',
      'id': '',
      'ms': '',
    },
    'rr8ksatz': {
      'en': 'Save Changes',
      'id': '',
      'ms': '',
    },
    '20uycztj': {
      'en': 'Edit Profile',
      'id': '',
      'ms': '',
    },
  },
  // appAnalystics
  {
    'o0eghhjy': {
      'en': 'Quicky Analytics',
      'id': 'Dasbor',
      'ms': 'Papan pemuka',
    },
    'xod5y5ke': {
      'en':
          'This section provides a comprehensive performance analysis of the app.',
      'id': 'Di bawah ini adalah ringkasan aktivitas tim Anda.',
      'ms': 'Di bawah ialah ringkasan aktiviti pasukan anda.',
    },
    'xfep0dp1': {
      'en': 'All Users',
      'id': 'pelanggan baru',
      'ms': 'pelanggan baru',
    },
    'emyrr25q': {
      'en': 'All Tasks',
      'id': 'Kontrak Baru',
      'ms': 'Kontrak Baru',
    },
    '4ufm4m0n': {
      'en': 'Communities',
      'id': 'Kontrak Kedaluwarsa',
      'ms': 'Kontrak Tamat',
    },
    '4j3ipdul': {
      'en': 'Experience Kits',
      'id': 'Kontrak Kedaluwarsa',
      'ms': 'Kontrak Tamat',
    },
    'k4jjcmr7': {
      'en': '4300',
      'id': '4300',
      'ms': '4300',
    },
    '7fa802gg': {
      'en': 'Earnings /month',
      'id': 'Kontrak Kedaluwarsa',
      'ms': 'Kontrak Tamat',
    },
    'ndp2q2oi': {
      'en': 'Projects',
      'id': 'Proyek',
      'ms': 'Projek',
    },
    'py40fvdn': {
      'en': 'Users Active',
      'id': 'Aktivitas Kontrak',
      'ms': 'Aktiviti Kontrak',
    },
    'iu4rhnhx': {
      'en': 'Date',
      'id': '',
      'ms': '',
    },
    '45on25di': {
      'en': 'Users',
      'id': '',
      'ms': '',
    },
    'w9axyufw': {
      'en': 'Userss Active',
      'id': '',
      'ms': '',
    },
    'x9rfc7jb': {
      'en': 'Contract Activity',
      'id': 'Aktivitas Kontrak',
      'ms': 'Aktiviti Kontrak',
    },
    'ciwte0oj': {
      'en': 'Below is an a summary of activity.',
      'id': 'Di bawah ini adalah ringkasan kegiatan.',
      'ms': 'Di bawah ialah ringkasan aktiviti.',
    },
    'rtvuaok1': {
      'en': 'Contract Activity',
      'id': 'Aktivitas Kontrak',
      'ms': 'Aktiviti Kontrak',
    },
    'xhqbpejk': {
      'en': 'Below is an a summary of activity.',
      'id': 'Di bawah ini adalah ringkasan kegiatan.',
      'ms': 'Di bawah ialah ringkasan aktiviti.',
    },
    'e6tsmfmw': {
      'en': 'Customer Activity',
      'id': 'Aktivitas Pelanggan',
      'ms': 'Aktiviti Pelanggan',
    },
    'xh7w2jwu': {
      'en': 'Below is an a summary of activity.',
      'id': 'Di bawah ini adalah ringkasan kegiatan.',
      'ms': 'Di bawah ialah ringkasan aktiviti.',
    },
    '3v8giru0': {
      'en': 'Dashboard',
      'id': 'Dasbor',
      'ms': 'Papan pemuka',
    },
    'b3xnjf3b': {
      'en': '__',
      'id': '__',
      'ms': '__',
    },
  },
  // alluserapage
  {
    'cu4pim6a': {
      'en': 'Customers',
      'id': 'Pelanggan',
      'ms': 'Pelanggan',
    },
    'yf35wbyw': {
      'en': 'All Users',
      'id': 'Pelanggan',
      'ms': 'Pelanggan',
    },
    '6rsv14jb': {
      'en': 'James Wiseman',
      'id': 'James Wiseman',
      'ms': 'James Wiseman',
    },
    '8huh0vou': {
      'en': 'Account Manager',
      'id': 'Manajer Akuntansi',
      'ms': 'Pengurus akaun',
    },
    '8noqpubh': {
      'en': 'ACME Co.',
      'id': 'ACME Co.',
      'ms': 'ACME Co.',
    },
    '5vjbg1sv': {
      'en': 'Ignacious Rodriguez',
      'id': 'Rodriguez yang kejam',
      'ms': 'Ignacious Rodriguez',
    },
    'kpmxarx4': {
      'en': 'Sales Manager',
      'id': 'Manajer penjualan',
      'ms': 'Pengurus jualan',
    },
    '8n6ksxl8': {
      'en': 'Robin HQ',
      'id': 'Robin HQ',
      'ms': 'Robin HQ',
    },
    '391o4ak9': {
      'en': 'Elena Williams',
      'id': 'Elena Williams',
      'ms': 'Elena Williams',
    },
    'yrkffu5w': {
      'en': 'Head of Product & Innovation',
      'id': 'Kepala Produk &amp; Inovasi',
      'ms': 'Ketua Produk &amp; Inovasi',
    },
    'yoij44uz': {
      'en': 'Robin HQ',
      'id': 'Robin HQ',
      'ms': 'Robin HQ',
    },
    'hag4366z': {
      'en': 'Greg Brown',
      'id': 'Greg Brown',
      'ms': 'Greg Brown',
    },
    '6cdt0ck1': {
      'en': 'Account Manager',
      'id': 'Manajer Akuntansi',
      'ms': 'Pengurus akaun',
    },
    'ax2v3cdh': {
      'en': 'Robin HQ',
      'id': 'Robin HQ',
      'ms': 'Robin HQ',
    },
    '1rdoyv3c': {
      'en': 'June Williamson',
      'id': 'Juni Williamson',
      'ms': 'June Williamson',
    },
    'jrsgkkyr': {
      'en': 'Sr. Account Manager',
      'id': 'Manajer Akun Senior',
      'ms': 'Tuan Pengurus Akaun',
    },
    'cdbltvwy': {
      'en': 'HealthAi',
      'id': 'KesehatanAi',
      'ms': 'KesihatanAi',
    },
    'ycbt5lev': {
      'en': 'June Williamson',
      'id': 'Juni Williamson',
      'ms': 'June Williamson',
    },
    'ze8bad9c': {
      'en': 'Sr. Account Manager',
      'id': 'Manajer Akun Senior',
      'ms': 'Tuan Pengurus Akaun',
    },
    'y6xpb89e': {
      'en': 'HealthAi',
      'id': 'KesehatanAi',
      'ms': 'KesihatanAi',
    },
    'rwu243fy': {
      'en': '__',
      'id': '__',
      'ms': '__',
    },
  },
  // taskspreprontas
  {
    '6qnfjgem': {
      'en': 'Customers',
      'id': 'Pelanggan',
      'ms': 'Pelanggan',
    },
    'q49tqfef': {
      'en': 'Create Tasks ',
      'id': 'Pelanggan',
      'ms': 'Pelanggan',
    },
    '6fch6exm': {
      'en': 'Add New Task',
      'id': 'Pelanggan',
      'ms': 'Pelanggan',
    },
    'd9bjktza': {
      'en': 'Edit, create or delete pre-made tasks.',
      'id': 'Pelanggan',
      'ms': 'Pelanggan',
    },
    'atto587d': {
      'en': '__',
      'id': '__',
      'ms': '__',
    },
  },
  // QuickyTestRealTime
  {
    'vnqqvvce': {
      'en': 'Test Quicky Tasks in real time',
      'id': '',
      'ms': '',
    },
    '9ss8iwzg': {
      'en': 'Home',
      'id': 'Rumah',
      'ms': 'Rumah',
    },
  },
  // Events
  {
    'lp8581z0': {
      'en': 'Quicky Tasks Dashboard',
      'id': 'Kontrak',
      'ms': 'Kontrak',
    },
    'rvloca08': {
      'en': 'Test Quicky Tasks',
      'id': '',
      'ms': '',
    },
    'im7c8y6a': {
      'en': 'Status',
      'id': '',
      'ms': '',
    },
    'p4ydr18k': {
      'en': 'Quicky Mesh ',
      'id': 'Kontrak',
      'ms': 'Kontrak',
    },
    's8w09h8v': {
      'en': 'Test Quicky Tasks',
      'id': '',
      'ms': '',
    },
    'y683ib3c': {
      'en': 'Status',
      'id': '',
      'ms': '',
    },
    'g1kn0bpa': {
      'en': 'Events Actions',
      'id': 'Proyek',
      'ms': 'Projek',
    },
    '5hjininm': {
      'en': 'Create Event',
      'id': 'Desain Platform Tanpa Kode',
      'ms': 'Reka Bentuk Platform Tanpa Kod',
    },
    'raexffck': {
      'en': 'App Analytics',
      'id': 'Dokumen Tim Desain',
      'ms': 'Dokumen Pasukan Reka Bentuk',
    },
    'ynqn579v': {
      'en': 'Events',
      'id': 'Kontrak',
      'ms': 'Kontrak',
    },
    'ucdz4u3g': {
      'en': 'ACME Co.',
      'id': 'ACME Co.',
      'ms': 'ACME Co.',
    },
    '78q06459': {
      'en': 'Contracts for New Opportunities',
      'id': 'Kontrak untuk Peluang Baru',
      'ms': 'Kontrak untuk Peluang Baru',
    },
    'u30x2kpm': {
      'en': 'Next Action',
      'id': 'Tindakan Selanjutnya',
      'ms': 'Tindakan Seterusnya',
    },
    'p5pdndp9': {
      'en': 'Tuesday, 10:00am',
      'id': 'Selasa, 10:00',
      'ms': 'Selasa, 10:00 pagi',
    },
    'xzmhgv4r': {
      'en': 'In Progress',
      'id': 'Sedang berlangsung',
      'ms': 'Sedang Berlangsung',
    },
    '2ndei1xb': {
      'en': 'ACME Co.',
      'id': 'ACME Co.',
      'ms': 'ACME Co.',
    },
    '0ljdoy9a': {
      'en': 'Contracts for New Opportunities',
      'id': 'Kontrak untuk Peluang Baru',
      'ms': 'Kontrak untuk Peluang Baru',
    },
    'ujs3ac5g': {
      'en': 'Next Action',
      'id': 'Tindakan Selanjutnya',
      'ms': 'Tindakan Seterusnya',
    },
    'ycdppc1a': {
      'en': 'Tuesday, 10:00am',
      'id': 'Selasa, 10:00',
      'ms': 'Selasa, 10:00 pagi',
    },
    '5id4tzmx': {
      'en': 'In Progress',
      'id': 'Sedang berlangsung',
      'ms': 'Sedang Berlangsung',
    },
    'xa3oh10i': {
      'en': '__',
      'id': '__',
      'ms': '__',
    },
  },
  // dashboardQuickyTasksCopyCopy
  {
    'v48kx8uj': {
      'en': 'Quicky Tasks Dashboard',
      'id': 'Kontrak',
      'ms': 'Kontrak',
    },
    'son3vtnr': {
      'en': 'Test Quicky Tasks',
      'id': '',
      'ms': '',
    },
    'vxu1ulm6': {
      'en': 'Status',
      'id': '',
      'ms': '',
    },
    'nll5tian': {
      'en': 'Payments',
      'id': 'Kontrak',
      'ms': 'Kontrak',
    },
    'vpqgerrw': {
      'en': 'Test Quicky Tasks',
      'id': '',
      'ms': '',
    },
    'yp3kjgpa': {
      'en': 'Status',
      'id': '',
      'ms': '',
    },
    'lg9cztni': {
      'en': 'Payment Report',
      'id': 'Proyek',
      'ms': 'Projek',
    },
    'uszx64t4': {
      'en': 'All Payments',
      'id': 'Kontrak',
      'ms': 'Kontrak',
    },
    'aeqw4mm7': {
      'en': 'Earnings',
      'id': '',
      'ms': '',
    },
    'wvdepdjo': {
      'en': 'To withdraw',
      'id': '',
      'ms': '',
    },
    'uyc1asfq': {
      'en': 'ACME Co.',
      'id': 'ACME Co.',
      'ms': 'ACME Co.',
    },
    'gauvkp17': {
      'en': 'Contracts for New Opportunities',
      'id': 'Kontrak untuk Peluang Baru',
      'ms': 'Kontrak untuk Peluang Baru',
    },
    'umuya0lu': {
      'en': 'Next Action',
      'id': 'Tindakan Selanjutnya',
      'ms': 'Tindakan Seterusnya',
    },
    'oq4p817l': {
      'en': 'Tuesday, 10:00am',
      'id': 'Selasa, 10:00',
      'ms': 'Selasa, 10:00 pagi',
    },
    'uptd0kyf': {
      'en': 'In Progress',
      'id': 'Sedang berlangsung',
      'ms': 'Sedang Berlangsung',
    },
    'j7hhuxt3': {
      'en': '__',
      'id': '__',
      'ms': '__',
    },
  },
  // createPreTasks
  {
    'q8my0mp5': {
      'en': 'More About the Task',
      'id': '',
      'ms': '',
    },
    'nxm2mv5k': {
      'en': 'Add steps...',
      'id': '',
      'ms': '',
    },
    'dywni8qn': {
      'en': 'Add',
      'id': '',
      'ms': '',
    },
    'qhe9oadh': {
      'en': 'Book \nNow',
      'id': '',
      'ms': '',
    },
    'dlueu91g': {
      'en': 'Materials Price',
      'id': '',
      'ms': '',
    },
    'g67gkpxc': {
      'en': 'Add steps...',
      'id': '',
      'ms': '',
    },
    '9di4so9f': {
      'en': 'Add',
      'id': '',
      'ms': '',
    },
    'mfqz46ml': {
      'en': 'Category',
      'id': '',
      'ms': '',
    },
    '7o0ismrn': {
      'en': 'Description',
      'id': '',
      'ms': '',
    },
    'oqehiscg': {
      'en': 'Select Category...',
      'id': '',
      'ms': '',
    },
    '0y8142cv': {
      'en': 'Search...',
      'id': '',
      'ms': '',
    },
    'fq2d1d89': {
      'en': 'Option 1',
      'id': '',
      'ms': '',
    },
    'uiqmkps0': {
      'en': 'Option 2',
      'id': '',
      'ms': '',
    },
    'rlsi45xf': {
      'en': 'Option 3',
      'id': '',
      'ms': '',
    },
    'xfymtjc5': {
      'en': 'Price',
      'id': '',
      'ms': '',
    },
    'wbprsf51': {
      'en': 'Create',
      'id': '',
      'ms': '',
    },
    'jhyaeloh': {
      'en': 'Edit Profile',
      'id': '',
      'ms': '',
    },
  },
  // createPreTasksCopy
  {
    'mi38jnqe': {
      'en': 'Title',
      'id': '',
      'ms': '',
    },
    'efp9fmxo': {
      'en': 'Description',
      'id': '',
      'ms': '',
    },
    'jdp5s4ej': {
      'en': 'Create',
      'id': '',
      'ms': '',
    },
    'x0xgr5ch': {
      'en': 'Edit Profile',
      'id': '',
      'ms': '',
    },
  },
  // loginBusinessParter
  {
    '1v76xhtg': {
      'en': 'Quicky B2B',
      'id': '',
      'ms': '',
    },
    'ndo0nbgq': {
      'en': 'Login',
      'id': '',
      'ms': '',
    },
    '0gmfgyhu': {
      'en': 'Let\'s get started by filling out the form below.',
      'id': '',
      'ms': '',
    },
    '1ime122j': {
      'en': 'Email',
      'id': '',
      'ms': '',
    },
    '1gavosez': {
      'en': 'Password',
      'id': '',
      'ms': '',
    },
    'z8k5445r': {
      'en': 'Login',
      'id': '',
      'ms': '',
    },
    'p0yz2h8i': {
      'en': 'Home',
      'id': '',
      'ms': '',
    },
  },
  // QuickyB2B
  {
    '3dvgoqhr': {
      'en': 'Dashboard Quicky B2B',
      'id': 'Dasbor',
      'ms': 'Papan pemuka',
    },
    'zdcdjooq': {
      'en': 'Approved\nTasks',
      'id': 'pelanggan baru',
      'ms': 'pelanggan baru',
    },
    'sp02p4md': {
      'en': '24',
      'id': '24',
      'ms': '24',
    },
    'c7ojswos': {
      'en': 'Tasks being \nPerformed',
      'id': 'Kontrak Baru',
      'ms': 'Kontrak Baru',
    },
    '9de5sa91': {
      'en': '50',
      'id': '3.200',
      'ms': '3,200',
    },
    'xuxl5hsr': {
      'en': 'Completed \nTasks',
      'id': 'Kontrak Kedaluwarsa',
      'ms': 'Kontrak Tamat',
    },
    'wsub24i9': {
      'en': '4300',
      'id': '4300',
      'ms': '4300',
    },
    'c1miy7zb': {
      'en': 'Earnings',
      'id': 'Kontrak Kedaluwarsa',
      'ms': 'Kontrak Tamat',
    },
    'ii9ln3y4': {
      'en': '10 Qs',
      'id': '4300',
      'ms': '4300',
    },
    'urujwacj': {
      'en': 'Business \nReviews',
      'id': 'Kontrak Kedaluwarsa',
      'ms': 'Kontrak Tamat',
    },
    '1yvt752v': {
      'en': '4300',
      'id': '4300',
      'ms': '4300',
    },
    'u3k048xg': {
      'en': 'Community',
      'id': '',
      'ms': '',
    },
    '5k7vnld5': {
      'en': 'Search...',
      'id': '',
      'ms': '',
    },
    'e6203eeq': {
      'en': 'Option 1',
      'id': '',
      'ms': '',
    },
    'obj4rvn7': {
      'en': 'Option 2',
      'id': '',
      'ms': '',
    },
    'nd2asxl8': {
      'en': 'Option 3',
      'id': '',
      'ms': '',
    },
    'khtfv7k0': {
      'en': 'STEPS',
      'id': 'Randy Alcorn',
      'ms': 'Randy Alcorn',
    },
    'n7tehu69': {
      'en': 'Status',
      'id': '',
      'ms': '',
    },
    'gmjr53tc': {
      'en': 'Quicky Tasks',
      'id': 'Aktivitas Kontrak',
      'ms': 'Aktiviti Kontrak',
    },
    'bbdxjqre': {
      'en': 'All information about the \nQuicky Tasks app.',
      'id': 'Di bawah ini adalah ringkasan kegiatan.',
      'ms': 'Di bawah ialah ringkasan aktiviti.',
    },
    'xy9quizc': {
      'en': 'Status',
      'id': '',
      'ms': '',
    },
    'v9vo1tqa': {
      'en': 'Off',
      'id': '',
      'ms': '',
    },
    'fvny7o4r': {
      'en': 'Quicky Essencials',
      'id': 'Aktivitas Kontrak',
      'ms': 'Aktiviti Kontrak',
    },
    'lm0z7ld8': {
      'en': 'All information about the \nQuicky Essencials app.',
      'id': 'Di bawah ini adalah ringkasan kegiatan.',
      'ms': 'Di bawah ialah ringkasan aktiviti.',
    },
    'tl18b88g': {
      'en': 'Dashboard',
      'id': 'Dasbor',
      'ms': 'Papan pemuka',
    },
    '66eqtl17': {
      'en': '__',
      'id': '__',
      'ms': '__',
    },
  },
  // AllTasksPerformed
  {
    '87ue8qpv': {
      'en': 'All Tasks Performed',
      'id': 'Dasbor',
      'ms': 'Papan pemuka',
    },
    'yzvsjpn2': {
      'en': 'Status',
      'id': '',
      'ms': '',
    },
    'gdww7511': {
      'en': 'Search...',
      'id': '',
      'ms': '',
    },
    '87k4xkx7': {
      'en': 'Option 1',
      'id': '',
      'ms': '',
    },
    'urg5an4i': {
      'en': 'Option 2',
      'id': '',
      'ms': '',
    },
    'rgr0d4ys': {
      'en': 'Option 3',
      'id': '',
      'ms': '',
    },
    '7wwu5kfp': {
      'en': 'Waiting for taskee approval',
      'id': 'Kepala Pengadaan',
      'ms': 'Ketua Perolehan',
    },
    'szyspvzy': {
      'en': 'STEPS',
      'id': 'Randy Alcorn',
      'ms': 'Randy Alcorn',
    },
    '7866lg0l': {
      'en': 'Status',
      'id': '',
      'ms': '',
    },
    'x2wo2kcu': {
      'en': 'Quicky Tasks',
      'id': 'Aktivitas Kontrak',
      'ms': 'Aktiviti Kontrak',
    },
    'iu9xzs8v': {
      'en': 'All information about the \nQuicky Tasks app.',
      'id': 'Di bawah ini adalah ringkasan kegiatan.',
      'ms': 'Di bawah ialah ringkasan aktiviti.',
    },
    '3aubor9l': {
      'en': 'Status',
      'id': '',
      'ms': '',
    },
    'ywyt2tha': {
      'en': 'Off',
      'id': '',
      'ms': '',
    },
    'guz7za7n': {
      'en': 'Quicky Essencials',
      'id': 'Aktivitas Kontrak',
      'ms': 'Aktiviti Kontrak',
    },
    '9npubn79': {
      'en': 'All information about the \nQuicky Essencials app.',
      'id': 'Di bawah ini adalah ringkasan kegiatan.',
      'ms': 'Di bawah ialah ringkasan aktiviti.',
    },
    '0v3s7oe4': {
      'en': 'Dashboard',
      'id': 'Dasbor',
      'ms': 'Papan pemuka',
    },
    'nhshm8d2': {
      'en': '__',
      'id': '__',
      'ms': '__',
    },
  },
  // supportB2B
  {
    'vb87pf32': {
      'en': 'Support',
      'id': 'Dasbor',
      'ms': 'Papan pemuka',
    },
    'ucuhq5dr': {
      'en': 'Status',
      'id': '',
      'ms': '',
    },
    '88k6wk8b': {
      'en': 'Quicky Tasks',
      'id': 'Aktivitas Kontrak',
      'ms': 'Aktiviti Kontrak',
    },
    '0sjh2z27': {
      'en': 'All information about the \nQuicky Tasks app.',
      'id': 'Di bawah ini adalah ringkasan kegiatan.',
      'ms': 'Di bawah ialah ringkasan aktiviti.',
    },
    'hbb7uino': {
      'en': 'Status',
      'id': '',
      'ms': '',
    },
    'zu4ftak2': {
      'en': 'Off',
      'id': '',
      'ms': '',
    },
    'k51wwoxi': {
      'en': 'Quicky Essencials',
      'id': 'Aktivitas Kontrak',
      'ms': 'Aktiviti Kontrak',
    },
    'jy8kr1ls': {
      'en': 'All information about the \nQuicky Essencials app.',
      'id': 'Di bawah ini adalah ringkasan kegiatan.',
      'ms': 'Di bawah ialah ringkasan aktiviti.',
    },
    'p4jw0r51': {
      'en': 'All tickets',
      'id': '',
      'ms': '',
    },
    'muipfryi': {
      'en': 'Create Ticket',
      'id': '',
      'ms': '',
    },
    '0zlayqqm': {
      'en': 'Waiting',
      'id': '',
      'ms': '',
    },
    'sy59uks8': {
      'en': 'James Wiseman',
      'id': 'James Wiseman',
      'ms': 'James Wiseman',
    },
    'qp9j0hm9': {
      'en': 'Account Manager',
      'id': 'Manajer Akuntansi',
      'ms': 'Pengurus akaun',
    },
    'vplzmf4n': {
      'en': 'ACME Co.',
      'id': 'ACME Co.',
      'ms': 'ACME Co.',
    },
    '0aglbacp': {
      'en': 'Ignacious Rodriguez',
      'id': 'Rodriguez yang kejam',
      'ms': 'Ignacious Rodriguez',
    },
    '6gflaca3': {
      'en': 'Sales Manager',
      'id': 'Manajer penjualan',
      'ms': 'Pengurus jualan',
    },
    'mu1wv9qj': {
      'en': 'Robin HQ',
      'id': 'Robin HQ',
      'ms': 'Robin HQ',
    },
    '3g0pta0z': {
      'en': 'Elena Williams',
      'id': 'Elena Williams',
      'ms': 'Elena Williams',
    },
    'psy04qi7': {
      'en': 'Head of Product & Innovation',
      'id': 'Kepala Produk &amp; Inovasi',
      'ms': 'Ketua Produk &amp; Inovasi',
    },
    'd9ogowbf': {
      'en': 'Robin HQ',
      'id': 'Robin HQ',
      'ms': 'Robin HQ',
    },
    'x8qr68xz': {
      'en': 'Greg Brown',
      'id': 'Greg Brown',
      'ms': 'Greg Brown',
    },
    'i4bixav7': {
      'en': 'Account Manager',
      'id': 'Manajer Akuntansi',
      'ms': 'Pengurus akaun',
    },
    '0ivu7uon': {
      'en': 'Robin HQ',
      'id': 'Robin HQ',
      'ms': 'Robin HQ',
    },
    'raog5mhb': {
      'en': 'June Williamson',
      'id': 'Juni Williamson',
      'ms': 'June Williamson',
    },
    'f90z8j8n': {
      'en': 'Sr. Account Manager',
      'id': 'Manajer Akun Senior',
      'ms': 'Tuan Pengurus Akaun',
    },
    'bxgadagk': {
      'en': 'HealthAi',
      'id': 'KesehatanAi',
      'ms': 'KesihatanAi',
    },
    'u01m3xch': {
      'en': 'June Williamson',
      'id': 'Juni Williamson',
      'ms': 'June Williamson',
    },
    'jlg59oeu': {
      'en': 'Sr. Account Manager',
      'id': 'Manajer Akun Senior',
      'ms': 'Tuan Pengurus Akaun',
    },
    'hl74407m': {
      'en': 'HealthAi',
      'id': 'KesehatanAi',
      'ms': 'KesihatanAi',
    },
    '9z3hmluk': {
      'en': 'Dashboard',
      'id': 'Dasbor',
      'ms': 'Papan pemuka',
    },
    'cpf96wrk': {
      'en': '__',
      'id': '__',
      'ms': '__',
    },
  },
  // currentTasks
  {
    'wdc5q78v': {
      'en': 'Page Title',
      'id': '',
      'ms': '',
    },
    '9qxhsabg': {
      'en': 'Home',
      'id': '',
      'ms': '',
    },
  },
  // chatb2b
  {
    'eaepbips': {
      'en': 'Chat',
      'id': 'Dasbor',
      'ms': 'Papan pemuka',
    },
    'ho62ev5k': {
      'en': 'Status',
      'id': '',
      'ms': '',
    },
    'gehzkrmm': {
      'en': 'Quicky Tasks',
      'id': 'Aktivitas Kontrak',
      'ms': 'Aktiviti Kontrak',
    },
    'cre12gr5': {
      'en': 'All information about the \nQuicky Tasks app.',
      'id': 'Di bawah ini adalah ringkasan kegiatan.',
      'ms': 'Di bawah ialah ringkasan aktiviti.',
    },
    'ipcni0xn': {
      'en': 'Status',
      'id': '',
      'ms': '',
    },
    'yvamjtce': {
      'en': 'Off',
      'id': '',
      'ms': '',
    },
    '34tyrllj': {
      'en': 'Quicky Essencials',
      'id': 'Aktivitas Kontrak',
      'ms': 'Aktiviti Kontrak',
    },
    's39uzf7s': {
      'en': 'All information about the \nQuicky Essencials app.',
      'id': 'Di bawah ini adalah ringkasan kegiatan.',
      'ms': 'Di bawah ialah ringkasan aktiviti.',
    },
    'o0d4ix2n': {
      'en': 'All Tasker Chat',
      'id': '',
      'ms': '',
    },
    '49ohheoa': {
      'en': 'James Wiseman',
      'id': 'James Wiseman',
      'ms': 'James Wiseman',
    },
    '3losd0x2': {
      'en': 'Account Manager',
      'id': 'Manajer Akuntansi',
      'ms': 'Pengurus akaun',
    },
    'pyxildw3': {
      'en': 'ACME Co.',
      'id': 'ACME Co.',
      'ms': 'ACME Co.',
    },
    '5hlmwnti': {
      'en': 'Ignacious Rodriguez',
      'id': 'Rodriguez yang kejam',
      'ms': 'Ignacious Rodriguez',
    },
    '5n4u2jx1': {
      'en': 'Sales Manager',
      'id': 'Manajer penjualan',
      'ms': 'Pengurus jualan',
    },
    'h8737olb': {
      'en': 'Robin HQ',
      'id': 'Robin HQ',
      'ms': 'Robin HQ',
    },
    'nndixfn4': {
      'en': 'Elena Williams',
      'id': 'Elena Williams',
      'ms': 'Elena Williams',
    },
    'hjeic8gy': {
      'en': 'Head of Product & Innovation',
      'id': 'Kepala Produk &amp; Inovasi',
      'ms': 'Ketua Produk &amp; Inovasi',
    },
    '2lvsavbb': {
      'en': 'Robin HQ',
      'id': 'Robin HQ',
      'ms': 'Robin HQ',
    },
    '0o3369e4': {
      'en': 'Greg Brown',
      'id': 'Greg Brown',
      'ms': 'Greg Brown',
    },
    '4rn3243p': {
      'en': 'Account Manager',
      'id': 'Manajer Akuntansi',
      'ms': 'Pengurus akaun',
    },
    '98su2sms': {
      'en': 'Robin HQ',
      'id': 'Robin HQ',
      'ms': 'Robin HQ',
    },
    'mkcppfw4': {
      'en': 'June Williamson',
      'id': 'Juni Williamson',
      'ms': 'June Williamson',
    },
    '41powbur': {
      'en': 'Sr. Account Manager',
      'id': 'Manajer Akun Senior',
      'ms': 'Tuan Pengurus Akaun',
    },
    '50m6t82w': {
      'en': 'HealthAi',
      'id': 'KesehatanAi',
      'ms': 'KesihatanAi',
    },
    'ohetaiu0': {
      'en': 'June Williamson',
      'id': 'Juni Williamson',
      'ms': 'June Williamson',
    },
    '85sky9uj': {
      'en': 'Sr. Account Manager',
      'id': 'Manajer Akun Senior',
      'ms': 'Tuan Pengurus Akaun',
    },
    'k5ayabfh': {
      'en': 'HealthAi',
      'id': 'KesehatanAi',
      'ms': 'KesihatanAi',
    },
    'mp5ihsgz': {
      'en': 'Dashboard',
      'id': 'Dasbor',
      'ms': 'Papan pemuka',
    },
    'h388nev7': {
      'en': '__',
      'id': '__',
      'ms': '__',
    },
  },
  // chat
  {
    'jjas7pzm': {
      'en': 'Status',
      'id': '',
      'ms': '',
    },
    't8qpzfof': {
      'en': 'Quicky Tasks',
      'id': 'Aktivitas Kontrak',
      'ms': 'Aktiviti Kontrak',
    },
    'e2sav9he': {
      'en': 'All information about the \nQuicky Tasks app.',
      'id': 'Di bawah ini adalah ringkasan kegiatan.',
      'ms': 'Di bawah ialah ringkasan aktiviti.',
    },
    'mcngz0wq': {
      'en': 'Status',
      'id': '',
      'ms': '',
    },
    'mjk0ze03': {
      'en': 'Off',
      'id': '',
      'ms': '',
    },
    '7deh74it': {
      'en': 'Quicky Essencials',
      'id': 'Aktivitas Kontrak',
      'ms': 'Aktiviti Kontrak',
    },
    'vksqpjxy': {
      'en': 'All information about the \nQuicky Essencials app.',
      'id': 'Di bawah ini adalah ringkasan kegiatan.',
      'ms': 'Di bawah ialah ringkasan aktiviti.',
    },
    'i4bi1g8k': {
      'en': 'Can you place the order again for me?',
      'id': '',
      'ms': '',
    },
    'ou4032jr': {
      'en': 'Type here...',
      'id': '',
      'ms': '',
    },
    'do7aw0cl': {
      'en': 'Dashboard',
      'id': 'Dasbor',
      'ms': 'Papan pemuka',
    },
    'ex4zkqo8': {
      'en': '__',
      'id': '__',
      'ms': '__',
    },
  },
  // supportB2BCopy
  {
    'c2tlkdrz': {
      'en': 'Support',
      'id': 'Dasbor',
      'ms': 'Papan pemuka',
    },
    'jcovmy9o': {
      'en': 'Type here...',
      'id': '',
      'ms': '',
    },
    '94xbh5f7': {
      'en': 'Dashboard',
      'id': 'Dasbor',
      'ms': 'Papan pemuka',
    },
    'jv6tfv8z': {
      'en': '__',
      'id': '__',
      'ms': '__',
    },
  },
  // initialPage
  {
    'y0bpjfue': {
      'en': 'OOPS! You do not have permission to access our dashboard.',
      'id': '',
      'ms': '',
    },
    'rkpd38ij': {
      'en': 'OOPS! You do not have permission to access our dashboard.',
      'id': '',
      'ms': '',
    },
    'h7gpxpn9': {
      'en': 'Home',
      'id': '',
      'ms': '',
    },
  },
  // webNav
  {
    'c4mf6ca1': {
      'en': 'Quicky \nDashboard',
      'id': '',
      'ms': '',
    },
    'yg07zi4c': {
      'en': 'Home',
      'id': 'Dasbor',
      'ms': 'Papan pemuka',
    },
    '01nu9cy0': {
      'en': 'Quicky Tasks',
      'id': 'Profil',
      'ms': 'Profil',
    },
    'lbojdpxg': {
      'en': 'Users',
      'id': 'Pelanggan',
      'ms': 'Pelanggan',
    },
    '9pjba90p': {
      'en': 'Support Ticket',
      'id': 'Kontrak',
      'ms': 'Kontrak',
    },
    '7l8q3gsx': {
      'en': 'Status',
      'id': 'Profil',
      'ms': 'Profil',
    },
  },
  // allusers
  {
    '84x8wjj5': {
      'en': 'All Users',
      'id': '',
      'ms': '',
    },
    '2hb5ubxe': {
      'en': 'Marketing • Offline',
      'id': '',
      'ms': '',
    },
    'mowfdto6': {
      'en': 'Carla Ferreira',
      'id': '',
      'ms': '',
    },
    'ibgcxvg6': {
      'en': 'Marketing • Offline',
      'id': '',
      'ms': '',
    },
  },
  // updateTaskStatus
  {
    '021k6och': {
      'en': 'Task Status',
      'id': '',
      'ms': '',
    },
    'zaqnbmcq': {
      'en': 'Update the current status',
      'id': '',
      'ms': '',
    },
    'fnlptghd': {
      'en': 'notPaid',
      'id': '',
      'ms': '',
    },
    'h6s1lfg4': {
      'en': 'waiting',
      'id': '',
      'ms': '',
    },
    'cq1p32c9': {
      'en': 'approved',
      'id': '',
      'ms': '',
    },
    'zvg5gn6r': {
      'en': 'canceled',
      'id': '',
      'ms': '',
    },
    'pw11zkwm': {
      'en': 'completed',
      'id': '',
      'ms': '',
    },
    'bcli0oop': {
      'en': 'evalueted',
      'id': '',
      'ms': '',
    },
    'g0jkfoj9': {
      'en': 'Cancel',
      'id': '',
      'ms': '',
    },
    'v4q2q5of': {
      'en': 'Update Status',
      'id': '',
      'ms': '',
    },
  },
  // AllUsersApp
  {
    'k52t2lmj': {
      'en': 'All Users',
      'id': '',
      'ms': '',
    },
    'irthhj3i': {
      'en': 'Search for your customers...',
      'id': '',
      'ms': '',
    },
    'imffuz2g': {
      'en': 'Member Name',
      'id': '',
      'ms': '',
    },
    'oqk62jje': {
      'en': 'Email',
      'id': '',
      'ms': '',
    },
    '8nozyf45': {
      'en': 'Saldo',
      'id': '',
      'ms': '',
    },
    'i3jm40wg': {
      'en': 'Date Created',
      'id': '',
      'ms': '',
    },
    'ewjzrtax': {
      'en': 'Status',
      'id': '',
      'ms': '',
    },
    'x8kppqfk': {
      'en': 'user@domainname.com',
      'id': '',
      'ms': '',
    },
    'dy1sbb47': {
      'en': 'Status',
      'id': '',
      'ms': '',
    },
    'eyq16sut': {
      'en': 'Andrea Rudolph',
      'id': '',
      'ms': '',
    },
    'us10ybgd': {
      'en': 'user@domainname.com',
      'id': '',
      'ms': '',
    },
    'e9h0scx9': {
      'en': 'user@domain.com',
      'id': '',
      'ms': '',
    },
    'sj56ckhd': {
      'en': 'Status',
      'id': '',
      'ms': '',
    },
    'j3hmx969': {
      'en': 'Andrea Rudolph',
      'id': '',
      'ms': '',
    },
    'dezk8bua': {
      'en': 'user@domainname.com',
      'id': '',
      'ms': '',
    },
    'gyq0b2vk': {
      'en': 'user@domain.com',
      'id': '',
      'ms': '',
    },
    'm92w2rsc': {
      'en': 'Status',
      'id': '',
      'ms': '',
    },
    'neyhspes': {
      'en': 'Andrea Rudolph',
      'id': '',
      'ms': '',
    },
    'mtzwdxcv': {
      'en': 'user@domainname.com',
      'id': '',
      'ms': '',
    },
    'dx5ngf4x': {
      'en': 'user@domain.com',
      'id': '',
      'ms': '',
    },
    '9vjtscat': {
      'en': 'Status',
      'id': '',
      'ms': '',
    },
    'k1esbc8v': {
      'en': 'Andrea Rudolph',
      'id': '',
      'ms': '',
    },
    'fi7v11k1': {
      'en': 'user@domainname.com',
      'id': '',
      'ms': '',
    },
    'rk82oav0': {
      'en': 'user@domain.com',
      'id': '',
      'ms': '',
    },
    'mi9eby6m': {
      'en': 'Status',
      'id': '',
      'ms': '',
    },
    'g095q1ji': {
      'en': 'Andrea Rudolph',
      'id': '',
      'ms': '',
    },
    'yp1myc1r': {
      'en': 'user@domainname.com',
      'id': '',
      'ms': '',
    },
    'yu32h567': {
      'en': 'user@domain.com',
      'id': '',
      'ms': '',
    },
    '8q3u21sv': {
      'en': 'Status',
      'id': '',
      'ms': '',
    },
  },
  // darkmode
  {
    '04djvng6': {
      'en': 'Light Mode',
      'id': '',
      'ms': '',
    },
    'egophm6x': {
      'en': 'Dark Mode',
      'id': '',
      'ms': '',
    },
  },
  // bar
  {
    '07hptcqd': {
      'en': 'Quicky\nDashboard',
      'id': '',
      'ms': '',
    },
  },
  // editSteps
  {
    'oivm7t0c': {
      'en': 'Edit Step',
      'id': '',
      'ms': '',
    },
    '365vksse': {
      'en': 'Update the step',
      'id': '',
      'ms': '',
    },
    '1tctta58': {
      'en': 'Cancel',
      'id': '',
      'ms': '',
    },
    'klow174s': {
      'en': 'Update Step',
      'id': '',
      'ms': '',
    },
  },
  // editStepsCopy
  {
    'maotlcy2': {
      'en': 'Edit Materials',
      'id': '',
      'ms': '',
    },
    '3gzn7bau': {
      'en': 'Update this materials',
      'id': '',
      'ms': '',
    },
    'rfbwu2tq': {
      'en': 'Cancel',
      'id': '',
      'ms': '',
    },
    'b6hppci9': {
      'en': 'Update Materials',
      'id': '',
      'ms': '',
    },
  },
  // editStepsCopyCopy
  {
    'if4d2ea1': {
      'en': 'Edit Materials Value',
      'id': '',
      'ms': '',
    },
    'at3b9qmo': {
      'en': 'Update this materials',
      'id': '',
      'ms': '',
    },
    '0ehpjd24': {
      'en': 'Cancel',
      'id': '',
      'ms': '',
    },
    '512z2l0e': {
      'en': 'Update Materials',
      'id': '',
      'ms': '',
    },
  },
  // createEvent
  {
    'exxyn7st': {
      'en': 'Create New Event',
      'id': '',
      'ms': '',
    },
    'mi4jj641': {
      'en':
          'Upload images about your company and fill out the information below.',
      'id': '',
      'ms': '',
    },
    '5gd8m7np': {
      'en': 'Event description',
      'id': '',
      'ms': '',
    },
    'akctu7jx': {
      'en': 'Location complement (SmartFit, Starbucks)',
      'id': '',
      'ms': '',
    },
    '7kdyyi1o': {
      'en': '',
      'id': '',
      'ms': '',
    },
    'c964lvq2': {
      'en': 'Maximum people',
      'id': '',
      'ms': '',
    },
    '1hk3fgvg': {
      'en': 'Select Location',
      'id': '',
      'ms': '',
    },
    'aghzh3uy': {
      'en': 'Select instructor...',
      'id': '',
      'ms': '',
    },
    '4er0xh82': {
      'en': 'Search...',
      'id': '',
      'ms': '',
    },
    'dq4emxcg': {
      'en': 'Option 1',
      'id': '',
      'ms': '',
    },
    's7ujqwi8': {
      'en': 'Option 2',
      'id': '',
      'ms': '',
    },
    'dhhsrvv7': {
      'en': 'Option 3',
      'id': '',
      'ms': '',
    },
    'qj9wxpt3': {
      'en': 'Add kit',
      'id': '',
      'ms': '',
    },
    'wiit5hu7': {
      'en': 'Buy kit in advance',
      'id': '',
      'ms': '',
    },
    '0e1c5678': {
      'en': 'Cancel',
      'id': '',
      'ms': '',
    },
    'v06nbqj1': {
      'en': 'Create new event',
      'id': '',
      'ms': '',
    },
  },
  // editStepsCopy2
  {
    '5pk9dtib': {
      'en': 'New Kit',
      'id': '',
      'ms': '',
    },
    'z7z4pysw': {
      'en': 'New kit for events',
      'id': '',
      'ms': '',
    },
    'sqvdxn5q': {
      'en': 'Description',
      'id': '',
      'ms': '',
    },
    'hgs69hxf': {
      'en': 'Price',
      'id': '',
      'ms': '',
    },
    '2chz7mgx': {
      'en': 'Cancel',
      'id': '',
      'ms': '',
    },
    'qi8dgbxl': {
      'en': 'Create Kit',
      'id': '',
      'ms': '',
    },
  },
  // createEventCopy
  {
    'ypgwdekn': {
      'en': 'Espaço para localizacao',
      'id': '',
      'ms': '',
    },
    'eea2g97q': {
      'en': 'Edit Kit',
      'id': '',
      'ms': '',
    },
  },
  // usersProfiles
  {
    'bn5z31wj': {
      'en': 'User ID',
      'id': '',
      'ms': '',
    },
    '71k29z99': {
      'en': 'Currently Being',
      'id': '',
      'ms': '',
    },
    'g5l6voxr': {
      'en': 'Created In',
      'id': '',
      'ms': '',
    },
    'hs4tdx0y': {
      'en': 'Last Login',
      'id': '',
      'ms': '',
    },
    'hpsiqvyc': {
      'en': 'Today, 9:15 AM',
      'id': '',
      'ms': '',
    },
    '7s6pph8w': {
      'en': 'Edit Permissions',
      'id': '',
      'ms': '',
    },
    'kstvksc8': {
      'en': 'View Activity Log',
      'id': '',
      'ms': '',
    },
    '8ql0jefe': {
      'en': 'Reset Password',
      'id': '',
      'ms': '',
    },
    'no2n5e2k': {
      'en': 'Delete User Account',
      'id': '',
      'ms': '',
    },
  },
  // createEventCopyCopy
  {
    'hkvh0jl9': {
      'en': 'Taskee',
      'id': '',
      'ms': '',
    },
    'iljirf7m': {
      'en': 'Tasker',
      'id': '',
      'ms': '',
    },
  },
  // webNavCopy
  {
    '4a2bwqsu': {
      'en': 'Quicky B2B',
      'id': '',
      'ms': '',
    },
    'z4nj9zq1': {
      'en': 'Home',
      'id': 'Dasbor',
      'ms': 'Papan pemuka',
    },
    'xidog5x1': {
      'en': 'All Tasks Perform',
      'id': 'Dasbor',
      'ms': 'Papan pemuka',
    },
    '18m8v1vu': {
      'en': 'Chats',
      'id': 'Dasbor',
      'ms': 'Papan pemuka',
    },
    'bxhmhbq6': {
      'en': 'Support',
      'id': 'Dasbor',
      'ms': 'Papan pemuka',
    },
    'qqp1y2o9': {
      'en': 'Users',
      'id': 'Pelanggan',
      'ms': 'Pelanggan',
    },
    'gdhajca9': {
      'en': 'Support Ticket',
      'id': 'Kontrak',
      'ms': 'Kontrak',
    },
    'a8ccp7ac': {
      'en': 'Status',
      'id': 'Profil',
      'ms': 'Profil',
    },
  },
  // applyperformtask
  {
    'sn1jz627': {
      'en': 'Apply to perform the task',
      'id': '',
      'ms': '',
    },
    '8fq8hy1f': {
      'en': 'The taskee has to accept you first.',
      'id': '',
      'ms': '',
    },
    'umycwqt4': {
      'en': 'Cancel',
      'id': '',
      'ms': '',
    },
    '8yv8vp8u': {
      'en': 'Apply',
      'id': '',
      'ms': '',
    },
  },
  // createEventCopyCopyCopy
  {
    '6l7pp7kp': {
      'en': 'Taskee',
      'id': '',
      'ms': '',
    },
    'c0nb60d5': {
      'en': 'Tasker',
      'id': '',
      'ms': '',
    },
  },
  // realizandoatask
  {
    '3nrebyuj': {
      'en': '#',
      'id': '',
      'ms': '',
    },
    'mjiidu2k': {
      'en': '#',
      'id': '',
      'ms': '',
    },
    'fz513ggl': {
      'en': '2',
      'id': '',
      'ms': '',
    },
    '2jm3sdia': {
      'en': 'WASH',
      'id': '',
      'ms': '',
    },
    '0k1vkqqi': {
      'en':
          'my clothesare in my liquidy basket underline brazil who you for things',
      'id': '',
      'ms': '',
    },
    'i288mk7l': {
      'en': '#',
      'id': '',
      'ms': '',
    },
    '529615q5': {
      'en': '3',
      'id': '',
      'ms': '',
    },
    'asyu4wsi': {
      'en': 'DRY & MOVE',
      'id': '',
      'ms': '',
    },
    'gx38gal6': {
      'en':
          'my clothesare in my liquidy basket underline brazil who you for things',
      'id': '',
      'ms': '',
    },
    '3uz6tf9j': {
      'en': 'FINISH TASK',
      'id': '',
      'ms': '',
    },
  },
  // aboutTheApp
  {
    '0dl6ao38': {
      'en': 'About the App',
      'id': '',
      'ms': '',
    },
    '3is5dmr7': {
      'en':
          'This is a Quicky Solutions® application, all rights reserved. If you have any questions, please contact us.',
      'id': '',
      'ms': '',
    },
    '23a67tz5': {
      'en': 'Developed by',
      'id': '',
      'ms': '',
    },
    '3wtlbtoe': {
      'en': 'Nagazaki Software',
      'id': '',
      'ms': '',
    },
    'ty8njzvd': {
      'en': 'Version',
      'id': '',
      'ms': '',
    },
    'rs9k4fgt': {
      'en': 'Logout',
      'id': '',
      'ms': '',
    },
  },
  // createSupportTicket
  {
    't9yuvjhk': {
      'en': 'Create Ticket Support',
      'id': '',
      'ms': '',
    },
    '0bfshj6l': {
      'en': 'Need help?',
      'id': '',
      'ms': '',
    },
    's7re3n3n': {
      'en': 'Title',
      'id': '',
      'ms': '',
    },
    'hxocaq91': {
      'en': 'Description',
      'id': '',
      'ms': '',
    },
    'fta67sa4': {
      'en': 'Select the category of your support ticket',
      'id': '',
      'ms': '',
    },
    'ux32snnr': {
      'en': 'Search...',
      'id': '',
      'ms': '',
    },
    'hwde6c4e': {
      'en': 'Account and Profile',
      'id': '',
      'ms': '',
    },
    '5lumrgic': {
      'en': 'Quicky Events & Quicky Tasks',
      'id': '',
      'ms': '',
    },
    '3vok1kll': {
      'en': 'Payments & Transfers',
      'id': '',
      'ms': '',
    },
    'tchaslvz': {
      'en': 'Quicky B2B',
      'id': '',
      'ms': '',
    },
    '9u9936ot': {
      'en': 'Upload Photos',
      'id': '',
      'ms': '',
    },
    'qeifr7fz': {
      'en': 'Cancel',
      'id': '',
      'ms': '',
    },
    '48yhulko': {
      'en': 'Create Ticket',
      'id': '',
      'ms': '',
    },
  },
  // PaginaInicialRideAdm
  {
    'a5x2v6j1': {
      'en': 'Dark Theme',
      'id': '',
      'ms': '',
    },
    'v8rhnlru': {
      'en': ' Quick Stats',
      'id': '',
      'ms': '',
    },
    '9jydh548': {
      'en': 'Churn',
      'id': '',
      'ms': '',
    },
    '0s2j5tqw': {
      'en': '345',
      'id': '',
      'ms': '',
    },
    'pv6g5nio': {
      'en': '+ 15%',
      'id': '',
      'ms': '',
    },
    'z87flfl5': {
      'en': '',
      'id': '',
      'ms': '',
    },
    'qcijwf36': {
      'en': ' ARPD',
      'id': '',
      'ms': '',
    },
    'on636i6r': {
      'en': '345',
      'id': '',
      'ms': '',
    },
    'jykc5hjb': {
      'en': '+ 15%',
      'id': '',
      'ms': '',
    },
    '8fepc4ct': {
      'en': '',
      'id': '',
      'ms': '',
    },
    '9itofoxy': {
      'en': ' Returning User %',
      'id': '',
      'ms': '',
    },
    '9tmdf9rr': {
      'en': '25,4 %',
      'id': '',
      'ms': '',
    },
    'r612tcb5': {
      'en': '+ 3%',
      'id': '',
      'ms': '',
    },
    'vuiprivn': {
      'en': '',
      'id': '',
      'ms': '',
    },
    '6ep2nwpc': {
      'en': ' AVG time on the APP Rider',
      'id': '',
      'ms': '',
    },
    'fr9zgkcr': {
      'en': '+ 15%',
      'id': '',
      'ms': '',
    },
  },
  // allUser
  {
    'mhelinlk': {
      'en': 'Dark Theme',
      'id': '',
      'ms': '',
    },
    'q6b866pt': {
      'en': ' Riders',
      'id': '',
      'ms': '',
    },
    'antir779': {
      'en': ' Local Driver',
      'id': '',
      'ms': '',
    },
    '8m7l1z5q': {
      'en': 'Taxi Driver',
      'id': '',
      'ms': '',
    },
  },
  // mapRealTime
  {
    'nn9aov30': {
      'en': 'Dark Theme',
      'id': '',
      'ms': '',
    },
  },
  // componetDrivers1
  {
    'eynm1vvw': {
      'en': ' Enzo Godoy',
      'id': '',
      'ms': '',
    },
    'z21ndadk': {
      'en': ' Rider Rating: ',
      'id': '',
      'ms': '',
    },
    'rkyuohbh': {
      'en': ' Where From:',
      'id': '',
      'ms': '',
    },
    'evxyccjp': {
      'en': 'United States, Florida',
      'id': '',
      'ms': '',
    },
    'ge061kd4': {
      'en': ' #of Rides:',
      'id': '',
      'ms': '',
    },
    't0zkvo0z': {
      'en': '30',
      'id': '',
      'ms': '',
    },
    'dxw91q3l': {
      'en': 'Passport # :',
      'id': '',
      'ms': '',
    },
    't12wmiuq': {
      'en': 'GB882306',
      'id': '',
      'ms': '',
    },
    'e4s8fkpn': {
      'en': ' Age:',
      'id': '',
      'ms': '',
    },
    'qjr7ihmi': {
      'en': ' 19',
      'id': '',
      'ms': '',
    },
    'zb5ht0qy': {
      'en': 'Gender : ',
      'id': '',
      'ms': '',
    },
    'dufazppp': {
      'en': 'Female',
      'id': '',
      'ms': '',
    },
    '4ejbube3': {
      'en': 'Text Sam',
      'id': '',
      'ms': '',
    },
    'um7ek1fw': {
      'en': 'Call Sam',
      'id': '',
      'ms': '',
    },
  },
  // componetDrivers2
  {
    '69818jza': {
      'en': ' Enzo Godoy',
      'id': '',
      'ms': '',
    },
    'z97bpngi': {
      'en': '-',
      'id': '',
      'ms': '',
    },
    'ji03ypv2': {
      'en': ' Taxi Driver',
      'id': '',
      'ms': '',
    },
    '3u6b75c2': {
      'en': ' Driver Rating:',
      'id': '',
      'ms': '',
    },
    '4ul6hzjl': {
      'en': 'Car Driving: ',
      'id': '',
      'ms': '',
    },
    'ixraai2y': {
      'en': 'Nissan Serena',
      'id': '',
      'ms': '',
    },
    '0wx7dora': {
      'en': ' Rides this month:',
      'id': '',
      'ms': '',
    },
    'xdkxus3g': {
      'en': '132',
      'id': '',
      'ms': '',
    },
    'w0ekygif': {
      'en': 'Total:',
      'id': '',
      'ms': '',
    },
    'e0ubhik8': {
      'en': '400',
      'id': '',
      'ms': '',
    },
    '41orlap6': {
      'en': ' Status:',
      'id': '',
      'ms': '',
    },
    'gipkgxmz': {
      'en': ' Avaiable',
      'id': '',
      'ms': '',
    },
    '4aqr3v1x': {
      'en': 'Text Sam',
      'id': '',
      'ms': '',
    },
    'st4eibgf': {
      'en': 'Call Sam',
      'id': '',
      'ms': '',
    },
  },
  // componetUser1
  {
    '0gx3z6pw': {
      'en': 'Giulia Baeder',
      'id': '',
      'ms': '',
    },
    'jad1oqu4': {
      'en': '-',
      'id': '',
      'ms': '',
    },
    'qv37purc': {
      'en': 'Not in a Ride',
      'id': '',
      'ms': '',
    },
    '0a5zpy68': {
      'en': ' Information:',
      'id': '',
      'ms': '',
    },
    '4i4r3s9s': {
      'en': ' CALL 911 or 919',
      'id': '',
      'ms': '',
    },
    'p8uhjics': {
      'en': 'Passport # :',
      'id': '',
      'ms': '',
    },
    'wk3nfyou': {
      'en': 'GB882306',
      'id': '',
      'ms': '',
    },
    'ocdohxuy': {
      'en': 'Call Driver',
      'id': '',
      'ms': '',
    },
    'nlodogy8': {
      'en': 'Ask free Drivers for help',
      'id': '',
      'ms': '',
    },
    'iudfaskv': {
      'en': 'User Location',
      'id': '',
      'ms': '',
    },
    'f5wwta4i': {
      'en': ' Gender:',
      'id': '',
      'ms': '',
    },
    '0lfeoyzb': {
      'en': 'Female',
      'id': '',
      'ms': '',
    },
    '694iu0u1': {
      'en': ' From:',
      'id': '',
      'ms': '',
    },
    'sqighnnc': {
      'en': 'United states, Florida',
      'id': '',
      'ms': '',
    },
    'zd1r9zsz': {
      'en': 'Ethinicity: ',
      'id': '',
      'ms': '',
    },
    's8vearh3': {
      'en': 'white',
      'id': '',
      'ms': '',
    },
    'sy2yfpc2': {
      'en': 'Emergency contact:',
      'id': '',
      'ms': '',
    },
    'b7q65p5d': {
      'en': 'Mari',
      'id': '',
      'ms': '',
    },
    'ics2zq8i': {
      'en': '[Mom]:',
      'id': '',
      'ms': '',
    },
    '36yiml26': {
      'en': '(305) 850-0987',
      'id': '',
      'ms': '',
    },
  },
  // componetUser2
  {
    '68ig6zgz': {
      'en': 'Giulia Baeder',
      'id': '',
      'ms': '',
    },
    'h4h3g8a3': {
      'en': '-',
      'id': '',
      'ms': '',
    },
    '17eo499y': {
      'en': 'Not in a Ride',
      'id': '',
      'ms': '',
    },
    'zo1g51yr': {
      'en': ' Going to Bahamar',
      'id': '',
      'ms': '',
    },
    'vkgawlwa': {
      'en': 'Rider ',
      'id': '',
      'ms': '',
    },
    '9hlau4l8': {
      'en':
          'Requested Help: Please he has \na gun!! And we are not going the \ndirection of ther maps....cannot talk.',
      'id': '',
      'ms': '',
    },
    'qj2zomuk': {
      'en': ' CALL 911 or 919',
      'id': '',
      'ms': '',
    },
    'sdbql0yr': {
      'en': 'Car Plate',
      'id': '',
      'ms': '',
    },
    '71s5rk9r': {
      'en': '#EAD199',
      'id': '',
      'ms': '',
    },
    'pu5gy8j9': {
      'en': 'Call Driver',
      'id': '',
      'ms': '',
    },
    '3yonmhhe': {
      'en': 'Ask free Drivers for help',
      'id': '',
      'ms': '',
    },
    'r3qb7rzz': {
      'en': 'User Location',
      'id': '',
      'ms': '',
    },
  },
  // componetDriversRLT1
  {
    '5d0bz93p': {
      'en': ' Enzo Godoy',
      'id': '',
      'ms': '',
    },
    'vixkqah7': {
      'en': ' Rider Rating: ',
      'id': '',
      'ms': '',
    },
    '66srz9mv': {
      'en': ' Where From:',
      'id': '',
      'ms': '',
    },
    '802nhe5b': {
      'en': 'United States, Florida',
      'id': '',
      'ms': '',
    },
    'g5tflx3l': {
      'en': ' #of Rides:',
      'id': '',
      'ms': '',
    },
    '2s8fs0iw': {
      'en': '30',
      'id': '',
      'ms': '',
    },
    '3t3owdz0': {
      'en': 'Passport # :',
      'id': '',
      'ms': '',
    },
    'r09o3k17': {
      'en': 'GB882306',
      'id': '',
      'ms': '',
    },
    'nrkt7lay': {
      'en': ' Age:',
      'id': '',
      'ms': '',
    },
    'cbpcpnbj': {
      'en': ' 19',
      'id': '',
      'ms': '',
    },
    'mghh0gxg': {
      'en': 'Gender : ',
      'id': '',
      'ms': '',
    },
    'av39oq1y': {
      'en': 'Female',
      'id': '',
      'ms': '',
    },
    'hyn9cby5': {
      'en': ' Ban User',
      'id': '',
      'ms': '',
    },
    '98iydq5s': {
      'en': ' Write Reason',
      'id': '',
      'ms': '',
    },
  },
  // componetDriversRLT2
  {
    '2c70rsk6': {
      'en': 'Sam Miller',
      'id': '',
      'ms': '',
    },
    'nnytsmy0': {
      'en': '-',
      'id': '',
      'ms': '',
    },
    'arms5o7i': {
      'en': ' Taxi Driver',
      'id': '',
      'ms': '',
    },
    'omay0vhj': {
      'en': ' Driver Rating:',
      'id': '',
      'ms': '',
    },
    'fa2pkq9z': {
      'en': 'Car Driving: ',
      'id': '',
      'ms': '',
    },
    'bhd44elz': {
      'en': 'Nissan Serena',
      'id': '',
      'ms': '',
    },
    'wn7yehpf': {
      'en': ' Status:',
      'id': '',
      'ms': '',
    },
    '6dc60wn1': {
      'en': ' All up to date!',
      'id': '',
      'ms': '',
    },
    'xj80clvw': {
      'en': ' Rides this month:',
      'id': '',
      'ms': '',
    },
    '40vnyg9t': {
      'en': '132',
      'id': '',
      'ms': '',
    },
    'kx69s5qk': {
      'en': 'Total:',
      'id': '',
      'ms': '',
    },
    '1q34yq6a': {
      'en': '400',
      'id': '',
      'ms': '',
    },
    'voj3diqm': {
      'en': ' Ban User',
      'id': '',
      'ms': '',
    },
    'jb7yu6yg': {
      'en': 'Write Reason',
      'id': '',
      'ms': '',
    },
  },
  // navbarRide
  {
    't2xibam7': {
      'en': ' Dashboard Snapshot',
      'id': '',
      'ms': '',
    },
    '2ef7wm77': {
      'en': 'All Users',
      'id': '',
      'ms': '',
    },
    'btaxyfnz': {
      'en': 'Map Real Time',
      'id': '',
      'ms': '',
    },
  },
  // expenses
  {
    'yyfxotwz': {
      'en': 'Search',
      'id': '',
      'ms': '',
    },
    'qpx055bd': {
      'en': 'Dashboard',
      'id': '',
      'ms': '',
    },
    '6rqkw8ej': {
      'en': 'Expense',
      'id': '',
      'ms': '',
    },
    '3v9zlcym': {
      'en': 'Dark',
      'id': '',
      'ms': '',
    },
    'w8ld1sy8': {
      'en': 'User',
      'id': '',
      'ms': '',
    },
    'og8fso4g': {
      'en': 'Payroll - Employees',
      'id': '',
      'ms': '',
    },
    'qkl62nmj': {
      'en': 'Name',
      'id': '',
      'ms': '',
    },
    'tzoamn8l': {
      'en': 'Occupation',
      'id': '',
      'ms': '',
    },
    'qxi13ikg': {
      'en': 'Departmanet',
      'id': '',
      'ms': '',
    },
    'z4va72h3': {
      'en': 'Edit Column 1',
      'id': '',
      'ms': '',
    },
    'y8jq265x': {
      'en': 'Edit Column 2',
      'id': '',
      'ms': '',
    },
    'l6fvifhk': {
      'en': 'Edit Column 3',
      'id': '',
      'ms': '',
    },
    '76b2dg8i': {
      'en': 'Monthly Pay',
      'id': '',
      'ms': '',
    },
    'zyjez492': {
      'en': 'Edit Column 4',
      'id': '',
      'ms': '',
    },
    '8ievlnxn': {
      'en': 'Status',
      'id': '',
      'ms': '',
    },
    'd1tf6czg': {
      'en': 'Edit Column 5',
      'id': '',
      'ms': '',
    },
    '76ukvhtv': {
      'en': 'Next Pay',
      'id': '',
      'ms': '',
    },
    '26v4s5wh': {
      'en': 'Edit Column 6',
      'id': '',
      'ms': '',
    },
    'rcqr7fo1': {
      'en': 'Add Employee',
      'id': '',
      'ms': '',
    },
    '4ynsxx4c': {
      'en': 'Recept Expenses',
      'id': '',
      'ms': '',
    },
    '3jdoo3xv': {
      'en': 'Name',
      'id': '',
      'ms': '',
    },
    'owscndf8': {
      'en': 'Category',
      'id': '',
      'ms': '',
    },
    '98necxt2': {
      'en': 'Amount',
      'id': '',
      'ms': '',
    },
    'adepokt8': {
      'en': 'Edit Column 1',
      'id': '',
      'ms': '',
    },
    'nn7z4b89': {
      'en': 'Edit Column 2',
      'id': '',
      'ms': '',
    },
    'g0yxurqm': {
      'en': 'Edit Column 3',
      'id': '',
      'ms': '',
    },
    'bpw9uah0': {
      'en': 'Date',
      'id': '',
      'ms': '',
    },
    '4qtmaxts': {
      'en': 'Edit Column 4',
      'id': '',
      'ms': '',
    },
    '77kxdru9': {
      'en': 'Type',
      'id': '',
      'ms': '',
    },
    'epflnyrp': {
      'en': 'Edit Column 5',
      'id': '',
      'ms': '',
    },
    '8mh49prw': {
      'en': 'Status',
      'id': '',
      'ms': '',
    },
    'gxusckmu': {
      'en': 'Edit Column 6',
      'id': '',
      'ms': '',
    },
    'mz77e7t9': {
      'en': 'New Expense',
      'id': '',
      'ms': '',
    },
    'fw8wov0p': {
      'en': 'Name',
      'id': '',
      'ms': '',
    },
    'tity0o2c': {
      'en': 'Category',
      'id': '',
      'ms': '',
    },
    'ovuwpwjx': {
      'en': 'Amount',
      'id': '',
      'ms': '',
    },
    's5m6tdik': {
      'en': 'Date',
      'id': '',
      'ms': '',
    },
    'rp4zofym': {
      'en': 'Notes',
      'id': '',
      'ms': '',
    },
    'umgaifjw': {
      'en': 'Type',
      'id': '',
      'ms': '',
    },
    'rgr0xt9u': {
      'en': 'Frequency',
      'id': '',
      'ms': '',
    },
    'ijva39rv': {
      'en': 'Starts On',
      'id': '',
      'ms': '',
    },
    'lk8umd58': {
      'en': 'Ends On',
      'id': '',
      'ms': '',
    },
    '76vnf9j6': {
      'en': 'Mark as:',
      'id': '',
      'ms': '',
    },
    'd28uwyz7': {
      'en': 'One-time',
      'id': '',
      'ms': '',
    },
    'x8coy3cr': {
      'en': 'Recurring',
      'id': '',
      'ms': '',
    },
    'b150bl1m': {
      'en': 'Tip: Driver payouts are added automatically each day.',
      'id': '',
      'ms': '',
    },
    '44obqogm': {
      'en': 'Save Expense',
      'id': '',
      'ms': '',
    },
    'uxj50sgd': {
      'en': 'Cancel',
      'id': '',
      'ms': '',
    },
  },
  // allExpenses
  {
    'vezhpopp': {
      'en': 'Search',
      'id': '',
      'ms': '',
    },
    '2yjrt0o3': {
      'en': 'Dashboard',
      'id': '',
      'ms': '',
    },
    'n0o1vc8b': {
      'en': 'Expense',
      'id': '',
      'ms': '',
    },
    '3x93s9jn': {
      'en': 'Dark',
      'id': '',
      'ms': '',
    },
    'dfuu93v1': {
      'en': 'User',
      'id': '',
      'ms': '',
    },
    'cna0rr1t': {
      'en': 'Total Expenses (MTD)',
      'id': '',
      'ms': '',
    },
    'blqvz31w': {
      'en': '+ 4%',
      'id': '',
      'ms': '',
    },
    'q1qrw832': {
      'en': '\$48,720',
      'id': '',
      'ms': '',
    },
    '9jr4gqsq': {
      'en': 'Automatic - Driver Payouts',
      'id': '',
      'ms': '',
    },
    'j24db18i': {
      'en': '+ 5%',
      'id': '',
      'ms': '',
    },
    'kga74t6f': {
      'en': '\$18,990',
      'id': '',
      'ms': '',
    },
    'ruw28vwh': {
      'en': 'Payroll - Employees',
      'id': '',
      'ms': '',
    },
    '01v4420t': {
      'en': '+ 2%',
      'id': '',
      'ms': '',
    },
    '9v5gj37g': {
      'en': '\$22,400',
      'id': '',
      'ms': '',
    },
    'smw83oia': {
      'en': 'Other Expenses',
      'id': '',
      'ms': '',
    },
    'pp1l9xrp': {
      'en': '+ 1%',
      'id': '',
      'ms': '',
    },
    'cn0trkzu': {
      'en': '\$7,330',
      'id': '',
      'ms': '',
    },
    'w37suoxz': {
      'en': 'Recurring Expenses',
      'id': '',
      'ms': '',
    },
    'lufocjoq': {
      'en': 'Name',
      'id': '',
      'ms': '',
    },
    '2qd4cti5': {
      'en': 'Category',
      'id': '',
      'ms': '',
    },
    'zfg7emnt': {
      'en': 'Amount',
      'id': '',
      'ms': '',
    },
    't6kpfx9b': {
      'en': 'Edit Column 1',
      'id': '',
      'ms': '',
    },
    'sacljans': {
      'en': 'Edit Column 2',
      'id': '',
      'ms': '',
    },
    'hxfh5v4n': {
      'en': 'Edit Column 3',
      'id': '',
      'ms': '',
    },
    'pgq7c28j': {
      'en': 'Frequency',
      'id': '',
      'ms': '',
    },
    'xib6wybn': {
      'en': 'Edit Column 4',
      'id': '',
      'ms': '',
    },
    '5kiouy64': {
      'en': 'Next Charge',
      'id': '',
      'ms': '',
    },
    'inva11i4': {
      'en': 'Edit Column 5',
      'id': '',
      'ms': '',
    },
    '6cwioa8l': {
      'en': 'Status',
      'id': '',
      'ms': '',
    },
    'slv4gpcx': {
      'en': 'Edit Column 6',
      'id': '',
      'ms': '',
    },
    '0nn0nig0': {
      'en': 'One-time and Unplanned',
      'id': '',
      'ms': '',
    },
    'z6rdx3v5': {
      'en': 'Name',
      'id': '',
      'ms': '',
    },
    'gm26vm34': {
      'en': 'Occupation',
      'id': '',
      'ms': '',
    },
    'j5nycgzg': {
      'en': 'Departmanet',
      'id': '',
      'ms': '',
    },
    'z7dj17ea': {
      'en': 'Edit Column 1',
      'id': '',
      'ms': '',
    },
    '7q61bn6k': {
      'en': 'Edit Column 2',
      'id': '',
      'ms': '',
    },
    '2yvwh9u5': {
      'en': 'Edit Column 3',
      'id': '',
      'ms': '',
    },
    '96vqv2v3': {
      'en': 'Monthly Pay',
      'id': '',
      'ms': '',
    },
    '2yyaomhk': {
      'en': 'Edit Column 4',
      'id': '',
      'ms': '',
    },
    'a0bhgex4': {
      'en': 'Status',
      'id': '',
      'ms': '',
    },
    'motlhk1w': {
      'en': 'Edit Column 5',
      'id': '',
      'ms': '',
    },
    'xpw71y0x': {
      'en': 'Next Pay',
      'id': '',
      'ms': '',
    },
    '74bi7nsw': {
      'en': 'Edit Column 6',
      'id': '',
      'ms': '',
    },
    's4oudqw5': {
      'en': 'Payroll - Employees',
      'id': '',
      'ms': '',
    },
    '58adlsbd': {
      'en': 'Name',
      'id': '',
      'ms': '',
    },
    'ktvdoz20': {
      'en': 'Occupation',
      'id': '',
      'ms': '',
    },
    'gk5nisx0': {
      'en': 'Departmanet',
      'id': '',
      'ms': '',
    },
    'v0g02x8f': {
      'en': 'Edit Column 1',
      'id': '',
      'ms': '',
    },
    'oom1b85n': {
      'en': 'Edit Column 2',
      'id': '',
      'ms': '',
    },
    'xicx671q': {
      'en': 'Edit Column 3',
      'id': '',
      'ms': '',
    },
    'p5etpdf0': {
      'en': 'Monthly Pay',
      'id': '',
      'ms': '',
    },
    '2aix4x3q': {
      'en': 'Edit Column 4',
      'id': '',
      'ms': '',
    },
    'flww7wrn': {
      'en': 'Status',
      'id': '',
      'ms': '',
    },
    '1ogbhrai': {
      'en': 'Edit Column 5',
      'id': '',
      'ms': '',
    },
    'pijyprmx': {
      'en': 'Next Pay',
      'id': '',
      'ms': '',
    },
    'kivzbg2g': {
      'en': 'Edit Column 6',
      'id': '',
      'ms': '',
    },
    '5urdcsx3': {
      'en': 'Add Employee',
      'id': '',
      'ms': '',
    },
    'yudbraib': {
      'en': 'Add Expense',
      'id': '',
      'ms': '',
    },
    'o579fkxe': {
      'en': 'Add Employee',
      'id': '',
      'ms': '',
    },
    'jpakvkmh': {
      'en': 'Set Recurring',
      'id': '',
      'ms': '',
    },
    'bskttxiv': {
      'en': 'Import CSV',
      'id': '',
      'ms': '',
    },
    'q93udjkt': {
      'en': 'Export CSV',
      'id': '',
      'ms': '',
    },
  },
  // allDisputes
  {
    'o8ujzfax': {
      'en': 'Search',
      'id': '',
      'ms': '',
    },
    '27p1elvx': {
      'en': 'Dashboard',
      'id': '',
      'ms': '',
    },
    'cd2g05w1': {
      'en': 'Disputes',
      'id': '',
      'ms': '',
    },
    'b03v0khr': {
      'en': 'Dark',
      'id': '',
      'ms': '',
    },
    'p6bpevhi': {
      'en': 'User',
      'id': '',
      'ms': '',
    },
    'bblhgosi': {
      'en': 'Open Disputes',
      'id': '',
      'ms': '',
    },
    'du4q86gp': {
      'en': '+ 6%',
      'id': '',
      'ms': '',
    },
    'hxm4rzyl': {
      'en': '42',
      'id': '',
      'ms': '',
    },
    '7c9xzkud': {
      'en': 'Resolved This Month',
      'id': '',
      'ms': '',
    },
    '15rt4nr7': {
      'en': '+ 3%',
      'id': '',
      'ms': '',
    },
    'v1diiy87': {
      'en': '128',
      'id': '',
      'ms': '',
    },
    'l60q1is9': {
      'en': 'Avg Resolution Time',
      'id': '',
      'ms': '',
    },
    '6i5eeoza': {
      'en': '- 3%',
      'id': '',
      'ms': '',
    },
    'dca94tf1': {
      'en': '2d 14h',
      'id': '',
      'ms': '',
    },
    'pao9181m': {
      'en': 'Refunds Inssued',
      'id': '',
      'ms': '',
    },
    'frvotc4f': {
      'en': '+ 2%',
      'id': '',
      'ms': '',
    },
    '4oj8al89': {
      'en': '\$3,200',
      'id': '',
      'ms': '',
    },
    'iqcbq1j4': {
      'en': 'Disputes',
      'id': '',
      'ms': '',
    },
    '4yrde3ki': {
      'en': 'ID',
      'id': '',
      'ms': '',
    },
    'vzwevc8d': {
      'en': 'Date',
      'id': '',
      'ms': '',
    },
    'wz5d5p9b': {
      'en': 'Rider',
      'id': '',
      'ms': '',
    },
    'pk8oawwz': {
      'en': 'Edit Column 1',
      'id': '',
      'ms': '',
    },
    'p2myn4gh': {
      'en': 'Edit Column 2',
      'id': '',
      'ms': '',
    },
    'hcol2565': {
      'en': 'Edit Column 3',
      'id': '',
      'ms': '',
    },
    'zvl1ma2k': {
      'en': 'Driver',
      'id': '',
      'ms': '',
    },
    '6734qwjc': {
      'en': 'Edit Column 4',
      'id': '',
      'ms': '',
    },
    '1e6m00be': {
      'en': 'Category',
      'id': '',
      'ms': '',
    },
    'ggntwdte': {
      'en': 'Edit Column 5',
      'id': '',
      'ms': '',
    },
    '8szyq2wp': {
      'en': 'Amount',
      'id': '',
      'ms': '',
    },
    'lzdhkezh': {
      'en': 'Edit Column 6',
      'id': '',
      'ms': '',
    },
    '7xypl46c': {
      'en': 'Status',
      'id': '',
      'ms': '',
    },
    'wodhqstz': {
      'en': 'Edit Column 7',
      'id': '',
      'ms': '',
    },
    'nrrbd22v': {
      'en': 'Actions',
      'id': '',
      'ms': '',
    },
    'df7dxd3k': {
      'en': 'Edit Column 8',
      'id': '',
      'ms': '',
    },
    'w85n8nv6': {
      'en': 'Disputes Details',
      'id': '',
      'ms': '',
    },
    'o9euly71': {
      'en': 'Rider',
      'id': '',
      'ms': '',
    },
    'wi7gx5yf': {
      'en': 'Enzo G. (4.9)',
      'id': '',
      'ms': '',
    },
    'rw3r2qam': {
      'en': 'Driver',
      'id': '',
      'ms': '',
    },
    '7dep9z5n': {
      'en': 'Sam M. (4.7)',
      'id': '',
      'ms': '',
    },
    '5dd3xf2c': {
      'en': 'Ride Info',
      'id': '',
      'ms': '',
    },
    '2qgezroe': {
      'en': 'Date: Sep 06 14:12',
      'id': '',
      'ms': '',
    },
    'p6kj3b7n': {
      'en': 'Pickup: Airport',
      'id': '',
      'ms': '',
    },
    'vvq3vffh': {
      'en': 'Dropff: Downtown',
      'id': '',
      'ms': '',
    },
    'xskbkwjf': {
      'en': 'Fare: \$12.40',
      'id': '',
      'ms': '',
    },
    '7f9omn3d': {
      'en': 'Dispute Reason',
      'id': '',
      'ms': '',
    },
    'bzc24ltk': {
      'en': 'Rider claims driver took a longer route and AC was off.',
      'id': '',
      'ms': '',
    },
    '5zjhawi6': {
      'en': 'Internal Notes',
      'id': '',
      'ms': '',
    },
    'hkj7kjf4': {
      'en': 'Type notes here...',
      'id': '',
      'ms': '',
    },
    'ovybcfqx': {
      'en': 'Resolve (no refund)',
      'id': '',
      'ms': '',
    },
    'xkctjqun': {
      'en': 'Refund ride',
      'id': '',
      'ms': '',
    },
    'mpq6yhgl': {
      'en': 'Escalate',
      'id': '',
      'ms': '',
    },
  },
  // selectDispute
  {
    'a4z8a62i': {
      'en': 'Search',
      'id': '',
      'ms': '',
    },
    '4ccsj399': {
      'en': 'Dashboard',
      'id': '',
      'ms': '',
    },
    'ifmr17ap': {
      'en': 'Expense',
      'id': '',
      'ms': '',
    },
    'euk7mptg': {
      'en': 'Dark',
      'id': '',
      'ms': '',
    },
    '8ou0wj8s': {
      'en': 'User',
      'id': '',
      'ms': '',
    },
    'kbhg6aez': {
      'en': 'Select Dispute: D-10922',
      'id': '',
      'ms': '',
    },
    '3ntc4b2x': {
      'en': 'Ride: Enzo G. (4.9) Driver: Sam M. (4.7)',
      'id': '',
      'ms': '',
    },
    'qb8hji5l': {
      'en': 'Category: Payment Amount: \$12.40 Date: Sep 06 14:12',
      'id': '',
      'ms': '',
    },
    'prxt5msq': {
      'en': 'Ride: Airport -> Downtown Route deviation claim',
      'id': '',
      'ms': '',
    },
    '1y505dgn': {
      'en': 'Evidence',
      'id': '',
      'ms': '',
    },
    'bw1p9w19': {
      'en': '- Rider message: ´Driver took longer route and AC was off.',
      'id': '',
      'ms': '',
    },
    'cpbj7ham': {
      'en': '- ´System: GPS path available; fare calculation logged.',
      'id': '',
      'ms': '',
    },
    'tdkkmpdl': {
      'en': 'Resolution Notes',
      'id': '',
      'ms': '',
    },
    'tezo1v5j': {
      'en': 'Type notes here...',
      'id': '',
      'ms': '',
    },
    '27ojrb9t': {
      'en': 'Refund Amount (optional)',
      'id': '',
      'ms': '',
    },
    '3h1mxqn4': {
      'en': '\$0.00',
      'id': '',
      'ms': '',
    },
    '9ikh0ma1': {
      'en': 'Outcome',
      'id': '',
      'ms': '',
    },
    'nvvlq07k': {
      'en': 'Resolve (no refund)',
      'id': '',
      'ms': '',
    },
    'mgoneeue': {
      'en': 'Refund ride',
      'id': '',
      'ms': '',
    },
    'm80rgnn1': {
      'en': 'Escalate',
      'id': '',
      'ms': '',
    },
    'e940m3cf': {
      'en': 'Activity Timeline',
      'id': '',
      'ms': '',
    },
    'hnui4wez': {
      'en': 'Sep 06 14:12 - Dispute opened by rider',
      'id': '',
      'ms': '',
    },
    'j2fja1ut': {
      'en': 'Sep 06 14:15 - Auto-collected GPS and fare log',
      'id': '',
      'ms': '',
    },
    'y2jzn9gp': {
      'en': 'Sep 06 14:45 - Suppoert assigned: Ana J.',
      'id': '',
      'ms': '',
    },
    '8aw25p06': {
      'en': 'Sep 06 15:30 - Driver responded with route screenshot',
      'id': '',
      'ms': '',
    },
    'u7eo6ppe': {
      'en': 'Activity Timeline',
      'id': '',
      'ms': '',
    },
    '80v90lkc': {
      'en': 'Assignee: Ana Jones',
      'id': '',
      'ms': '',
    },
    '34l5zxbi': {
      'en': 'Reassign',
      'id': '',
      'ms': '',
    },
    'gtxyrst4': {
      'en': 'Filters: Open I Under Review I Resolved I Escalated',
      'id': '',
      'ms': '',
    },
    's78e1fs4': {
      'en': 'Export CSV',
      'id': '',
      'ms': '',
    },
    'vxqc9f4e': {
      'en': 'Chat with Driver and Rider',
      'id': '',
      'ms': '',
    },
  },
  // notifications
  {
    'pk737w29': {
      'en': 'Search campaigns ar audiences',
      'id': '',
      'ms': '',
    },
    'pspz3pif': {
      'en': 'Dashboard',
      'id': '',
      'ms': '',
    },
    '9gndrfey': {
      'en': 'Flow Builder',
      'id': '',
      'ms': '',
    },
    'nvcqj8x4': {
      'en': '+ New Campaign',
      'id': '',
      'ms': '',
    },
    '2fw22zfk': {
      'en': 'Compaigns',
      'id': '',
      'ms': '',
    },
    'd5gw7fs2': {
      'en': 'Dark',
      'id': '',
      'ms': '',
    },
    'l9ly7ut2': {
      'en': 'User',
      'id': '',
      'ms': '',
    },
    'lb5mhkek': {
      'en': 'Active',
      'id': '',
      'ms': '',
    },
    'gtvl0oc6': {
      'en': '8',
      'id': '',
      'ms': '',
    },
    'z4lpuvar': {
      'en': 'Scheduled',
      'id': '',
      'ms': '',
    },
    'ktmp4pdq': {
      'en': '5',
      'id': '',
      'ms': '',
    },
    '7cdwuonr': {
      'en': 'Drafts',
      'id': '',
      'ms': '',
    },
    'hkgjnn03': {
      'en': '12',
      'id': '',
      'ms': '',
    },
    's2e99x4p': {
      'en': 'Sent ',
      'id': '',
      'ms': '',
    },
    '7rbrw8ip': {
      'en': '(7d)',
      'id': '',
      'ms': '',
    },
    '80kelmtw': {
      'en': '124k',
      'id': '',
      'ms': '',
    },
    'pq6z5vld': {
      'en': 'Filters',
      'id': '',
      'ms': '',
    },
    'botu1w4k': {
      'en': 'All',
      'id': '',
      'ms': '',
    },
    'm9zogslg': {
      'en': 'Draft',
      'id': '',
      'ms': '',
    },
    'w2oq9pui': {
      'en': 'Scheduled',
      'id': '',
      'ms': '',
    },
    'jyr0r3wx': {
      'en': 'Active',
      'id': '',
      'ms': '',
    },
    'pjwoeu9q': {
      'en': 'Completed',
      'id': '',
      'ms': '',
    },
    '0prwgzup': {
      'en': 'Paused',
      'id': '',
      'ms': '',
    },
    'wqavk9uw': {
      'en': 'Channels',
      'id': '',
      'ms': '',
    },
    'c50zlqzw': {
      'en': 'In-app',
      'id': '',
      'ms': '',
    },
    'v1qol2wu': {
      'en': 'On',
      'id': '',
      'ms': '',
    },
    '5e0b7ooh': {
      'en': 'Push',
      'id': '',
      'ms': '',
    },
    'kz6baqv6': {
      'en': 'On',
      'id': '',
      'ms': '',
    },
    'fv9g2a62': {
      'en': 'Email',
      'id': '',
      'ms': '',
    },
    'jcr9argk': {
      'en': 'On',
      'id': '',
      'ms': '',
    },
    'a3x14q3n': {
      'en': 'SMS',
      'id': '',
      'ms': '',
    },
    '62j8yn1m': {
      'en': 'On',
      'id': '',
      'ms': '',
    },
    'zo4htcut': {
      'en': 'Saved Audiences',
      'id': '',
      'ms': '',
    },
    '3hhaemy5': {
      'en': 'New riders (30d)',
      'id': '',
      'ms': '',
    },
    'fab19eax': {
      'en': 'Tourists',
      'id': '',
      'ms': '',
    },
    'zgjt4z1h': {
      'en': 'Higt value locals',
      'id': '',
      'ms': '',
    },
    'jg5wchxs': {
      'en': 'Dormant riders (90d)',
      'id': '',
      'ms': '',
    },
    '1ruu29ah': {
      'en': '+ New Audience',
      'id': '',
      'ms': '',
    },
    'ftdgcxqt': {
      'en': 'Campaigns',
      'id': '',
      'ms': '',
    },
    '3vy6h4eq': {
      'en': 'Name',
      'id': '',
      'ms': '',
    },
    'o4u6nenv': {
      'en': 'Rubis Weekend Fuel 5%',
      'id': '',
      'ms': '',
    },
    'dx6rlih4': {
      'en': 'Status',
      'id': '',
      'ms': '',
    },
    'y9g0gsol': {
      'en': 'Scheduled',
      'id': '',
      'ms': '',
    },
    'do5vckqp': {
      'en': 'Send',
      'id': '',
      'ms': '',
    },
    '9tpurk7e': {
      'en': 'Sep 28 10:00',
      'id': '',
      'ms': '',
    },
    'an05w88f': {
      'en': 'Edit',
      'id': '',
      'ms': '',
    },
    'emfq9x4t': {
      'en': 'Airport Welcome Promo',
      'id': '',
      'ms': '',
    },
    'hwxmocy9': {
      'en': 'Active',
      'id': '',
      'ms': '',
    },
    'k6fmhao9': {
      'en': 'Now',
      'id': '',
      'ms': '',
    },
    'swzs2qpi': {
      'en': 'Pause',
      'id': '',
      'ms': '',
    },
    '32i0vtbu': {
      'en': 'Dormant Winback 10 USD',
      'id': '',
      'ms': '',
    },
    'e7fzbazl': {
      'en': 'Draft',
      'id': '',
      'ms': '',
    },
    '4khyvze3': {
      'en': '-',
      'id': '',
      'ms': '',
    },
    'zvvcyhts': {
      'en': 'Edit',
      'id': '',
      'ms': '',
    },
    '53n2p3ur': {
      'en': 'Supermarket 5% Weekday',
      'id': '',
      'ms': '',
    },
    'ild91965': {
      'en': 'Active',
      'id': '',
      'ms': '',
    },
    'e2us8vbp': {
      'en': 'Now',
      'id': '',
      'ms': '',
    },
    'rvjzo2vh': {
      'en': 'Pause',
      'id': '',
      'ms': '',
    },
    'b4uwzg61': {
      'en': 'Local Gold Hotel 20%',
      'id': '',
      'ms': '',
    },
    'ii4nllff': {
      'en': 'Draft',
      'id': '',
      'ms': '',
    },
    'xeymiji1': {
      'en': '-',
      'id': '',
      'ms': '',
    },
    'cf1e7ktq': {
      'en': 'Edit',
      'id': '',
      'ms': '',
    },
    'z0nzxgy6': {
      'en': 'Notifications Crated',
      'id': '',
      'ms': '',
    },
    'gkz2syyt': {
      'en': 'Name',
      'id': '',
      'ms': '',
    },
    'wq2t2i1w': {
      'en': 'Rubis Weekend Fuel 5%',
      'id': '',
      'ms': '',
    },
    '5i0c5yey': {
      'en': 'Status',
      'id': '',
      'ms': '',
    },
    'iyexc844': {
      'en': 'Draft',
      'id': '',
      'ms': '',
    },
    '8yso1c7z': {
      'en': 'Send',
      'id': '',
      'ms': '',
    },
    '5hh9plg7': {
      'en': 'Sep 28 10:00',
      'id': '',
      'ms': '',
    },
    'jrlqrb1d': {
      'en': 'Edit',
      'id': '',
      'ms': '',
    },
    '51szf7r2': {
      'en': 'Airport Welcome Promo',
      'id': '',
      'ms': '',
    },
    'mhgyulqi': {
      'en': 'Active',
      'id': '',
      'ms': '',
    },
    'u06j23d8': {
      'en': 'Now',
      'id': '',
      'ms': '',
    },
    'xb6apz32': {
      'en': 'Pause',
      'id': '',
      'ms': '',
    },
    'e99hn4zb': {
      'en': 'Dormant Winback 10 USD',
      'id': '',
      'ms': '',
    },
    'pww31h7y': {
      'en': 'Draft',
      'id': '',
      'ms': '',
    },
    'svrizcrc': {
      'en': '-',
      'id': '',
      'ms': '',
    },
    'wo52itz3': {
      'en': 'Edit',
      'id': '',
      'ms': '',
    },
    'oitbnrmu': {
      'en': 'Supermarket 5% Weekday',
      'id': '',
      'ms': '',
    },
    'dvfrep6v': {
      'en': 'Active',
      'id': '',
      'ms': '',
    },
    'jvdxjyhw': {
      'en': 'Now',
      'id': '',
      'ms': '',
    },
    'k88xxhde': {
      'en': 'Pause',
      'id': '',
      'ms': '',
    },
    'viwh8dqf': {
      'en': 'Local Gold Hotel 20%',
      'id': '',
      'ms': '',
    },
    '77y9ir9k': {
      'en': 'Draft',
      'id': '',
      'ms': '',
    },
    'vj2z6na6': {
      'en': '-',
      'id': '',
      'ms': '',
    },
    '6trfysvh': {
      'en': 'Edit',
      'id': '',
      'ms': '',
    },
    '0kaulq6c': {
      'en': 'Preview',
      'id': '',
      'ms': '',
    },
    'ldsjiuxg': {
      'en': '[card preview]',
      'id': '',
      'ms': '',
    },
    'q3o6pw3k': {
      'en': 'Save Draft',
      'id': '',
      'ms': '',
    },
    '4opyzjic': {
      'en': 'Schedule',
      'id': '',
      'ms': '',
    },
    'd15t0uy9': {
      'en': 'Send test',
      'id': '',
      'ms': '',
    },
    'xoyp9zzk': {
      'en': 'Composer',
      'id': '',
      'ms': '',
    },
    'w6fuu6h3': {
      'en': 'Title',
      'id': '',
      'ms': '',
    },
    'xswco5f3': {
      'en': 'Message',
      'id': '',
      'ms': '',
    },
    'ihqpwp32': {
      'en': 'CTA text',
      'id': '',
      'ms': '',
    },
    'lqwchjbe': {
      'en': 'CTA link',
      'id': '',
      'ms': '',
    },
    '4mq4znu8': {
      'en': 'Channel',
      'id': '',
      'ms': '',
    },
    'h8a9jnhn': {
      'en': 'In-app',
      'id': '',
      'ms': '',
    },
    'p58llyh0': {
      'en': 'Push',
      'id': '',
      'ms': '',
    },
    'u5m9g731': {
      'en': 'Email',
      'id': '',
      'ms': '',
    },
    'h6ydg108': {
      'en': 'Audience',
      'id': '',
      'ms': '',
    },
    'bgupx4wv': {
      'en': 'Change',
      'id': '',
      'ms': '',
    },
    'n6zz1tj0': {
      'en': 'Schedule',
      'id': '',
      'ms': '',
    },
    'wmksme1m': {
      'en': 'Sep 28 10:00',
      'id': '',
      'ms': '',
    },
    'zfando4r': {
      'en': 'Send now',
      'id': '',
      'ms': '',
    },
    'f3ndrdim': {
      'en': 'A/B Variant',
      'id': '',
      'ms': '',
    },
    'mkbtnpql': {
      'en': 'Add B',
      'id': '',
      'ms': '',
    },
    '5xu3eosr': {
      'en': 'Frequency cap per user',
      'id': '',
      'ms': '',
    },
    'fi4uamaf': {
      'en': '2/ day',
      'id': '',
      'ms': '',
    },
  },
  // Miscellaneous
  {
    '1b184oon': {
      'en': 'Hello World',
      'id': '',
      'ms': '',
    },
    'yffxtlv9': {
      'en': '',
      'id': '',
      'ms': '',
    },
    'suhitff5': {
      'en': '',
      'id': '',
      'ms': '',
    },
    '65e2tfs2': {
      'en': '',
      'id': '',
      'ms': '',
    },
    'ddazihx4': {
      'en': '',
      'id': '',
      'ms': '',
    },
    'db03cpjj': {
      'en': '',
      'id': '',
      'ms': '',
    },
    'fdb9078p': {
      'en': '',
      'id': '',
      'ms': '',
    },
    '80ouzj9q': {
      'en': '',
      'id': '',
      'ms': '',
    },
    '6rzhptp9': {
      'en': '',
      'id': '',
      'ms': '',
    },
    'ce8c4ty0': {
      'en': '',
      'id': '',
      'ms': '',
    },
    'k6qf3ey2': {
      'en': '',
      'id': '',
      'ms': '',
    },
    'qai9f6rv': {
      'en': '',
      'id': '',
      'ms': '',
    },
    '92ch4qdg': {
      'en': '',
      'id': '',
      'ms': '',
    },
    '7qwrcuqx': {
      'en': '',
      'id': '',
      'ms': '',
    },
    'kcvqa08x': {
      'en': '',
      'id': '',
      'ms': '',
    },
    'dqrzd6sq': {
      'en': '',
      'id': '',
      'ms': '',
    },
    'dpqtohyf': {
      'en': '',
      'id': '',
      'ms': '',
    },
    'v01vf71s': {
      'en': '',
      'id': '',
      'ms': '',
    },
    'gcv6def1': {
      'en': '',
      'id': '',
      'ms': '',
    },
    'um9es99m': {
      'en': '',
      'id': '',
      'ms': '',
    },
    'o4enbz4j': {
      'en': '',
      'id': '',
      'ms': '',
    },
    '8z4tvfh7': {
      'en': '',
      'id': '',
      'ms': '',
    },
    '2ybzla8x': {
      'en': '',
      'id': '',
      'ms': '',
    },
    'd1wdf5i1': {
      'en': '',
      'id': '',
      'ms': '',
    },
    'zboc6h9v': {
      'en': '',
      'id': '',
      'ms': '',
    },
    '2py80kgi': {
      'en': '',
      'id': '',
      'ms': '',
    },
    'p6lsrh2a': {
      'en': '',
      'id': '',
      'ms': '',
    },
    'ne8cclp9': {
      'en': '',
      'id': '',
      'ms': '',
    },
  },
].reduce((a, b) => a..addAll(b));
