Router.configure
  layoutTemplate: 'layout'
  waitOn: ->
    Meteor.subscribe("userData")

Router.route '/',
  waitOn: ->
    Meteor.subscribe('competitions', {})
  name: 'home'

Router.route '/leaderboard/:competitionName', {
    name: 'leaderboard'
    waitOn: ->
      [
        Meteor.subscribe('competitions', {name: @params.competitionName}),
        Meteor.subscribe('results', {competition: @params.competitionName, userBest: true})
      ]
    data: ->
      competition: Competitions.findOne({name: @params.competitionName})
  }