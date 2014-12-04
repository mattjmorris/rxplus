
UI.registerHelper 'formatDate', (context, options) ->
  if context
    moment(context).format('MM/DD/YYYY')