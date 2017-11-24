# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

sloan = User.create(email: 'sloan.holzman@gmail.com', password: 'password')
bob = User.create(email: 'bob@gmail.com', password: 'password')
billy = User.create(email: 'billy@gmail.com', password: 'password')
running = sloan.metrics.create(name: 'Running', unit: 'miles', target: 15, good: true, duration: 'week')
meditation = sloan.metrics.create(name: 'Meditation', unit: 'sessions', target: 6, good: true, duration: 'week')
running2 = bob.metrics.create(name: 'Running', unit: 'miles', target: 10, good: true, duration: 'week')

group = Group.create(name: 'sloanbob')
Membership.create(user: sloan, group: group, admin: true)
Membership.create(user: bob, group: group, admin: false)
Request.create(user: billy, group: group)
group2 = Group.create(name: 'private', private: true)
group3 = Group.create(name: 'public')


running.performances.create(date: Date.today, count: 5, entered: false)
running.performances.create(date: (Date.today-1), count: 0, entered: false)
running.performances.create(date: (Date.today-2), count: 3, entered: true)
running.performances.create(date: (Date.today-3), count: 4, entered: true)
running.performances.create(date: (Date.today-4), count: 1, entered: true)
running.performances.create(date: (Date.today-5), count: 1, entered: true)
running.performances.create(date: (Date.today-6), count: 0, entered: true)
running.performances.create(date: (Date.today-7), count: 0, entered: true)
running.performances.create(date: (Date.today-8), count: 2, entered: true)
running.performances.create(date: (Date.today-9), count: 1, entered: true)
running.performances.create(date: (Date.today-10), count: 2, entered: true)
running.performances.create(date: (Date.today-11), count: 1, entered: true)
running.performances.create(date: (Date.today-12), count: 5, entered: true)
running.performances.create(date: (Date.today-13), count: 8, entered: true)
running.performances.create(date: (Date.today-14), count: 5, entered: true)
running.performances.create(date: (Date.today-15), count: 1, entered: true)
running.performances.create(date: (Date.today-16), count: 5, entered: true)
running.performances.create(date: (Date.today-17), count: 5, entered: true)
running.performances.create(date: (Date.today-18), count: 5, entered: true)
running.performances.create(date: (Date.today-19), count: 5, entered: true)
running.performances.create(date: (Date.today-20), count: 5, entered: true)
running.performances.create(date: (Date.today-21), count: 5, entered: true)


meditation.performances.create(date: Date.today, count: 4, entered: true)
meditation.performances.create(date: (Date.today-1), count: 0, entered: true)
meditation.performances.create(date: (Date.today-2), count: 3, entered: true)
meditation.performances.create(date: (Date.today-3), count: 4, entered: true)
meditation.performances.create(date: (Date.today-4), count: 1, entered: true)
meditation.performances.create(date: (Date.today-5), count: 1, entered: true)
meditation.performances.create(date: (Date.today-6), count: 0, entered: true)
meditation.performances.create(date: (Date.today-7), count: 0, entered: true)
meditation.performances.create(date: (Date.today-8), count: 2, entered: true)
meditation.performances.create(date: (Date.today-9), count: 1, entered: true)
meditation.performances.create(date: (Date.today-10), count: 2, entered: true)
meditation.performances.create(date: (Date.today-11), count: 1, entered: true)
meditation.performances.create(date: (Date.today-12), count: 5, entered: true)
meditation.performances.create(date: (Date.today-13), count: 8, entered: true)
meditation.performances.create(date: (Date.today-14), count: 5, entered: true)
meditation.performances.create(date: (Date.today-15), count: 1, entered: true)
meditation.performances.create(date: (Date.today-16), count: 5, entered: true)
meditation.performances.create(date: (Date.today-17), count: 5, entered: true)
meditation.performances.create(date: (Date.today-18), count: 5, entered: true)
meditation.performances.create(date: (Date.today-19), count: 5, entered: true)
meditation.performances.create(date: (Date.today-20), count: 5, entered: true)
meditation.performances.create(date: (Date.today-21), count: 5, entered: true)

running2.performances.create(date: Date.today, count: 1, entered: false)
running2.performances.create(date: (Date.today-1), count: 0, entered: false)
running2.performances.create(date: (Date.today-2), count: 3, entered: true)
running2.performances.create(date: (Date.today-3), count: 4, entered: true)
running2.performances.create(date: (Date.today-4), count: 1, entered: true)
running2.performances.create(date: (Date.today-5), count: 1, entered: true)
running2.performances.create(date: (Date.today-6), count: 0, entered: true)
running2.performances.create(date: (Date.today-7), count: 0, entered: true)
running2.performances.create(date: (Date.today-8), count: 2, entered: true)
