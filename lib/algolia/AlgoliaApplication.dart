// ignore_for_file: file_names, prefer_const_declarations


import 'package:algolia/algolia.dart';

class AlgoliaApplication{
  static final Algolia algolia = const Algolia.init(
    applicationId: 'ZO4XKCM05Q', //ApplicationID
    apiKey: 'b57d151dcd4821d1df6a23485e70ec2d', //search-only api key in flutter code
  );
}