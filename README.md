# [![](https://raw.githubusercontent.com/itamae-kitchen/itamae-logos/master/small/FA-Itamae-horizontal-01-180x72.png)](https://github.com/itamae-kitchen/itamae)

### Itamae

#### 概要

- サーバーの運用監視に関わるあらゆる機能を自らの手で構築していくために、必要なレシピ・テストコードを管理する。

#### 事前準備

- ホスティングサービスの契約、もしくはローカル環境にて仮想環境を構築する。(割愛)
- Itamae を実行する環境から SSH で、対象のサーバーにアクセスできるかを確認する。(割愛)
- Itamae を実行する環境で Ruby を動作させる。(1 章)
- 環境ごとのリポジトリを作成する。(2 章)
- 必要な秘匿情報（パスワードや鍵の準備など）を準備しておく。(3 章)

##### 1. Ruby の導入

- Ruby の動作を確認する。

```
$ asdf current ruby
ruby            3.x.x           .tool-versions
# 3.x.x以上だと問題なく動作する。
```

##### 2.リポジトリの整備

- プロジェクト用のリポジトリを作成する。
  - 参考: [Wordpress ブログ用リポジトリ](https://github.com/mad-psychedelic-metropolis/wordpress-blog)

```
$ git clone [作成したリポジトリのURL] && [作成しリポジトリ名]
$ git checkout -b issue/0
$ git submodule add https://github.com/mad-psychedelic-metropolis/itamae itamae
$ cp -i itamae/Gemfile .
$ cp -i itamae/Rakefile .
$ mkdir hosts && cp -i itamae/hosts/template.yml hosts/[SSHでログインでいるホスト名].yml
$ vi hosts/[SSHでログインでいるホスト名].yml      # 設定したい値に変更する
$ bundle install      # Gemfileの中身に沿ってインストールされ、Gemfile.lockが生成される
$ git add ../[作成しリポジトリ名]
$ git commit -m "Itamae管理のリポジトリの環境を整備した #0"
$ git push origin HEAD
```

##### 3. 秘匿情報を管理するファイルを作成

```
$ cd [作成しリポジトリ名]
$ cp -i itamae/template.env .env
$ vi .env     # 設定したい値に変更する
```

##### .env で必要な項目

| パラメータ              | 値の説明                                    | 値の例考             |
| ----------------------- | ------------------------------------------- | -------------------- |
| USER\_{uid}\_SSH_PUBLIC | サーバーに設定するユーザーごとの SSH 公開鍵 | USER_1013_SSH_PUBLIC |
| USER\_{uid}\_PASSWORD   | ユーザーのパスワード                        | USER_1013_PASSWORD   |

#### 実行コマンドを確認と紹介

- Itamae を実行するコマンドを確認する
  - ① 設定値に問題ないかを確認する Dry-run
  - ② サーバーに設定を反映させる Run
  - ③ サーバーの設定が正しく入っているかを確認する Spec

```
$ bundle exec rake -T

# ①Dry-run
# 全てのレシピ
rake recipe:[SSHでログインでいるホスト名]:dry-run
# 特定のレシピを指定
rake recipe:[SSHでログインでいるホスト名]:recipe:dry-run[recipe,option]

# ②Run
# 全てのレシピ
rake recipe:node1:run
# 特定のレシピを指定
rake recipe:node1:recipe:run[recipe,option]

# ③Spec
# 全てのレシピ
rake spec:node1
# 特定のレシピを指定
rake spec:node1:target[spec]
```

#### Itamae のレシピを実行

- `bundle exec rake -T`で実行したコマンドを用途ごとに使い分ける。

```
# node1 にて、設定した全ての項目を実行テスト
$ bundle exec rake recipe:node1:run

# node1 にて、指定した項目を実行テスト
$ bundle exec rake recipe:node1:recipe:dry-run[recipe,option] ## Linux
$ bundle exec rake recipe:node1:recipe:dry-run'[recipe,option]' ## Mac

# 例えば....recipe =「mysql」/ option = 「install.rb」のみ実行したい場合
$ bundle exec rake recipe:node1:recipe:dry-run[mysql,install] ## Linux

# 例えば....recipe =「mysql」の全てを実行したい場合
$ bundle exec rake recipe:node1:recipe:dry-run[mysql,default] ## Linux
```

#### 対象の レシピ一覧

| レシピ | レシピの説明                                         | 備考 |
| ------ | ---------------------------------------------------- | ---- |
| users  | ユーザーの作成及び管理/ユーザーごとの SSH 設定を管理 |      |

#### Serverspec を実行

- `bundle exec rake -T`で実行したコマンドを用途ごとに使い分ける。

```
# node1 にて、設定した全ての項目をテスト
$ bundle exec rake spec:node1

# node1 にて、指定した項目を実行テスト
$ bundle exec rake spec:node1:target[spec] ## Linux
$ bundle exec rake spec:node1:target'[spec]' ## Mac

# 例えば....recipe =「mysql_spec.rb」
$ bundle exec rake spec:node1:target[mysql] ## Linux
```
