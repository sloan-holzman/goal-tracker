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

sloan = User.new(reminder: true, email: 'sloan.holzman@gmail.com', password: 'password', first_name: 'sloan', last_name: 'holzman', reminder_frequency: "Daily", last_date_created: (Date.today - 8), last_date_entered: (Date.today - 8))
sloan.skip_confirmation!
sloan.save!
bob = User.new(reminder: false, email: 'sholzman@mba2015.hbs.edu', password: 'password', first_name: 'bob', last_name: 'johnson', last_date_created: Date.today, last_date_entered: Date.today)
bob.skip_confirmation!
bob.save!
billy = User.new(reminder: false, email: 'sbh2102@columbia.edu', password: 'password', first_name: 'billy', last_name: 'johnson', reminder_day: "Monday", last_date_created: Date.today, last_date_entered: Date.today)
billy.skip_confirmation!
billy.save!
running = sloan.metrics.create(name: 'Running', unit: 'miles', target: 15, good: true, duration: 'week', start_date: (Date.today-21), last_day_undone: (Date.today-22))
meditation = sloan.metrics.create(name: 'Meditation', unit: 'sessions', target: 6, good: true, duration: 'week', start_date: (Date.today-21), last_day_undone: (Date.today-22))
skipping = sloan.metrics.create(name: 'Skipping', unit: 'skips', target: 100, good: true, duration: 'week', start_date: (Date.today-2), last_day_undone: (Date.today-3))
smoking = sloan.metrics.create(name: 'Smoking', unit: 'cigarettes', target: 10, good: false, duration: 'week', start_date: (Date.today-10), last_day_undone: (Date.today-11))
running2 = bob.metrics.create(name: 'Running', unit: 'miles', target: 10, good: true, duration: 'week', start_date: (Date.today-8), last_day_undone: (Date.today-9))


group = Group.create(name: "Sloan's Group")
Membership.create(user: sloan, group: group, admin: true)
Membership.create(user: bob, group: group, admin: false)
Request.create(user: billy, group: group)
group2 = Group.create(name: 'private', private: true)
group3 = Group.create(name: 'public')
Membership.create(user: bob, group: group3, admin: true)



smoking.performances.create(date: (Date.today-8), count: 3, entered: true)
smoking.performances.create(date: (Date.today-9), count: 1, entered: true)
smoking.performances.create(date: (Date.today-10), count: 4, entered: true)


running.performances.create(date: (Date.today-8), count: 3, entered: true)
running.performances.create(date: (Date.today-9), count: 1, entered: true)
running.performances.create(date: (Date.today-10), count: 4, entered: true)
running.performances.create(date: (Date.today-11), count: 1, entered: true)
running.performances.create(date: (Date.today-12), count: 2, entered: true)
running.performances.create(date: (Date.today-13), count: 8, entered: true)
running.performances.create(date: (Date.today-14), count: 1, entered: true)
running.performances.create(date: (Date.today-15), count: 1, entered: true)
running.performances.create(date: (Date.today-17), count: 5, entered: true)
running.performances.create(date: (Date.today-18), count: 0, entered: true)
running.performances.create(date: (Date.today-19), count: 0, entered: true)
running.performances.create(date: (Date.today-20), count: 0, entered: true)
running.performances.create(date: (Date.today-21), count: 5, entered: true)

meditation.performances.create(date: (Date.today-8), count: 1, entered: true)
meditation.performances.create(date: (Date.today-9), count: 1, entered: true)
meditation.performances.create(date: (Date.today-10), count: 1, entered: true)
meditation.performances.create(date: (Date.today-11), count: 1, entered: true)
meditation.performances.create(date: (Date.today-12), count: 1, entered: true)
meditation.performances.create(date: (Date.today-13), count: 1, entered: true)
meditation.performances.create(date: (Date.today-14), count: 1, entered: true)
meditation.performances.create(date: (Date.today-15), count: 1, entered: true)
meditation.performances.create(date: (Date.today-16), count: 1, entered: true)
meditation.performances.create(date: (Date.today-17), count: 1, entered: true)
meditation.performances.create(date: (Date.today-18), count: 1, entered: true)
meditation.performances.create(date: (Date.today-19), count: 1, entered: true)
meditation.performances.create(date: (Date.today-20), count: 1, entered: true)
meditation.performances.create(date: (Date.today-21), count: 1, entered: true)

running2.performances.create(date: (Date.today-2), count: 3, entered: true)
running2.performances.create(date: (Date.today-3), count: 4, entered: true)
running2.performances.create(date: (Date.today-4), count: 1, entered: true)
running2.performances.create(date: (Date.today-5), count: 1, entered: true)
running2.performances.create(date: (Date.today-7), count: 0, entered: true)
running2.performances.create(date: (Date.today-8), count: 2, entered: true)

# sloan.seed_create_missing_performances
bob.seed_create_missing_performances
billy.seed_create_missing_performances

sloan.seed_create_missing_weeks
bob.seed_create_missing_weeks
billy.seed_create_missing_weeks
