import 'package:algolia/algolia.dart';
import '../models/province.dart';

class AlogoliaServices {
  AlogoliaServices._privateConstructor();

  static final AlogoliaServices instance =
      AlogoliaServices._privateConstructor();
  static final algolisServices = AlogoliaServices.instance;

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
