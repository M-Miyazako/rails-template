#!/bin/sh

# バージョンの指定
# - https://hub.docker.com/_/ruby
RUBY_VERSION=2.6.1
# - https://rubygems.org/gems/rails/versions
RAILS_VERSION=5.2.2
# - https://hub.docker.com/_/mysql
MYSQL_VERSION=5.7



# スクリプトの初期設定
export LANG=C.UTF-8
cd $(dirname $0)

# インストール済みかどうか
if [ -d app ]; then
    # Dockerの起動
    docker-compose up -d

    # Railsへアクセス
    open "http://localhost:3000"

    exit 0
fi

# プロジェクトの初期設定
PROJECT_NAME=`basename $(pwd)`
find . -type f -not -name `basename $0` | \
    xargs sed -i "" \
        -e "s/PROJECT_NAME/$PROJECT_NAME/g"

# Gemfileの初期化
echo "source 'https://rubygems.org'\ngem 'rails', '$RAILS_VERSION'" >Gemfile
echo "" >Gemfile.lock

# Dockerfileの設定
sed -i "" \
    -e "s/RUBY_VERSION/$RUBY_VERSION/" \
    Dockerfile

# docker-composeの設定
sed -i "" \
    -e "s/MYSQL_VERSION/$MYSQL_VERSION/" \
    docker-compose.yml

# Railsの初期化
docker-compose run --rm web rails new . \
    --force --database=mysql --skip-bundle

# 最新の.gitignoreをダウンロード
curl https://raw.githubusercontent.com/github/gitignore/master/Rails.gitignore \
    -o .gitignore

# .gitignoreに追記
cat <<EOF >>.gitignore


# Ignore installed files
install.sh
/db/volumes
EOF

# Gemfileの設定
sed -i "" \
    -e "s/# gem 'mini_racer'/gem 'mini_racer'/" \
    Gemfile

# Dockerのビルド
docker-compose build

# Databaseの設定
sed -i "" \
    -e "s/password:$/password: <%= ENV['MYSQL_ROOT_PASSWORD'] %>/" \
    -e "s/host: localhost/host: db/" \
    config/database.yml

# Dockerの起動
docker-compose up -d

# Databaseの作成
docker-compose run --rm web rake db:create

# 不要になった古いイメージを削除
docker rmi -f `docker images -q -f dangling=true`

# Railsへアクセス
open "http://localhost:3000"
