import 'package:algolia/algolia.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/province.dart';

class AlogoliaService {
  AlogoliaService._privateConstructor();

  static final AlogoliaService instance = AlogoliaService._privateConstructor();
  static final algolisServices = AlogoliaService.instance;

  final Algolia _algolia = Algolia.init(
    applicationId: DotEnv().env['ALGOLIA_APP_ID'],
    apiKey: DotEnv().env['ALGOLIA_KEY'],
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
