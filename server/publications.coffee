Meteor.publish 'competitions', (params) ->
  Competitions.find(params)

Meteor.publish 'results', (params) ->
  Results.find(params)

Meteor.publish 'feed', ->
  Feed.find()

Meteor.publish "userData", ->
  if (@userId)
    Meteor.users.find({_id: @userId}, {fields: {'services.facebook.gender': 1}})
  else
    @ready()

