Router.configure
  layoutTemplate: 'layout'
  waitOn: ->
    Meteor.subscribe("userData")

Router.route '/',
  waitOn: ->
    Meteor.subscribe('competitions', {})
  name: 'home'

Router.route 'create'

Router.route 'history',
  waitOn: ->
    Meteor.subscribe('results', {userId: Meteor.userId()})
  data: ->
    # use aggregation framework here to aggregate by compName,sorted by date?
    results: Results.find({}, {sort: {competitionName: 1, date: 1}})
#    chartData: Results.aggregate [
#      {$sort: {date: 1}},
#      { $group: { _id: "$competitionName", vals: { $push: "$values.abs"} } }
#    ]


Router.route '/competition/:_id', {
    name: 'competition'
    waitOn: ->
      [
        Meteor.subscribe('competitions', {_id: @params._id}),
        Meteor.subscribe('results', {competitionId: @params._id, userBest: true})
      ]
    data: ->
      competition: Competitions.findOne({_id: @params._id})
  }