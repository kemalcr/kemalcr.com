---
layout: doc
title: "Database Connection"
order: 12
---

Kemal is `Database Agnostic`. It doesn't enforce any database and / or libraries.

However, here are some suggested libraries that you can use

- [crystal-db](https://github.com/crystal-lang/crystal-db): Common DB API for Crystal. Supports PostgreSQL, MySQL and SQLite.
- [crecto](https://github.com/fridgerator/crecto): Database wrapper for Crystal, inspired by Ecto.
- [topaz](https://github.com/topaz-crystal/topaz): A simple and useful db wrapper.
- [crystal-mysql](https://github.com/crystal-lang/crystal-mysql): A MySQL driver compatible with `crystal-db`.
- [crystal-pg](https://github.com/will/crystal-pg): A PostgreSQL driver compatible with `crystal-db`.
- [crystal-sqlite3](https://github.com/crystal-lang/crystal-sqlite3): A SQLite3 driver compatible with `crystal-db`.

Please check the relevant repo for samples and more info.

### Using Crystal DB with Kemal
To use `crystal-db` with Kemal you will need to make sure it's included in your shard as well as the compatible driver. 

```ruby
# Using MySQL with Kemal
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

**NOTE:** You will need to read up on the indiviual documentation for the driver you want to use. Here are the docs for [crystal-db](https://crystal-lang.org/docs/database/).
