Meteor.methods
  competitionNames: ->
    Results.aggregate [
      { $match: {userId: @userId} },
      { $group: { _id: "$competitionName" } }
    ]
  historyChart: (competitionName) ->
    Results.aggregate [
      { $match: {userId: @userId, competitionName: competitionName} },
      { $sort: {date: 1} },
      { $group: { _id: "$competitionName", vals: { $push: "$values.abs"}, dates: { $push: "$date" } } }
    ]