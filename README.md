issues-notification
===================

GitHub issuesをcloseした通知を受けるダッシュボードです。

![screen shot](https://cloud.githubusercontent.com/assets/96539/3793442/8058e760-1b97-11e4-84d3-4a9ccdaf9326.png)

[mana.bo](https://mana.bo/)では、[zenhub](https://www.zenhub.io/)を導入していますが、issueをcloseするとboardから消えてしまうのが少し不便です。他のチームからも他人の作業完了をトラッキングしたいという要望から、Push通知でリアルタイムに他人のcloseをディスプレイできる仕組みを用意しました。

開発環境の設定
==============

[.env.sample](https://github.com/dddaisuke/issues-notification/blob/master/.env.sample)を.env にリネームして必要なキーを設定して下さい。

[top_controller](https://github.com/dddaisuke/issues-notification/blob/master/app/controllers/top_controller.rb)で表示するリポジトリを制御できます。

リアルタイムにPush通知を受けたいリポジトリのWebhookを設定する。URLは`http://example.com/github/webhook` です。

本番環境の設定
==============

サーバーはherokuで運用できるので、.env.sampleに設定する必要があるキーをすべて`heroku config:add` で追加すれば動きます。
