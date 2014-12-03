Template.home.helpers {
  competitions: ->
    Competitions.find({}, {sort: {name: 1}})
  topMaleValue: ->
    if @topMale?.reps?
      @topMale.reps.amount
    else if @topMale?.time?
      @topMale.time.mins + " : " + @topMale.time.secs
    else
      "?"
  topFemaleValue: ->
    if @topFemale?.reps?
      @topFemale.reps.amount
    else if @topFemale?.time?
      @topFemale.time.mins + " : " + @topFemale.time.secs
    else
      "?"
}