# App

アプリの主な処理はこのAppパッケージの中にあります。

AppはVIPERアーキテクチャーで構成されており、以下のモジュールを含んでいます。

- App: アプリケーションに共通の処理
- ViewBuilders: VIPERのモジュールを組み立てるモジュール
- Views
- Presenters
- Routers
- Interavtors
- Supports: koeherさんが用意したユーティリティメソッド群
- VIPERKit: VIPERを構築するためのモジュール

基本的には、上から下に依存している構成ですので、ここから下のモジュールから説明していきます。

## VIPERKit
今回のために自作したVIPERを構築するためのモジュールです。  
と言っても、中に含まれているのはprotocolとPresenterを構築するためのBuilderのみです。

- [Protocols.swift](/Projects/App/Sources/VIPERKit/Protocols.swift)
- [PresenterBuilder.swift](/Projects/App/Sources/VIPERKit/PresenterBuilder.swift)


