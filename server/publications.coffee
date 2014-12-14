Meteor.publish 'competitions', (params) ->
  Competitions.find(params)

Meteor.publish 'results', (params) ->
  Results.find(params)

Meteor.publish "userData", ->
  if (@userId)
    Meteor.users.find({_id: @userId}, {fields: {'services.facebook.gender': 1}})
  else
    @ready()

# Returns, for the current user, [{_id: Comp1Name, dates: [date1, date2...], vals: [1, 3, ...]}, ...]
#Meteor.publish "historyChartData", ->
#  Results.aggregate [
#    { $match: {userId: @userId} },
#    { $sort: {date: 1} },
#    { $group: { _id: "$competitionName", vals: { $push: "$values.abs"}, dates: { $push: "$date" } } }
#  ]
#  _.each res, (o) ->
##      console.log o._id
#    cb(o.dates, o.vals)