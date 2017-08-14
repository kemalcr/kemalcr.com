---
layout: doc
title: "Database Connection"
order: 13
---

Kemal is `Database Agnostic`. It doesn't enforce any database and / or libraries.

However, here are some suggested libraries that you can use

- [crystal-db](https://github.com/crystal-lang/crystal-db): Common DB API for Crystal. Supports PostgreSQL, MySQL and SQLite.
- [crecto](https://github.com/fridgerator/crecto): Database wrapper for Crystal, inspired by Ecto.
- [topaz](https://github.com/topaz-crystal/topaz): A simple and useful db wrapper.

Please check the relevant repo for samples and more info.

### Using Crystal DB with Kemal
To use `crystal-db` with Kemal you will need to make sure it's included in your shard as well as the [compatible driver](https://github.com/crystal-lang/crystal-db#crystal-db) (i.e. mysql, sqlite, pg...)

#### Using Kemal with MySQL
```ruby
require "kemal"
require "db"
require "mysql"

# Open a connection to MySQL
MYSQL = DB.open("mysql://root@localhost:3306/my_db")
at_exit { MYSQL.close } # Be sure to close the connection

get "/posts/:id" do |env|
  title = MYSQL.query_one?("SELECT title FROM posts WHERE id = ?", env.params.url["id"], as: {String})
  "Loaded post #{title}"
end
```

#### Using Kemal with PostgreSQL
```ruby
require "kemal"
require "db"
require "pg"

# Open a connection to PostgreSQL
PG = DB.open("postgres://root@localhost:5432/my_db?max_pool_size=10&retry_attempts=3")
at_exit { PG.close }

patch "/posts/:id" do |env|
  PG.exec "UPDATE posts SET content = $1 WHERE id = $2", env.params.body["content"], env.params.url["id"]
end
```

**NOTE:** According to [these docs](https://crystal-lang.org/docs/database/#exec) use `?` for placeholders in mysql or sqlite, but `$1` for placeholders in pg.

#### Using Kemal with SQLite3
```ruby
require "kemal"
require "db"
require "sqlite3"

# Open a connection to SQLite3
SQLITE = DB.open("sqlite3:./path/to/file.db")
at_exit { SQLITE.close }

post "/posts" do |env|
  args = [] of DB::Any
  args << env.params.body["title"].as(String)
  args << env.params.body["content"].as(String)
  SQLITE.exec "INSET INTO posts VALUES (?, ?)", args
end
```

**NOTE:** You will need to read up on the indiviual documentation for the driver you want to use. Here are the docs for [crystal-db](https://crystal-lang.org/docs/database/).
