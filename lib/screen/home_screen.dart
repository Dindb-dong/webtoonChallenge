import 'package:flutter/material.dart';
import 'package:prot_1/models/webtoon_model.dart';
import 'package:prot_1/services/api_service.dart';
import 'package:prot_1/widgets/webtoon_widget.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final Future<List<WebtoonModel>> webtoons = ApiService.getTodaysToons();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.black,
        foregroundColor: Colors.green,
        title: const Text(
          '오늘의 웹툰',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: webtoons,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    SizedBox(
                      height: 400,
                      width: 900,
                      child: makeList(snapshot),
                    ), // 높이가 얼마나 긴지 몰라서(무한대) Expanded를 넣어줘야 함
                  ],
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ],
      ),
    );
  }

  ListView makeList(AsyncSnapshot<List<WebtoonModel>> snapshot) {
    return ListView.separated(
      // 사용자가 보고있는 아이템만 build함.
      // + 구분자 separator를 생성함.
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 20,
      ),
      scrollDirection: Axis.horizontal, // 수평 방향 스크롤
      itemCount: snapshot.data!.length, // 한 번에 몇 개 보여줄건지
      itemBuilder: (context, index) {
        // ListView.builder가 아이템을 build할 때 반드시 !!! 호출하는 함수
        var webtoon = snapshot.data![
            index]; // webtoon이라는, snapshot.data라는 함수의 [index]에 해당하는 변수 생성.
        return Webtoon(
          // Webtoon이라는 위젯을 렌더링.
          title: webtoon.title,
          thumb: webtoon.thumb,
          id: webtoon.id,
        );
      },
      separatorBuilder: (context, index) => const SizedBox(
        width: 40,
      ), // 반드시 필요한 함수. 뭘로 구분할 건지를 만드는거임
    );
  }
}
