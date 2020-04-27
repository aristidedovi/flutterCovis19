import 'package:covid/models/countrie_models.dart';
import 'package:http/http.dart';
import 'dart:convert';

class HttpService {
  final String postsURL = "https://api.covid19api.com/";

  Future<List<Countrie>> getPosts(countrie) async {
    Response res = await get(postsURL + 'live/country/' + countrie);

    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);

      List<Countrie> countries = body
          .map(
            (dynamic item) => Countrie.fromJson(item),
          )
          .toList();

      return countries;
    } else {
      throw "Can't get countrie.";
    }
  }

  Future<List> getCountries() async {
    Response res = await get(postsURL + 'countries');

    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);

      List countries = body
          .map(
            (item) => json.encode(item),
          )
          .toList();

      return countries;
    } else {
      throw "Can't get countrie.";
    }
  }
}
