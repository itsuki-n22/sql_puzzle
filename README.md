# sql_puzzle

## Usage

コンテナのビルドと実行
```
docker compose build
docker compose up -d
```

mysqlコマンドがうまく実行されない場合
```
mysql.server stop # 他のmysqlがローカルで干渉する場合
brew services stop mysql@5.7 # Homebrewで立ち上げている場合はこちら
```

ファイルの実行
```
mysql -h 127.0.0.1 < <sqlfile>
```
