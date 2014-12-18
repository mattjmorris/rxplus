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
    Meteor.subscribe('resultsForFeed')
  data: ->
    results: Results.find()

Router.route 'profile'

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