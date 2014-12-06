Template.addNew.helpers {
  'today': ->
    moment().format('YYYY-MM-DD')
  'repsScheme': ->
    @competition.scheme is 'reps'
}

Template.addNew.events {
  'submit': (event) ->
    event.preventDefault()

    dateStr = event.target.date.value
    if @competition.scheme is 'reps'
      data = {reps: parseInt event.target.reps.value}
    else
      mins = parseInt event.target.mins.value
      secs = parseInt event.target.secs.value
      data = {mins: mins, secs: secs}

    unless dateStr? and (data.reps? or (data.mins? and data.secs?))
      FlashMessages.sendError("Please fill out date and all data fields");
      console.log dateStr
      console.log data
      throw new Meteor.Error("Missing data")

    newResult = {
      competitionId: @competition._id,
      competitionName: @competition.name,
      userId: Meteor.userId(),
      userName: Meteor.user().profile.name,
      date: moment(dateStr).toDate()
      values: {data: data}
    }
    Results.insert newResult
    Session.set("addingNew", false)

  'click #cancel': (event) ->
    event.preventDefault()
    Session.set("addingNew", false)
}

###
  Sort the results (which have been limited to just the best for each user by the router)
  and 'map' in an index so we can show position of each user's best result.
###
Template.competition.helpers {
  'addingNew': ->
    Session.equals("addingNew", true)
}

Template.results.helpers {
  userTopResult: ->
    #    debugger
    Results.find(
      {},
      { sort: {'values.abs': @competition.sortOrder, data: 1 } }
    ).map (document, index) =>
      document.index = index + 1
      document
}

# TODO - use proper form event for meteorjs
Template.competition.events {
  'click #add-new': ->
    Session.set("addingNew", true)
}

Template.chart_cp_overview.created = ->
  _.defer =>
    Tracker.autorun =>
      chart = c3.generate {
        size: {
          height: 100
        },
        data: {
          columns: _.map Results.find({}).fetch(), (r) -> [r.userName, r.values.abs],
          types: {
            data1: 'area',
            data2: 'area'
          }
        }
        grid: {
          y: {
            lines: [{value: Results.findOne({userId: Meteor.userId()})?.values?.abs, text: Meteor.user()?.profile?.name}]
          }
        }
        axis: {
          rotated: true,
          x: {
            tick: {
              values: []
            }
          }
          y: {
            tick: {
              format: (x) ->
                if Math.round(x * 100) / 100 is Math.floor(x) then Math.round(x) else ''
            }
            label: if Competitions.findOne().scheme is 'reps' then 'reps' else 'total seconds'
          }
        }
        legend: {
          show: false
        },
        tooltip: {
          grouped: false
        }
      }