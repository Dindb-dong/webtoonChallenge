import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:prot_1/models/webtoon_detail_model.dart';
import 'package:prot_1/models/webtoon_model.dart';
import 'package:prot_1/models/webtoon_episode_model.dart';

class ApiService {
  static const String baseURL =
      "https://webtoon-crawler.nomadcoders.workers.dev";
  static const String today = "today";

  static Future<List<WebtoonModel>> getTodaysToons() async {
    // return하려면 void가 아니어야 함. 그렇다고 그냥 리스트 반환하는 List<> 쓰자니, async이기 때문에 에러남. 그래서 Future를 앞에 붙여줘야 함.
    // await 함수 쓰기 위한 조건
    List<WebtoonModel> webtoonInstances = []; // WebtoonModel 클래스를 가지는 List 생성
    final url = Uri.parse('$baseURL/$today'); // baseURL에 있는걸 today 단위로 쪼갠다?
    final response = // API를 요청
        await http.get(url); // response타입은 url이라는 http에 있는 데이터를 get 해온 것이다?
    // Future타입 함수 -> 당장 실행되지 못한다는 뜻
    // 응답을 받을 때까지 기다려야 함.
    // get이 끝나지 않고 넘어가버리면 큰일이기 때문!
    if (response.statusCode == 200) {
      final List<dynamic> webtoons =
          jsonDecode(response.body); // 텍스트로 된 reponse body를 JSON으로 디코딩.
      // 그리고 거기서 다이나믹으로 이루어진 리스트를 받음.
      for (var webtoon in webtoons) {
        webtoonInstances.add(WebtoonModel.fromJson(webtoon));
        // webtoon JSON으로 WebtoonModel 인스턴스를 생성.
        // 그리고 JSON은 Map임. key는 String, value는 dynamic.
      }
      return webtoonInstances;
    }
    throw Error();
  }

  static Future<WebtoonDetailModel> getToonById(String id) async {
    final url = Uri.parse("$baseURL/$id"); // baseurl에서 id를 찾아온다
    final response = await http.get(url); // url로 request 보냄
    if (response.statusCode == 200) {
      final webtoon = jsonDecode(response.body);
      return WebtoonDetailModel.fromJson(
          webtoon); // 메서드에다가, 위에서 decode한 webtoon을 전달해주는거임.
    } // 그러면 WebtoonDetailModel은 저 디코드된 webtoon을 받아다가 title, ... 같은 변수들에 각 값을 할당해줌.
    throw Error();
  }

  static Future<List<WebtoonEpisodeModel>> getLatestEpisodesById(
      String id) async {
    List<WebtoonEpisodeModel> episodesInstances = [];
    final url = Uri.parse("$baseURL/$id/episodes"); // baseurl에서 id를 찾아온다
    final response = await http.get(url); // url로 request 보냄
    if (response.statusCode == 200) {
      final episodes = jsonDecode(response.body);
      for (var episode in episodes) {
        // 모든 episode에다가 모델의 인스턴스를 담아줌
        episodesInstances.add(WebtoonEpisodeModel.fromJson(episode));
      }
      return episodesInstances;
    } // 그러면 WebtoonDetailModel은 저 디코드된 webtoon을 받아다가 title, ... 같은 변수들에 각 값을 할당해줌.
    throw Error();
  }
}
