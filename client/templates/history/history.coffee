
#Template.registerHelper 'bestValue': (name) ->
#  Results.findOne({competitionName: name, userBest: true}).values.display

#Template.registerHelper 'bestDate': (name) ->
#  moment(Results.findOne({competitionName: name, userBest: true}).date).fromNow()

Template.history.helpers
  'competitionNames': ->
    Array::unique = ->
      output = {}
      output[@[key]] = @[key] for key in [0...@length]
      value for key, value of output
    names = []
    _.each @results, (r) ->
      names.push r.competitionName
    _.map names.unique(), (name) ->
      {name: name}
  'bestValue': (name) ->
    Results.findOne({competitionName: name, userBest: true}).values.display
  'bestDate': (name) ->
    moment(Results.findOne({competitionName: name, userBest: true}).date).fromNow()
  'nameForId': (name) ->
    name.split(" ").join("-").split("'").join("")

Template.chart.created = ->

  chart = (title, dateArray, valuesArray, scheme) ->
    dateArray = _.map dateArray, (date) ->
      moment(new Date(date)).format('YYYY-MM-DD')

    dateArray.unshift('x')
    valuesArray.unshift(title)

    c3.generate
      bindto: '#' + title.split(" ").join("-").split("'").join("")
      legend:
        show: false
      tooltip:
        show: false
      size:
        height: 150
      data:
        x: 'x'
        columns: [
          dateArray,
          valuesArray
        ]
        labels:
          format:
            y: (v, id, i, j) ->
              if scheme is 'time' then moment.duration(v, 's').format() else v
      axis:
        x:
          type: 'timeseries',
          tick:
            format: "%e %b %y"
          min:
            moment(dateArray[1]).subtract(1, 'days').toDate()
          max:
            moment(dateArray[dateArray.length - 1]).add(1, 'days').toDate()
        y:
          show: false
          padding:
            top: 20
          min: 0

  scheme = if Results.findOne({competitionName: @data.name}).values.data.mins? then 'time' else 'reps'
  Meteor.call 'historyChart', @data.name, (e, d) =>
    chart(d[0]._id, d[0].dates, d[0].vals, scheme)

Template.chart.helpers
  'nameForId': (name) ->
    name.split(" ").join("-").split("'").join("")



Template.registerHelper 'formatDate', (context, options) ->
  if context
    moment(context).format('MM/DD/YYYY')