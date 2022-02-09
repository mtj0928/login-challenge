# App
アプリの主な処理はこのAppパッケージの中にあります。  
AppはVIPERアーキテクチャーで構成されており、以下のモジュールを含んでいます。   

- App: アプリケーションに共通の処理
- ViewBuilders: VIPERのモジュールを組み立てるモジュール
- Views
- Presenters
- Routers
- Interactors
- Supports: koeherさんが用意したユーティリティメソッド群
- VIPERKit: VIPERを構築するためのモジュール

基本的には、上から下に依存している構成ですので、ここからは下のモジュールから順に説明していきます。

## VIPERKit
今回のために自作したVIPERを構築するためのモジュールです。  
といっても、中に含まれているのはprotocolとPresenterを構築するためのBuilderのみです。

- [Protocols.swift](/Projects/App/Sources/VIPERKit/Protocols.swift)
- [PresenterBuilder.swift](/Projects/App/Sources/VIPERKit/PresenterBuilder.swift)

PresenterBuilderは少し工夫をしました。
型でどのDependencyが設定されているのかを表現し、設定がもう終わったあとにはコード補完に出さないようにし、全ての設定が終わった時だけ`build`メソッドが呼びだせるようにしました。

## Interactors
UseCaseを配置するレイヤーです。
といっても今回のアプリの場合、複雑なロジックではないので、実質 `UserService` や `HomeService` につなぎこみをしているだけです。

唯一工夫した点としては、各Serviceをprotocolに切り出し、initでDIしている点です。
こうすることで、　IneractorsモジュールはAPIServicesモジュールに依存する必要がなくなりました。
これはミニアプリを作る上ではかなり強力に働きます。

## Presenters
ViewModelを配置するレイヤーです。
エラーハンドリングを統一したかったので、`AlertableError`というプロトコルを用意し、EntitiesモジュールにあるErrorを準拠させました。
諸事情で、ViewのレイヤーでAlertableErrorが使えなかったので、`AlertError`を別途用意しました。
