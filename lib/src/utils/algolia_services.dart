import 'package:algolia/algolia.dart';
import '../model/province.dart';

class AlogoliaService {
  AlogoliaService._privateConstructor();

  static final AlogoliaService instance = AlogoliaService._privateConstructor();
  static final algolisServices = AlogoliaService.instance;

  final Algolia _algolia = Algolia.init(
    applicationId: 'AFJN3ROVJZ',
    apiKey: 'a16abd9d632825bb87c181f6a97ecc7d',
  );

  AlgoliaIndexReference get _provinces => _algolia.instance.index('provinces');
  Future<List<Province>> performProvinceSearch({text: String}) async {
    final query = _provinces.search(text);
    final snap = await query.getObjects();
    final provinces = snap.hits
        .map((provinces) => Province.fromJSON(provinces.data))
        .toList();
    return provinces;
  }
}
