Template.addNew.helpers {
  'today': ->
    moment().format('YYYY-MM-DD')
  'addingNew': ->
    Session.equals("addingNew", true)
  'repsScheme': ->
    @competition.scheme is 'reps'
}

Template.addNew.events {
  'submit': (event) ->
    event.preventDefault()

    dateStr = event.target.date.value
    if @competition.scheme is 'reps'
      amount = {'amount': parseInt event.target.reps.value}
    else
      mins = parseInt event.target.mins.value
      secs = parseInt event.target.secs.value
      amount = {mins: mins, secs: secs}

    unless dateStr and (amount.amount or (amount.mins and amount.secs))
      FlashMessages.sendError("Please fill out date and all data fields");
      console.log dateStr
      console.log amount
      throw new Meteor.Error("Missing data")

    newResult = {
      competitionId: @competition._id,
      competitionName: @competition.name,
      userId: Meteor.userId(),
      userName: Meteor.user().profile.name,
      date: moment(dateStr).toDate()
    }
    newResult[@competition.scheme] = amount

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
  userTopResult: ->
    sortOrder = @competition.sortOrder
    if @competition.scheme is 'reps'
      sortObj = {'reps.amount': sortOrder, date: 1}
    else if @competition.scheme is 'time'
      sortObj = {'time.mins': sortOrder, 'time.secs': sortOrder, date: 1}
    Results.find(
      {},
      { sort: sortObj}
    ).map (document, index) =>
      document.index = index + 1
      if @competition.scheme is 'reps'
        document.value = document.reps.amount
      else if @competition.scheme is 'time'
        document.value = document.time.mins + ":" + document.time.secs
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
          columns: _.map Results.find({}).fetch(), (r) -> [r.userName, r.time?.totalSecs or r.reps?.amount],
          types: {
            data1: 'area',
            data2: 'area'
          }
        }
        grid: {
          y: {
            lines: [{value: Session.get('selectedSeconds'), text: Session.get('selectedName')}]
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