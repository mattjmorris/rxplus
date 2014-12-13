Meteor.methods
  historyChart: (cb) ->
    res = Results.aggregate [
      { $match: {userId: @userId} },
      { $sort: {date: 1} },
      { $group: { _id: "$competitionName", vals: { $push: "$values.abs"}, dates: { $push: "$date" } } }
    ]
    _.each res, (o) ->
#      console.log o._id
      cb(o.dates, o.vals)

#  historyChartData: ->
#    res = Results.find({userId: @userId}, {sort: {competitionName: 1, date: 1}}).fetch()
#    compsDates = {}
#    compsScores = {}
#    _.each res, (doc) =>
#      compsDates[doc.competitionName] ?= []
#      compsScores[doc.competitionName] ?= []
#      compsDates[doc.competitionName].push moment(doc.date).format('YYYY-MM-DD')
#      compsScores[doc.competitionName].push doc.values.abs
#    [compsDates, compsScores]
  hi: ->
    return 'hi'