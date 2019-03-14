Rails + MySQLプロジェクトテンプレート
====

Rails + MySQLの開発環境を構築するためのテンプレートです。

## Requirement

- docker-compose

[Docker Desktop](https://hub.docker.com/editions/community/docker-ce-desktop-mac)をインストールするのが手っ取り早いです。

## Setup

**※以下の設定は`インストール前`に行う必要があります。**

### mysql.env

MYSQLで使用するパスワードを設定することができます。

```:mysql.env
MYSQL_ROOT_PASSWORD=password
```

データベース名の指定や新規ユーザの作成を行う場合は変数を追加します。

```:mysql.env
MYSQL_ROOT_PASSWORD=password
MYSQL_DATABASE=my_database
MYSQL_USER=my_user
MYSQL_PASSWORD=my_password
```

使用可能な変数の一覧は[公式](https://hub.docker.com/_/mysql)で確認してください。

### instal.sh

インストールする環境のバージョンを指定することができます。

指定可能なバージョンは各URL先に記載されています。

```shell:install.sh
#!/bin/sh

# バージョンの指定
# - https://hub.docker.com/_/ruby
RUBY_VERSION=2.6.1
# - https://rubygems.org/gems/rails/versions
RAILS_VERSION=5.2.2
# - https://hub.docker.com/_/mysql
MYSQL_VERSION=5.7

~~~
```

## Install

任意のプロジェクトフォルダを作成し、テンプレート内の`readme.md以外の`ファイルを全てコピーします。

```
my-project ━┳━ docker-compose.yml
            ┣━ Dockerfile
            ┣━ install.sh
            ┗━ mysql.env
```

プロジェクトフォルダ内のinstall.shを実行すると開発環境がインストールされます。

```shell
$ sh install.sh
```