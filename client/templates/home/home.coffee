Template.home.helpers
  competitions: ->
    Competitions.find({}, {sort: {name: 1}})
