@Players = new Mongo.Collection("players")

if Meteor.isClient
  Template.leaderboard.helpers {
    players: ->
#     # can't use mongo distinct here so have to do ourselves
      allPlayerData = Players.find({}, { sort: {value : -1 , name: 1 }}).fetch()
      dupNames = _.map(allPlayerData, (d) -> d.name)
      output = {}
      output[dupNames[key]] = dupNames[key] for key in [0...dupNames.length]
      uniqueNames = _.values(output)
      data = []
      _.each uniqueNames, (name) =>
        data.push(Players.find( {name: name}, sort: { value : -1 } ).fetch()[0])
      data

    selectedName: ->
      player = Players.findOne(Session.get("selectedPlayer"))
      player?.name

    playerDetails: (name) ->
      Players.find({name: name}, { sort: {date : -1}})

  }
  Template.player.helpers {
    selected: ->
      if Session.equals("selectedPlayer", @_id) then "selected" else ''
  }
  Template.player.events {
    'click': ->
      Session.set("selectedPlayer", @_id)
  }

  UI.registerHelper 'formatDate', (context, options) ->
    if context
      return moment(context).format('MM/DD/YYYY');

if Meteor.isServer
  Meteor.startup( ->
    if Players.find().count() is 0
      Players.insert({name: "Matt Morris", value: 26, date: new Date('2014-11-08')})
      Players.insert({name: "Matt Morris", value: 32, date: new Date('2014-11-09')})
      Players.insert({name: "Ryan VanVoorhis", value: 32, date: new Date('2014-11-08')})
      Players.insert({name: "Ryan VanVoorhis", value: 35, date: new Date('2014-11-09')})
  )