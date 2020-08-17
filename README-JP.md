# iris4health-fhir-analytics

IRIS for Health FHIRサーバー上に構築されたIRIS Analyticsリソースのセット。

## 準備はいいですか？

* IRIS for HealthインスタンスでのサンプルFHIRサーバーのセットアップ。
*のPOC：
   * IRIS Analytics（以前はDeepSeeと呼ばれていました）を使用した患者向けのシンプルなキューブ、ピボットテーブル、およびダッシュボード。
   *キューブマネージャーを作成します。
   * [DeepSeeWeb]（https://openexchange.intersystems.com/package/DeepSeeWeb）のサポート
   * Microsoft Power BIでダッシュボードを設定する例

## 取り付け

このリポジトリを複製

```
https://github.com/jrpereirajr/iris-fhir-analytics.git
```

Dockerコンテナーをビルドします。

```
cd .\iris-fhir-analytics\
docker-compose up -d
```

## それを探る

インストール後、一部のデータがIRIS for Healthにアップロードされます。 IRISの初期化を待ってから、FHIR SQLスキーマデータベースを介してそのようなデータをチェックアウトできます。

<img src="https://raw.githubusercontent.com/jrpereirajr/iris4health-fhir-analytics/master/img/Screenshot_36.png"></img>

シンプルなIRIS Analytics患者ダッシュボードもこのURLで利用できます。

*Credentials*:
 * Username: _SYSTEM
 * Password: SYS

```
http://localhost:32783/csp/healthshare/fhirserver/_DeepSee.UserPortal.DashboardViewer.zen?DASHBOARD=User/Patient.dashboard
```
<img src="https://raw.githubusercontent.com/jrpereirajr/iris-fhir-analytics/master/img/Lt94eO0NZa.gif"></img>

この同じダッシュボードは[DeepSeeWeb]（https://openexchange.intersystems.com/package/DeepSeeWeb）を使用して表示できます。

```
http://localhost:32783/dsw/index.html#!/d/User/Patient.dashboard?ns=FHIRSERVER
```
<img src="https://raw.githubusercontent.com/jrpereirajr/iris-fhir-analytics/master/img/lN0F0MSNJr.gif"></img>

FHIRデータのキューブ作成を使用して、Microsoft Power BIダッシュボードをフィードすることもできます（手順[ここ]（power-bi-creating-patient-dashboard.md））。

<img src="https://raw.githubusercontent.com/jrpereirajr/iris-fhir-analytics/master/img/xUxNmpMvvQ.gif"></img>