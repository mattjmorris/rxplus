Meteor.startup ->

  if Competitions.find().count() is 0
    Competitions.insert {
      name: "T2B Chained"
      description: "As many toes to bar as you can do without dropping off of the bar or touching the ground."
      sortOrder: -1
      scheme: "reps"
      topMale: { "userId": '1234', userName: "Alan Turing", reps: {amount: 35} }
      topFemale: {}
    }

    Competitions.insert {
      name: "Burpies x 100",
      description: "Time it takes to complete 100 burpies"
      sortOrder: 1
      scheme: "time"
      topMale: {"userId": "1234", userName: "Alan Turing", time: {mins: 6, secs: 52}}
      topFemale: {}
    }

    t2bId = Competitions.findOne({name: "T2B Chained"})._id
    burpiesId = Competitions.findOne({name: "Burpies x 100"})._id

#    Results.direct.insert(
#      {
#        competitionId: t2bId,
#        competitionName: "T2B Chained",
#        userId: "YwcN8AqSE4L5pfDyP",
#        userName: "Matt J. Morris",
#        value: 26,
#        userBest: false,
#        date: moment('2014-11-08').toDate()
#      })
#    Results.direct.insert({competitionId: t2bId, competitionName: "T2B Chained", userId: "YwcN8AqSE4L5pfDyP", userName: "Matt J. Morris", value: 32, userBest: true, date: moment('2014-11-09').toDate()})
    Results.direct.insert({competitionId: t2bId, competitionName: "T2B Chained", userId: "1234", userName: "Alan Turing", reps: {amount: 32}, userBest: false, date: moment('2014-11-08').toDate()})
    Results.direct.insert({competitionId: t2bId, competitionName: "T2B Chained", userId: "1234", userName: "Alan Turing", reps: {amount: 35}, userBest: true, date: moment('2014-11-09').toDate()})

    Results.direct.insert({competitionId: burpiesId, competition:"Burpies x 100", userId: "1234", userName: "Alan Turing", time: {mins: 6, secs: 52}, userBest: true, date: moment('2014-11-24').toDate()})
