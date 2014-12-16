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
    results: Results.find({}, {sort: {competitionName: 1, date: 1}}).fetch()

Router.route 'feed',
  waitOn: ->
    Meteor.subscribe('results', {})
  data: ->
    # TODO - make reactive with limit
    results: Results.find({}, {sort: {date: -1}})

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