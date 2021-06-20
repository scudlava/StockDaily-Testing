import 'package:algolia/algolia.dart';

class AlgoliaApplication{
  static final Algolia algolia = Algolia.init(
    applicationId: 'TIEK7ZKP91', //ApplicationID
    apiKey: '0c484322674982a195900a720a614248', //search-only api key in flutter code
  );
}