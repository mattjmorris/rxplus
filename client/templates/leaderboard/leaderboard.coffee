Template.addNew.helpers {
  'today': ->
    moment().format('YYYY-MM-DD')
  'addingNew': ->
    Session.equals("addingNew", true)
}

Template.addNew.events {
  'submit': (event) ->
    event.preventDefault()
    dateStr = event.target.date.value
    value = parseInt event.target.number.value
    Session.set("addingNew", false)
    if dateStr and value
      Results.insert({competition: @competition.name, athleteName: Meteor.user().profile.name, value: value, date: moment(dateStr).toDate()})
    else
      throw new Meteor.Error("Need a date and a value")

  'click #cancel': (event) ->
    event.preventDefault()
    Session.set("addingNew", false)
}

###
  Sort the results (which have been limited to just the best for each athlete by the router)
  and 'map' in an index so we can show position of each athlete's best result.
###
Template.leaderboard.helpers {
  athleteTopResult: ->
    sortOrder = @competition.sortOrder
    Results.find(
      {},
      { sort: {value: sortOrder, date: 1}}
    ).map (document, index)->
      document.index = index + 1
      document
}

# TODO - use proper form event for meteorjs
Template.leaderboard.events {
  'click #add-new': ->
    Session.set("addingNew", true)
}

#Template.history.helpers {
#  # total duplication from leaderboard template - how to DRY here?
#  selectedName: ->
#    player = Players.findOne(Session.get("selectedPlayer"))
#    player?.name
#  playerDetails: (name) ->
#    Players.find({name: name}, { sort: {date : -1, value: -1}})
#}
#
#Template.history.events {
#  'click #delete': ->
#    res = Players.findOne({_id: @_id})
#    str = "Delete?"
#    if confirm str
#      Players.remove({_id: @_id})
#}

#Template.player.helpers {
#  selected: ->
#    if Session.equals("selectedPlayer", @_id) then "selected" else ''
#}
#
#Template.player.events {
#  'click': ->
#    # already selected? unselect
#    if Session.equals("selectedPlayer", @_id)
#      Session.set("selectedPlayer", null)
#    else
#      Session.set("selectedPlayer", @_id)
#}


#UI.registerHelper 'formatDate', (context, options) ->
#  if context
#    moment(context).format('MM/DD/YYYY')
#
#UI.registerHelper 'selectedNameIsCurrentUser', ->
#  player = Players.findOne(Session.get("selectedPlayer"))
#  player?.name is Meteor.user()?.profile?.name