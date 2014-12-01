Meteor.startup ->
  if Competitions.find().count() is 0
    Competitions.insert {
      name: "T2B Chained"
      description: "As many toes to bar as you can without dropping off the bar or touching your feet to the grounds"
      sortOrder: -1
      scheme: "reps"
      topMale: { userId: 'blah', userName: "Ryan VanVoorhis", value: 35 }
      topFemale: {}
    }
    Competitions.insert {
      name: "Burpies 100",
      description: "Time it takes to complete 100 burpies"
      sortOrder: 1
      scheme: "time"
      topMale: {userId: "YwcN8AqSE4L5pfDyP", userName: "Matt J. Morris", value: "6:50"}
      topFemale: {}
    }

  # todo - user selects unassigned and grabs it, and their user id is inserted into the record
  # each time insert results, see if this is the best for that athlete. If so, mark it as best, and set all others
  # for that athlete to best = false. Makes searching later easier.
  if Results.find().count() is 0
    # t2b
    Results.insert({competition: "T2B Chained", athleteName: "Matt J. Morris", value: 26, athleteBest: false, date: moment('2014-11-08').toDate()})
    Results.insert({competition: "T2B Chained", athleteName: "Matt J. Morris", value: 32, athleteBest: true, date: moment('2014-11-09').toDate()})
    Results.insert({competition: "T2B Chained", athleteName: "Ryan VanVoorhis", value: 32, athleteBest: false, date: moment('2014-11-08').toDate()})
    Results.insert({competition: "T2B Chained", athleteName: "Ryan VanVoorhis", value: 35, athleteBest: true, date: moment('2014-11-09').toDate()})
    # 100burpies
    Results.insert({competition:"Burpies 100", athleteName: "Matt J. Morris", value: "6:50", athleteBest: true, date: moment('2014-11-24').toDate()})
