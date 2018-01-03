# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Week.destroy_all
puts "deleted weeks"
Performance.destroy_all
puts "deleted performances"
Metric.destroy_all
puts "deleted metrics"
Request.destroy_all
puts "deleted requests"
Membership.destroy_all
puts "deleted memberships"
Invitation.destroy_all
puts "deleted invitations"
Group.destroy_all
puts "deleted groups"
User.destroy_all
puts "deleted users"

sloan = User.new(email: 'sloan.holzman@gmail.com', password: 'password', first_name: 'sloan', last_name: 'holzman', reminder_frequency: "Daily")
sloan.skip_confirmation!
sloan.save!
bob = User.new(email: 'bob@gmail.com', password: 'password', first_name: 'bob', last_name: 'johnson')
bob.skip_confirmation!
bob.save!
billy = User.new(email: 'billy@gmail.com', password: 'password', first_name: 'billy', last_name: 'johnson', reminder_day: "Monday")
billy.skip_confirmation!
billy.save!
running = sloan.metrics.create(name: 'Running', unit: 'miles', target: 15, good: true, duration: 'week', start_date: (Time.current.to_date-21), last_day_undone: (Time.current.to_date-22))
meditation = sloan.metrics.create(name: 'Meditation', unit: 'sessions', target: 6, good: true, duration: 'week', start_date: (Time.current.to_date-21), last_day_undone: (Time.current.to_date-22))
skipping = sloan.metrics.create(name: 'Skipping', unit: 'skips', target: 100, good: true, duration: 'week', start_date: (Time.current.to_date-2), last_day_undone: (Time.current.to_date-3))
smoking = sloan.metrics.create(name: 'Smoking', unit: 'cigarettes', target: 10, good: false, duration: 'week', start_date: (Time.current.to_date-10), last_day_undone: (Time.current.to_date-11))
running2 = bob.metrics.create(name: 'Running', unit: 'miles', target: 10, good: true, duration: 'week', start_date: (Time.current.to_date-8), last_day_undone: (Time.current.to_date-9))


group = Group.create(name: "Sloan's Group")
Membership.create(user: sloan, group: group, admin: true)
Membership.create(user: bob, group: group, admin: false)
Membership.create(user: billy, group: group, admin: false)
Request.create(user: billy, group: group)
group2 = Group.create(name: 'private', private: true)
group3 = Group.create(name: 'public')

skipping.performances.create(date: (Time.current.to_date-2), count: 1, entered: true)
skipping.performances.create(date: (Time.current.to_date-1), count: 10, entered: true)

smoking.performances.create(date: (Time.current.to_date), count: 1, entered: true)
smoking.performances.create(date: (Time.current.to_date-1), count: 1, entered: true)
smoking.performances.create(date: (Time.current.to_date-3), count: 1, entered: true)
smoking.performances.create(date: (Time.current.to_date-4), count: 0, entered: true)
smoking.performances.create(date: (Time.current.to_date-5), count: 5, entered: true)
smoking.performances.create(date: (Time.current.to_date-6), count: 0, entered: true)
smoking.performances.create(date: (Time.current.to_date-7), count: 2, entered: true)
smoking.performances.create(date: (Time.current.to_date-8), count: 3, entered: true)
smoking.performances.create(date: (Time.current.to_date-9), count: 1, entered: true)
smoking.performances.create(date: (Time.current.to_date-10), count: 4, entered: true)

running.performances.create(date: (Time.current.to_date), count: 0, entered: false)
running.performances.create(date: (Time.current.to_date-1), count: 0, entered: false)
running.performances.create(date: (Time.current.to_date-2), count: 2, entered: true)
running.performances.create(date: (Time.current.to_date-3), count: 1, entered: true)
running.performances.create(date: (Time.current.to_date-4), count: 4, entered: true)
running.performances.create(date: (Time.current.to_date-5), count: 1, entered: true)
running.performances.create(date: (Time.current.to_date-6), count: 0, entered: true)
running.performances.create(date: (Time.current.to_date-7), count: 2, entered: true)
running.performances.create(date: (Time.current.to_date-8), count: 3, entered: true)
running.performances.create(date: (Time.current.to_date-9), count: 1, entered: true)
running.performances.create(date: (Time.current.to_date-10), count: 4, entered: true)
running.performances.create(date: (Time.current.to_date-11), count: 1, entered: true)
running.performances.create(date: (Time.current.to_date-12), count: 2, entered: true)
running.performances.create(date: (Time.current.to_date-13), count: 8, entered: true)
running.performances.create(date: (Time.current.to_date-14), count: 1, entered: true)
running.performances.create(date: (Time.current.to_date-15), count: 1, entered: true)
running.performances.create(date: (Time.current.to_date-17), count: 5, entered: true)
running.performances.create(date: (Time.current.to_date-18), count: 0, entered: true)
running.performances.create(date: (Time.current.to_date-19), count: 0, entered: true)
running.performances.create(date: (Time.current.to_date-20), count: 0, entered: true)
running.performances.create(date: (Time.current.to_date-21), count: 5, entered: true)

meditation.performances.create(date: (Time.current.to_date), count: 1, entered: false)
meditation.performances.create(date: (Time.current.to_date-1), count: 1, entered: true)
meditation.performances.create(date: (Time.current.to_date-2), count: 0, entered: true)
meditation.performances.create(date: (Time.current.to_date-3), count: 1, entered: true)
meditation.performances.create(date: (Time.current.to_date-4), count: 1, entered: true)
meditation.performances.create(date: (Time.current.to_date-5), count: 1, entered: true)
meditation.performances.create(date: (Time.current.to_date-6), count: 1, entered: true)
meditation.performances.create(date: (Time.current.to_date-7), count: 1, entered: true)
meditation.performances.create(date: (Time.current.to_date-9), count: 1, entered: true)
meditation.performances.create(date: (Time.current.to_date-10), count: 1, entered: true)
meditation.performances.create(date: (Time.current.to_date-11), count: 1, entered: true)
meditation.performances.create(date: (Time.current.to_date-12), count: 1, entered: true)
meditation.performances.create(date: (Time.current.to_date-13), count: 1, entered: true)
meditation.performances.create(date: (Time.current.to_date-14), count: 1, entered: true)
meditation.performances.create(date: (Time.current.to_date-15), count: 1, entered: true)
meditation.performances.create(date: (Time.current.to_date-16), count: 1, entered: true)
meditation.performances.create(date: (Time.current.to_date-17), count: 1, entered: true)
meditation.performances.create(date: (Time.current.to_date-18), count: 1, entered: true)
meditation.performances.create(date: (Time.current.to_date-19), count: 1, entered: true)
meditation.performances.create(date: (Time.current.to_date-20), count: 1, entered: true)
meditation.performances.create(date: (Time.current.to_date-21), count: 1, entered: true)

running2.performances.create(date: (Time.current.to_date), count: 0, entered: false)
running2.performances.create(date: (Time.current.to_date-2), count: 3, entered: true)
running2.performances.create(date: (Time.current.to_date-3), count: 4, entered: true)
running2.performances.create(date: (Time.current.to_date-4), count: 1, entered: true)
running2.performances.create(date: (Time.current.to_date-5), count: 1, entered: true)
running2.performances.create(date: (Time.current.to_date-7), count: 0, entered: true)
running2.performances.create(date: (Time.current.to_date-8), count: 2, entered: true)

sloan.create_missing_performances
bob.create_missing_performances
billy.create_missing_performances

sloan.create_missing_weeks
bob.create_missing_weeks
billy.create_missing_weeks
