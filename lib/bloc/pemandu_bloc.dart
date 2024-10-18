import 'dart:convert';
import '/helpers/api.dart';
import '/helpers/api_url.dart';
import '/model/pemandu.dart';

class PemanduBloc {
  static Future<List<Pemandu>> getPemandus() async {
    String apiUrl = ApiUrl.listPemandu;
    var response = await Api().get(apiUrl);
    var jsonObj = json.decode(response.body);
    List<dynamic> listPemandu = (jsonObj as Map<String, dynamic>)['data'];
    List<Pemandu> pemandus = [];
    for (var item in listPemandu) {
      pemandus.add(Pemandu.fromJson(item));
    }
    return pemandus;
  }

  static Future<bool> addPemandu({required Pemandu pemandu}) async {
    String apiUrl = ApiUrl.createPemandu;
    var body = {
      "guide": pemandu.guide,
      "languages": pemandu.languages,
      "rating": pemandu.rating.toString()
    };
    var response = await Api().post(apiUrl, body);
    var jsonObj = json.decode(response.body);
    return jsonObj['status'] == 'success';
  }

  static Future<bool> updatePemandu({required Pemandu pemandu}) async {
    String apiUrl = ApiUrl.updatePemandu(pemandu.id!);
    print(apiUrl);
    var body = {
      "guide": pemandu.guide,
      "languages": pemandu.languages,
      "rating": pemandu.rating
    };
    print("Body : $body");
    var response = await Api().put(apiUrl, jsonEncode(body));
    var jsonObj = json.decode(response.body);
    return jsonObj['status'] == 'success';
  }

  static Future<bool> deletePemandu({required int id}) async {
    String apiUrl = ApiUrl.deletePemandu(id);
    var response = await Api().delete(apiUrl);
    var jsonObj = json.decode(response.body);
    return jsonObj['status'] == 'success';
  }
}
