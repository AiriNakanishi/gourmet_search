class AppData {
  static const Map<String, String> genres = {
    '': 'すべて',
    'G014': 'カフェ・スイーツ',
    'G001': '居酒屋',
    'G008': '焼肉・ホルモン',
    'G013': 'ラーメン',
    'G004': '和食',
    'G006': 'イタリアン・フレンチ',
    'G007': '中華',
    'G005': '洋食',
    'G017': '韓国料理',
    'G016': 'お好み焼き・もんじゃ',
    'G002': 'ダイニングバー・バル',
    'G012': 'バー・カクテル',
    'G009': 'アジア・エスニック料理',
    'G003': '創作料理',
    'G010': '各国料理',
    'G011': 'カラオケ・パーティ',
    'G015': 'その他グルメ',
  };

  static double getRangeInMeters(int range) {
    switch (range) {
      case 1:
        return 300;
      case 2:
        return 500;
      case 3:
        return 1000;
      case 4:
        return 2000;
      case 5:
        return 3000;
      default:
        return 1000;
    }
  }

  // range(1~5)から表示用テキストを返す
  static String getRangeText(int range) {
    switch (range) {
      case 1:
        return "300m";
      case 2:
        return "500m";
      case 3:
        return "1km";
      case 4:
        return "2km";
      case 5:
        return "3km";
      default:
        return "1km";
    }
  }

  static String getGenreText(String genreCode) {
    switch (genreCode) {
      case 'G014':
        return 'カフェ・スイーツ';
      case 'G001':
        return '居酒屋';
      case 'G008':
        return '焼肉・ホルモン';
      case 'G013':
        return 'ラーメン';
      case 'G004':
        return '和食';
      case 'G006':
        return 'イタリアン・フレンチ';
      case 'G007':
        return '中華';
      case 'G005':
        return '洋食';
      case 'G017':
        return '韓国料理';
      case 'G016':
        return 'お好み焼き・もんじゃ';
      case 'G002':
        return 'ダイニングバー・バル';
      case 'G012':
        return 'バー・カクテル';
      case 'G009':
        return 'アジア・エスニック料理';
      case 'G003':
        return '創作料理';
      case 'G010':
        return '各国料理';
      case 'G011':
        return 'カラオケ・パーティ';
      case 'G015':
        return 'その他グルメ';
      default:
        return '飲食店';
    }
  }
}
