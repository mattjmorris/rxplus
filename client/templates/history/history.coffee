

Template.chart.created = ->
  chart = (dateArray, valuesArray) ->
    c3.generate {
      size: {
        height: 100
      },
      data: {
        x: 'x'
        columns: [
          dateArray.unshift('x'),
          valuesArray.unshift('data1')
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
      legend: {
        show: false
      },
      tooltip: {
        grouped: false
      }
    }

  log = (a,b) ->
    console.log a
    console.log b

#  Meteor.call('historyChart', log)

UI.registerHelper 'formatDate', (context, options) ->
  if context
    moment(context).format('MM/DD/YYYY')