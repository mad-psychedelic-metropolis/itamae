# [![](https://raw.githubusercontent.com/itamae-kitchen/itamae-logos/master/small/FA-Itamae-horizontal-01-180x72.png)](https://github.com/itamae-kitchen/itamae)

### ブログ構築&運用

#### 概要

- 運用監視に関わるあらゆる機能を自らの手で構築していくためのプロジェクト。
  - WordPress、監視機能、ログ転送機能、DB 冗長構成 ...etc
  - Linux と Ruby に関する知見を増やすことを目的とした。

#### 環境の準備

1. ホスト上の仮想マシンで構築したい場合、VirtualBox と Vagrant を導入する。
1. `vagrant`リポジトリより、仮想マシンを構築する準備を整える。
1. 仮想マシンに SSH でアクセスできることを確認する。

#### Itamae の準備

```
$ git clone git@gitlab.com:bay1998/hacluster-chef.git
$ asdf current ruby
ruby            3.x.x           /Users/masaya/.tool-versions
# 3.x.x以上だと問題なく動作するだろう。

$ cd itamae
$ bundle install
$ cp -i nodes/tmpplate.yml nodes/node1.yml

# 対象ホストの特性に合うように、パラメータを変更する。
$ vim node1.yml

general:
  - hostname: node1
    ip_address: 127.0.0.1
    port: 22221

user:
  - uid: 1001
    username: bay1998

# 秘匿情報を管理するファイルを作成する。
$ cp -i template.env .env
MAIN_USER_PASSWORD=(各自で設定が必要。下記参照)

$ bundle exec rake -T
rake recipe:node1:dry-run                        # Run itamae dry-run to [node1] for all p...
rake recipe:node1:recipe:dry-run[recipe,option]  # Run itamae dry-run to [node1] for an in...
rake recipe:node1:recipe:run[recipe,option]      # Run itamae run to [node1] for an indici...
rake recipe:node1:run                            # Run itamae run to [node1] for all packages
rake spec:node1                                  # Run RSpec code examples
rake spec:node1:target[spec]                     # Run serverspec run to [node1] for an in...
```

#### Itamae の実行方法

- `bundle exec rake -T`で実行したコマンドを用途ごとに使い分ける。

```
# node1にて、設定した全ての項目を実行テスト
$ bundle exec rake recipe:node1:dry-run

# node1にて、指定した項目を実行テスト
$ bundle exec rake recipe:node1:recipe:dry-run[recipe,option] ## Linux
$ bundle exec rake recipe:node1:recipe:dry-run'[recipe,option]' ## Mac

# node1にて、設定した全ての項目を実行テスト
$ bundle exec rake recipe:node1:run

# node1にて、指定した項目を実行テスト
$ bundle exec rake recipe:node1:recipe:run[recipe,option] ## Linux
$ bundle exec rake recipe:node1:recipe:run'[recipe,option]' ## Mac

recipe = [ `ls recipe` で出力される項目が対象 ]
option = [ 基本`default`。インストールだけしたい場合は、`install` ]
```

#### Serverspec の実行方法

- `bundle exec rake -T`で実行したコマンドを用途ごとに使い分ける。

```
# node1にて、設定した全ての項目をテスト
$ bundle exec rake spec:node1

# node1にて、指定した項目を実行テスト
$ bundle exec rake spec:node1:target[spec]   ## Linux
$ bundle exec rake spec:node1:target'[spec]'  ## Mac

spec = [ `ls spec` で出力される `*_spec.rb` の項目が対象 ]
```

#### .env で必要な項目

| パラメータ       | 値の説明                                                              | 備考 |
| ---------------- | --------------------------------------------------------------------- | ---- |
| USER_1_PASSWORD  | ユーザーに設定するパスワード(SHA-512 で暗号化)                        |      |
| DB_ROOT_PASSWORD | MySQL Root ユーザーに設定するパスワード                               |      |
| DB_0_PASSWORD    | MySQL ユーザー No.0(monitor/閲覧用ユーザー)に設定するパスワード       |      |
| DB_1_PASSWORD    | MySQL ユーザー No.1(wp_user/Wordpress 用ユーザー)に設定するパスワード |      |
