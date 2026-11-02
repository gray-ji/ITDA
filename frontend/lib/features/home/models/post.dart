enum Category {
  ELECTRONICS,
  WALLET_MONEY_ID,
  FASHION,
  DAILY_GOODS,
  STATIONERY_BOOKS,
  SPORTS_LEISURE,
  BABY_GOODS,
  PET_SUPPLIES,
  FOOD,
  OTHER,
}

enum Status {
  LOOKING,
  STORED,
  RETURNED,
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
      case Category.ELECTRONICS:
        return '전자제품';
      case Category.WALLET_MONEY_ID:
        return '지갑/현금/신분증';
      case Category.FASHION:
        return '패션';
      case Category.DAILY_GOODS:
        return '생활용품';
      case Category.STATIONERY_BOOKS:
        return '문구/도서';
      case Category.SPORTS_LEISURE:
        return '스포츠/레저';
      case Category.BABY_GOODS:
        return '유아용품';
      case Category.PET_SUPPLIES:
        return '반려동물용품';
      case Category.FOOD:
        return '식품';
      case Category.OTHER:
        return '기타';
    }
  }

  String get statusLabel {
    switch (status) {
      case Status.LOOKING:
        return '찾는중';
      case Status.STORED:
        return '보관중';
      case Status.RETURNED:
        return '반환완료';
    }
  }
}