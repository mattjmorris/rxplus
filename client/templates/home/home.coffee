Template.home.helpers {
  competitions: ->
    Competitions.find({}, {sort: {title: 1}})
}