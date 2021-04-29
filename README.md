# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

## 開発環境

* VS-Code
* Ruby
* Rails
* Git

memo
bin/rails db:reset の代わり:

$ rm db/development.sqlite3
$ bin/rails db:setup


bin/rails db:migrate:reset の代わり:

$ rm db/development.sqlite3
$ bin/rails db:create db:migrate

このあと
rails db:seed
をする

