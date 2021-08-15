# sql_puzzle for MySQL

ジョー・セルコ『SQLパズル 第2版』（翔泳社, 2007）を MySQLで遊んでいます。
[書籍サポートページ](http://mickindex.sakura.ne.jp/database/db_support_sqlpuzzle.html)

MySQL 8.x を推奨。（CHECK関数などが MySQL 5.x系では対応していないため）
## Usage

### ローカルに8系のSQLがない場合、以下のコンテナを実行すると使えると思います。ローカルに8系がある人は以下のセットアップは不要
コンテナのビルドと実行 
```
docker compose build
docker compose up -d
```

コンテナのmysqlコマンドがうまく実行されない場合
```
mysql.server stop # 他のmysqlがローカルで干渉する場合
brew services stop mysql@5.7 # Homebrewで立ち上げている場合はこちら
```

### ファイルの実行
```
mysql -h 127.0.0.1 < <sqlfile>
```
