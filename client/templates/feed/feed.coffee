Template.feed.helpers
  'PRText': ->
    if @userBest then 'PR of ' else ''
  'CRText': ->
    if @competitionBest? then "Competition best #{@competitionBest}" else ''
  'alertType': ->
    if @competitionBest?
      'alert-success'
    else if @userBest
      'alert-info'
    else 'alert-info'
  'showPRIcon': ->
    @userBest and not @competitionBest?
  'bestMale': ->
    @competitionBest is 'male'
  'bestFemale': ->
    @competitionBest is 'female'
  'log': ->
    console.log @

