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
      Results.insert({competition: @competition.name, userName: Meteor.user().profile.name, value: value, date: moment(dateStr).toDate()})
    else
      throw new Meteor.Error("Need a date and a value")

  'click #cancel': (event) ->
    event.preventDefault()
    Session.set("addingNew", false)
}

###
  Sort the results (which have been limited to just the best for each user by the router)
  and 'map' in an index so we can show position of each user's best result.
###
Template.leaderboard.helpers {
  userTopResult: ->
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