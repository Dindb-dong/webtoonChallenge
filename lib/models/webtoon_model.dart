class WebtoonModel {
  final String title, thumb, id;

  WebtoonModel.fromJson(
      Map<String, dynamic> json) // json 자리에는 넘겨받은 리스트의 이름이 들어감.
      // 받아온 데이터를, 각각 초기화시켜주는거임
      : title = json['title'],
        thumb = json['thumb'],
        id = json['id'];
  // named parametor로 만들어줌.
}
