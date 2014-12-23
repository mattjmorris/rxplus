Meteor.publish 'competitions', (params) ->
  Competitions.find(params)

Meteor.publish 'results', (params) ->
  Results.find(params)

Meteor.publish 'resultsForFeed', ->
  Results.find({}, {sort: {date: -1}, limit: 10})

#Meteor.publish 'topNMalesResults', (N) ->
#  Results.find({gender: 'male'}, {sort: {values.abs}})

#Meteor.publish 'topNFemaleResults'

Meteor.publish "userData", ->
  if (@userId)
    Meteor.users.find({_id: @userId}, {fields: {'services.profile.gender': 1}})
  else
    @ready()

