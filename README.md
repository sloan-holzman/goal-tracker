# README

## App description
This is a goal tracking app...

This app is designed to allow users to
### 1. create an account (which requires email verification)
- uses devise to create accounts and send confirmation emails

### 2. to create goals (e.g. run 10 miles a week)
- user is required to enter the metric name (e.g. running), metric unit (e.g. miles), metric weekly target (e.g. 15 miles per week), and the start date (e.g. if you want to start tracking in the past or in the future)

### 3. enter daily performance (e.g. ran 5 miles today)
- when you create or update the start date of a metric, it automatically generates unentered performances for every since the start date.  Each day, it also autogenerates an unentered performance for each metric.  once the user enters info for the metric, it is considered entered (though they can always go back to specific day to update the info)


### 4. receive optional weekly/daily reminders to enter performance (e.g. you haven't told us how many miles you have run for)
- in the user's profile, they can decide to receive weekly (and choose the day) or daily email reminders or no reminders at all.  The reminders tell the user how many unentered performances they have (e.g. user hasn't told us how many miles they ran or how many cigarettes they smoked the last two days) on how many days they have unentered info.  It also tells them how they are doing against their weekly goals.

### 5. track progress over time (e.g. see charts on if they hit their targets over previous weeks, and see their totals each day or week)
- using the chartkick gem, the app generates daily and weekly line graphs of performance for each metric
- I also created a custom table that shows if they hit or missed their target for each metric for up to the last ten weeks

### 6. create accountability groups, where you can see how the other group members are doing against their goals.  the idea is that you can keep each other accountable
- if you create a group, you can set it as private or public.  for public groups, anybody can see their existence and request to enter (the admin of the group approves requests).  for private groups, you have to send invitations to invite people, which the recipient can accept or decline
- once you are in a group, you can see the metrics/perforamcne for all the members

### 7. create mini-competition within the groups (e.g. who can run the most miles over the next month)
- within groups, you can also create mini-competitions with a start and end date
- each competition has a metric (e.g. running) and unit (e.g miles).  if the group members are already tracking these metrics, then the competition will also just track it.  if any group members are not already tracking these metrics, the competition will automatically create it for them
- on the competition show page, there is a leaderboard to see how each user is doing (e.g. how many miles they have run so far during the time period)

## Ruby version
ruby 2.4.1p111

## Database creation
postgres db called Project-2

## Configuration
emails are sent through the email address goaltracker2000@gmail.com.  The password info is saved in application.yml, which was generated using Figaro

## How to run the test suite
no tests at the moment. will create them later

## Deployment instructions
note that on the local version, I used 'whenever' to run rake tasks at set intervals.  But, whenever does not work with heroku.  So, for heroku, I used Heroku Scheduler.  If you try to deploy to your own heroku site, you'll have to set up your own scheduler to send the reminder emails and to
