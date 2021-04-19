# coding: utf-8

User.create!(name: "管理者",
  email: "sample@email.com",
  password: "password",
  password_confirmation: "password",
  admin: true,
  superior: false,
  work_now: false)

User.create!(name: "上長1",
  email: "sample1@email.com",
  password: "password",
  password_confirmation: "password",
  admin: true,
  superior: true,
  work_now: false)
  
User.create!(name: "上長2",
  email: "sample2@email.com",
  password: "password",
  password_confirmation: "password",
  admin: true,
  superior: true,
  work_now: false)

60.times do |n|
name  = Faker::Name.name
email = "sample-#{n+3}@email.com"
password = "password"
User.create!(name: name,
    email: email,
    password: password,
    password_confirmation: password,
    work_now: false)
end