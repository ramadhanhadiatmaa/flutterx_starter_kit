# Example

```dart
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutterx_starter_kit/flutterx_starter_kit.dart';

void main() async {
  // Start code
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');
  final base = dotenv.env['API_BASE_URL'];
  ApiClient.init(ApiConfig(baseUrl: base!));

  // Configure TextKit font
  TextKitConfig.setFont('fredoka');
  // End code

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'eQuran Demo',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.green),
      home: const SuratDetailPage(nomorSurat: 1),
    );
  }
}

class SuratDetailPage extends StatefulWidget {
  const SuratDetailPage({super.key, required this.nomorSurat});
  final int nomorSurat;

  @override
  State<SuratDetailPage> createState() => _SuratDetailPageState();
}

class _SuratDetailPageState extends State<SuratDetailPage> {
  late Future<Map<String, dynamic>> _futureDetail;

  @override
  void initState() {
    super.initState();
    _futureDetail = _fetchDetail();
  }

  Future<Map<String, dynamic>> _fetchDetail() async {
    final res = await ApiClient.instance.get('/surat/1');
    if (res.statusCode != 200) {
      throw ApiException(
        'Unexpected status ${res.statusCode}',
        statusCode: res.statusCode,
        data: res.data,
      );
    }

    final root = (res.data is Map) ? (res.data as Map) : <String, dynamic>{};
    final data = root['data'];
    if (data is Map) {
      return data.map((k, v) => MapEntry(k.toString(), v));
    }
    return <String, dynamic>{};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Surat')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _futureDetail,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            final hint = kIsWeb
                ? '\n\nHint Web: Jika error CORS, coba emulator Android/iOS, '
                      'atau gunakan proxy CORS untuk development.'
                : '';
            log('Error: ${snap.error}');
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Text('Error: ${snap.error}$hint'),
            );
          }

          final detail = snap.data ?? const <String, dynamic>{};
          if (detail.isEmpty) {
            return const Center(child: Text('Tidak ada data.'));
          }

          final nomor = detail['nomor']?.toString() ?? '-';
          final nama = detail['nama']?.toString() ?? '';
          final namaLatin = detail['namaLatin']?.toString() ?? '';
          final arti = detail['arti']?.toString() ?? '';
          final tempatTurun = detail['tempatTurun']?.toString() ?? '';
          final jumlahAyat = detail['jumlahAyat']?.toString() ?? '-';
          final deskripsi = detail['deskripsi']?.toString() ?? '';

          final ayatListDynamic = detail['ayat'];
          final List<Map<String, dynamic>> ayatList = (ayatListDynamic is List)
              ? ayatListDynamic
                    .whereType<Map>()
                    .map((e) => e.map((k, v) => MapEntry(k.toString(), v)))
                    .cast<Map<String, dynamic>>()
                    .toList()
              : const [];

          return ListView(
            children: [
              ListTile(
                title: Text('$namaLatin  (No. $nomor)'),
                subtitle: Text(
                  [
                    if (nama.isNotEmpty) 'Arab: $nama',
                    if (arti.isNotEmpty) 'Arti: $arti',
                    if (tempatTurun.isNotEmpty) 'Turun: $tempatTurun',
                    'Jumlah ayat: $jumlahAyat',
                  ].join(' • '),
                ),
              ),
              if (deskripsi.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Text(deskripsi),
                ),
              const Divider(),
              Padding(
                padding: EdgeInsets.all(16),
                // TextKit usage
                child: TextKit.bodyLarge(
                  'Daftar Ayat',
                  color: Colors.blueAccent,
                ),
              ),
              if (ayatList.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('Belum ada daftar ayat.'),
                )
              else
                ...ayatList.map((a) {
                  final no = a['nomorAyat']?.toString() ?? '';
                  final arab = a['teksArab']?.toString() ?? '';
                  final latin = a['teksLatin']?.toString() ?? '';
                  final indo = a['teksIndonesia']?.toString() ?? '';
                  return ListTile(
                    leading: CircleAvatar(child: Text(no)),
                    title: Text(arab, textAlign: TextAlign.right),
                    subtitle: Text('$latin\n$indo'),
                    isThreeLine: true,
                  );
                }),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }
}

```
