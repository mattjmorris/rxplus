
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

Template.chart.created = ->

  chart = (title, dateArray, valuesArray) ->
    dateArray = _.map dateArray, (date) ->
      moment(new Date(date)).format('YYYY-MM-DD')

    dateArray.unshift('x')
    valuesArray.unshift(title)

    c3.generate {
      bindto: '#' + title.split(" ").join("-").split("'").join("")
      size: {
        height: 150
      },
      data: {
        x: 'x'
        columns: [
          dateArray,
          valuesArray
        ]
      }
      axis: {
        x: {
          type: 'timeseries',
          tick: {
            format: '%Y-%m-%d'
          }
        }
      }
    }

  Meteor.call 'historyChart', @data.name, (e, d) ->
    chart(d[0]._id, d[0].dates, d[0].vals)

Template.chart.helpers
  'nameForId': (name) ->
    name.split(" ").join("-").split("'").join("")
  'bestValue': (name) ->
    Results.findOne({competitionName: name, userBest: true}).values.display
  'bestDate': (name) ->
    moment(Results.findOne({competitionName: name, userBest: true}).date).format('YYYY-MM-DD')

UI.registerHelper 'formatDate', (context, options) ->
  if context
    moment(context).format('MM/DD/YYYY')