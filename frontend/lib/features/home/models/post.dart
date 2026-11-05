enum Category {
  electronics,
  walletMoneyId,
  fashion,
  dailyGoods,
  stationeryBooks,
  sportsLeisure,
  babyGoods,
  petSupplies,
  food,
  other,
}

enum Status {
  looking,
  stored,
  returned,
}

class Post {
  final String postId;
  final String title;
  final Category category;
  final Status status;
  final String location;
  final String occurredFrom;
  final String? occurredTo;
  final String? thumbnailUrl;
  final String createdAt;

  const Post({
    required this.postId,
    required this.title,
    required this.category,
    required this.status,
    required this.location,
    required this.occurredFrom,
    this.occurredTo,
    this.thumbnailUrl,
    required this.createdAt,
  });

  String get categoryLabel {
    switch (category) {
      case Category.electronics:
        return '전자제품';
      case Category.walletMoneyId:
        return '지갑/현금/신분증';
      case Category.fashion:
        return '패션';
      case Category.dailyGoods:
        return '생활용품';
      case Category.stationeryBooks:
        return '문구/도서';
      case Category.sportsLeisure:
        return '스포츠/레저';
      case Category.babyGoods:
        return '유아용품';
      case Category.petSupplies:
        return '반려동물용품';
      case Category.food:
        return '식품';
      case Category.other:
        return '기타';
    }
  }

  String get statusLabel {
    switch (status) {
      case Status.looking:
        return '찾는중';
      case Status.stored:
        return '보관중';
      case Status.returned:
        return '반환완료';
    }
  }
}