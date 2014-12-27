Router.configure
  layoutTemplate: 'layout'
  waitOn: ->
    Meteor.subscribe("userData")

Router.route '/',
  waitOn: ->
    Meteor.subscribe('competitions', {})
  onBeforeAction: ->
    AccountsEntry.signInRequired(@)
    profileRequired()
  name: 'home'

Router.route 'dashboard',
  onBeforeAction: ->
    AccountsEntry.signInRequired(@)
    profileRequired()

Router.route 'create',
  onBeforeAction: ->
    AccountsEntry.signInRequired(@)
    profileRequired()

Router.route 'history',
  waitOn: ->
    Meteor.subscribe('results', {userId: Meteor.userId()})
  onBeforeAction: ->
    AccountsEntry.signInRequired(@)
    profileRequired()
  data: ->
    results: Results.find({}, {sort: {competitionName: 1, date: 1}}).fetch()

Router.route 'feed',
  waitOn: ->
    Meteor.subscribe('resultsForFeed')
  onBeforeAction: ->
    AccountsEntry.signInRequired(@)
    profileRequired()
  data: ->
    results: Results.find()

Router.route 'profile',
  onBeforeAction: ->
    AccountsEntry.signInRequired(@)

Router.route '/competition/:_id', {
    name: 'competition'
    waitOn: ->
      [
        Meteor.subscribe('competitions', {_id: @params._id}),
        Meteor.subscribe('results', {competitionId: @params._id, userBest: true})
      ]
    onBeforeAction: ->
      AccountsEntry.signInRequired(@)
      profileRequired()
    data: ->
      competition: Competitions.findOne({_id: @params._id})

  }


profileRequired = ->
  if Meteor.user() and not Meteor.user().profile?.lbs
    Router.go('profile')
    FlashMessages.sendWarning("Please fill out your profile before continuing.")