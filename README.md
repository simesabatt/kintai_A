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

t.integer "superior_confirm"        # 残業被申請者id
t.integer "over_work_allow"         # 残業許可ステータス0:なし 1:申請中 2:承認 3:否認
t.boolean "over_work_allow_check"   # 残業申請フラグ
t.integer "kintai_change_confirm"   # 勤怠被申請者id
t.integer "kintai_change_allow"     # 勤怠許可ステータス0:なし 1:申請中 2:承認 3:否認
t.boolean "kintai_change_allow_check" # 勤怠申請フラグ