Meteor.startup ->

  if Competitions.find().count() is 0
    Competitions.insert {
      name: "T2B Chained"
      description: "As many toes to bar as you can do without dropping off of the bar or touching the ground."
      sortOrder: -1
      scheme: "reps"
      topMale: { "userId": '1234', userName: "Alan Turing", values: {abs: 35, display: '35', data: {reps: 35}} }
      topFemale: {}
    }

    Competitions.insert {
      name: "Burpies x 100",
      description: "Time it takes to complete 100 burpies"
      sortOrder: 1
      scheme: "time"
      topMale: {"userId": "1234", userName: "Alan Turing", values: {abs: 412, display:'06:52', data: {mins: 6, secs: 52}}}
      topFemale: {}
    }

    t2bId = Competitions.findOne({name: "T2B Chained"})._id
    burpiesId = Competitions.findOne({name: "Burpies x 100"})._id

    Results.direct.insert({competitionId: t2bId, competitionName: "T2B Chained", userId: "1234", userName: "Alan Turing", values: {abs: 32, display: '32', data: {reps: 32}}, userBest: false, date: moment('2014-11-08').toDate()})
    Results.direct.insert({competitionId: t2bId, competitionName: "T2B Chained", userId: "1234", userName: "Alan Turing", values: {abs: 35, display: '35', data: {reps: 35}}, userBest: true, date: moment('2014-11-09').toDate()})

    Results.direct.insert({competitionId: burpiesId, competitionName: "Burpies x 100", userId: "1234", userName: "Alan Turing", values: {abs: 412, display: '06:52', data: {mins: 6, secs: 52}}, userBest: true, date: moment('2014-11-24').toDate()})
