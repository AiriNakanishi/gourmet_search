# 簡易仕様書

### 作者
中西 瞳俐<br>
公立はこだて未来大学 システム情報科学部<br>
情報アーキテクチャ学科 情報システムコース<br>
学部3年

### アプリ名
#### もぐあし<br>
<img src="https://github.com/user-attachments/assets/b5811f59-9174-4dbd-987c-30e280a45f75" width="150" alt="app_icon">

#### コンセプト
「歩いて行ける飲食店を見つける」

#### こだわったポイント
* **アプリ内地図表示の実装**: アプリ内でシームレスに店舗位置を確認できるよう、Google Maps APIをアプリ内に直接組み込みました。
* **カテゴリ別検索機能**: 飲食店をジャンル別で絞り込める機能を実装しました。
* **Googleマップアプリとの連携**: 店舗詳細ページからワンタップで公式Googleマップアプリへ遷移する機能を搭載しました。

#### デザイン面でこだわったポイント
- **視認性の高い配色**: アプリのテーマカラーに合わせた配色とし、直感的に操作できるボタン配置を意識しました。

### 公開したアプリの URL（Store にリリースしている場合）
なし

### 該当プロジェクトのリポジトリ URL
https://github.com/AiriNakanishi/gourmet_search

## 開発環境
### 開発環境
- **ハードウェア**: MacBook Air (M4, 2025)
- **OS**: macOS
- **ツール**: VS Code, Xcode Simulator
- **フレームワーク**: Flutter 3.32.8 (FVM管理)
- **言語**: Dart 3.8.1

### 開発言語
Dart 3.8.1

### テーブル定義(ER図)などの設計ドキュメント（ウェブアプリ）
なし

### 開発環境構築手順(ウェブアプリ)
なし

## 動作対象端末・OS
### 動作対象OS
iOS 12.0以上 / Android 5.0以上<br>
(iPhone 16 Pro Max Simulator にて動作確認済み)

## 開発期間
14日間

## アプリケーション機能

### 機能一覧
- レストラン検索：ホットペッパーグルメサーチAPIとGoogleMap APIを使用して、現在地周辺の飲食店を検索する。
- レストラン情報取得：ホットペッパーグルメサーチAPIを使用して、飲食店の詳細情報を取得する。
- 地図アプリ連携：飲食店の所在地を外部のGoogleMapアプリに連携し、経路を表示する。

### 画面一覧
- 検索画面 ：距離やジャンルの条件を指定してレストランを検索する。
- 一覧画面 ：検索結果の飲食店を地図とリストで併記表示する。
- 詳細画面 ：選択した飲食店の詳細情報を表示する。<br>

<img width="200" alt="splash画面" src="https://github.com/user-attachments/assets/f9018ad9-5a64-4020-b181-983b56d17576" />
<img width="200" alt="検索画面" src="https://github.com/user-attachments/assets/c75c149b-65c5-465d-9ea4-32bfb174b303" />
<img width="200" alt="一覧画面" src="https://github.com/user-attachments/assets/4360e6ec-8b68-42e6-8499-53f397bfa202" />
<img width="200" alt="詳細画面" src="https://github.com/user-attachments/assets/8aa0ca12-0f08-48ce-8a8b-e09e8ad5a962" />


### 使用しているAPI,SDK,ライブラリなど
- ホットペッパーグルメサーチAPI
- Google Maps API
- `google_maps_flutter`
- `geolocator`
- `url_launcher`
- `flutter_dotenv`

### 技術面でアドバイスして欲しいポイント
- 地図のピンアイコンを画像に置き換えたかったが、実装できなかった。
- お気に入り登録機能を実装し、検索したお店を保存できるようにしたい。

### 自己評価
限られた開発期間の中で、API連携や地図表示といったコア機能を安定して動作させることができた。<br>
デザイン面では、カスタムピンの実装見送りやアプリアイコンのクオリティなど、細部へのこだわりを形にしきれなかった。<br>
この経験を糧に、今後は技術スタックを広げるだけでなく、デザイン技術の習得にも注力したい。
