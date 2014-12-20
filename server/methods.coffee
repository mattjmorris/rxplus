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
  # call this when server is initialized (for each competition) [Meteor.startup?] and then after any result is added
  # TODO - for now, may have to simply call this for any change. Meet with Josh to discuss more efficient way of
  # getting same result, try to improve.
#  topResults: (competitionName, gender, numResults) ->
#    comp = Competitions.findOne({name: competitionName})
#    Results.aggregate [
#      { $match: {competitionName: competitionName, gender: gender} },
#      { $sort: {'values.abs': comp.sortOrder} },
#      { $limit : numResults },
#      { $out : "authors" }
#    ]