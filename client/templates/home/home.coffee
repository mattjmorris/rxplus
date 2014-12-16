Template.home.helpers
  competitions: ->
    Competitions.find({}, {sort: {name: 1}})
  daysAgo: (date) ->
    console.log date
    moment(date).fromNow()
