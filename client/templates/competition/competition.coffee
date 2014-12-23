Template.addNew.helpers {
  'now': ->
    console.log moment().format("YYYY-MM-DD") + "T" + moment().format('H:mm')
    moment().format("YYYY-MM-DD") + "T" + moment().format('H:mm')
  'repsScheme': ->
    @competition.scheme is 'reps'
  'weightScheme': ->
    @competition.scheme is 'weight'
}

Template.addNew.events {
  'submit': (event) ->
    event.preventDefault()

    valForDisplay = ""
    dateStr = event.target.date.value
    if @competition.scheme is 'reps'
      reps = parseInt event.target.reps.value
      data = {reps: reps}
      valForDisplay = reps
    else if @competition.scheme is 'weight'
      weight = parseFloat event.target.weight.value
      data = {weight: weight}
      valForDisplay = weight
    else
      mins = parseInt event.target.mins.value
      secs = parseInt event.target.secs.value
      data = {mins: mins, secs: secs}
      # add 1 ms to overcome rounding bug where 12 secs was rounded to 11
      valForDisplay = (moment.duration(mins, 'm').add(moment.duration(secs, 's')).add(moment.duration(1, 'ms'))).format("m:ss", { trim: false })

    unless dateStr? and (data.reps > 0 or data.weight > 0 or (data.mins >=0 and data.secs >= 0 and data.mins + data.secs > 0))
      FlashMessages.sendError("Please fill out date and all data fields");
      throw new Meteor.Error("Missing data")

    newResult = {
      competitionId: @competition._id,
      competitionName: @competition.name,
      userId: Meteor.userId(),
      userName: Meteor.user().profile.name,
      date: moment(dateStr).toDate()
      values: {display: valForDisplay, data: data}
    }
    Results.insert newResult
    Session.set("addingNew", false)
    FlashMessages.sendSuccess(
      "New result added for #{valForDisplay} on #{moment(dateStr).format("MM/DD/YYYY")}",
      { hideDelay: 5000 }
    )

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
            label: Competitions.findOne().scheme
          }
        }
        legend: {
          show: false
        },
        tooltip: {
          grouped: false
        }
      }

Template.registerHelper 'formatDate', (context, options) ->
  if context
    moment(context).format('MM/DD/YYYY')