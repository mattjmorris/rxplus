
Template.newResultButton.events {
  'click #add-new-result': ->
    Session.set("addingNew", true)
}

Template.leaderboard.helpers {
  leaderboardResults: ->
    console.log @competition
    console.log @competition.title
    sortOrder = @competition.sortOrder

    # sort so that, in general, ties go to the one who got the result first
    allResultsForComp = Results.find({competition: @competition.title}, { sort: {value: sortOrder, date: 1}}).fetch()
    # can't use mongo distinct here so have to do ourselves
    dupNames = _.map(allResultsForComp, (d) -> d.name)

    # this is supposed to be a fast way to find distinct vals
    output = {}
    output[dupNames[key]] = dupNames[key] for key in [0...dupNames.length]
    uniqueNames = _.values(output)

    # Find best result for each athlete, sorted so that top athlete is first
    data = []
    _.each uniqueNames, (name) =>
      data.push(Results.find( {name: name}, sort: { value : -1 } ).fetch()[0])
    data

  selectedName: ->
    player = Players.findOne(Session.get("selectedPlayer"))
    player?.name
}

Template.history.helpers {
  # total duplication from leaderboard template - how to DRY here?
  selectedName: ->
    player = Players.findOne(Session.get("selectedPlayer"))
    player?.name
  playerDetails: (name) ->
    Players.find({name: name}, { sort: {date : -1, value: -1}})
}

Template.history.events {
  'click #delete': ->
    res = Players.findOne({_id: @_id})
    str = "Delete?"
    if confirm str
      Players.remove({_id: @_id})
}

Template.player.helpers {
  selected: ->
    if Session.equals("selectedPlayer", @_id) then "selected" else ''
}

Template.player.events {
  'click': ->
    # already selected? unselect
    if Session.equals("selectedPlayer", @_id)
      Session.set("selectedPlayer", null)
    else
      Session.set("selectedPlayer", @_id)
}

Template.addNew.helpers {
  'today': ->
    moment().format('YYYY-MM-DD')
  'addingNew': ->
    Session.equals("addingNew", true)
}

Template.addNew.events {
  'submit': (event) ->
    event.preventDefault()
    console.log event
    dateStr = event.target.date.value
    value = parseInt event.target.number.value
    Session.set("addingNew", false)
    if dateStr and value
      Players.insert({name: Meteor.user().profile.name, value: value, date: new Date(dateStr)})
    else
      throw new Meteor.Error("Need a date and a value")

  'click #cancel': (event) ->
    event.preventDefault()
    Session.set("addingNew", false)
}

UI.registerHelper 'formatDate', (context, options) ->
  if context
    moment(context).format('MM/DD/YYYY')

UI.registerHelper 'selectedNameIsCurrentUser', ->
  player = Players.findOne(Session.get("selectedPlayer"))
  player?.name is Meteor.user()?.profile?.name