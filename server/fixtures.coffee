Meteor.startup ->
  if Competitions.find().count() is 0
    Competitions.insert {
      name: "T2B Chained"
      description: "As many toes to bar as you can do without dropping off of the bar or touching the ground."
      sortOrder: -1
      scheme: "reps"
      topMale: {"userId": '1234', userName: "Alan Turing", values: {abs: 35, display: '35', data: {reps: 35}}, date: moment('2014-11-09').toDate()}
      topFemale: {}
    }

    Competitions.insert {
      name: "Burpies x 100",
      description: "Time it takes to complete 100 burpies"
      sortOrder: 1
      scheme: "time"
      topMale: {"userId": "1234", userName: "Alan Turing", values: {abs: 412, display: '6:52', data: {mins: 6, secs: 52}}, date: moment('2014-11-24').toDate()}
      topFemale: {"userId": "4321", userName: "Suzie Mae", values: {abs: 410, display: '6:50', data: {mins: 6, secs: 50}}, date: moment('2014-12-01').toDate()}
    }

    Competitions.insert {
      name: "Pushups HR2EL",
      description: "Pushups with hands raised at bottom, elbows locked at top. Body must remain straight during pushup. No rest allowed at bottom but you may rest at top."
      sortOrder: -1
      scheme: "reps"
      topMale: {}
      topFemale: {}
    }

    t2bId = Competitions.findOne({name: "T2B Chained"})._id
    burpiesId = Competitions.findOne({name: "Burpies x 100"})._id

    Results.direct.insert({competitionId: t2bId, competitionName: "T2B Chained", userId: "1234", userName: "Alan Turing", values: {abs: 23, display: '23', data: {reps: 23}}, userBest: false, competitionBest: false, date: moment('2014-10-27').toDate()})
    Results.direct.insert({competitionId: t2bId, competitionName: "T2B Chained", userId: "1234", userName: "Alan Turing", values: {abs: 30, display: '30', data: {reps: 30}}, userBest: false, competitionBest: false, date: moment('2014-11-01').toDate()})
    Results.direct.insert({competitionId: t2bId, competitionName: "T2B Chained", userId: "1234", userName: "Alan Turing", values: {abs: 35, display: '35', data: {reps: 35}}, userBest: true, competitionBest: 'male', date: moment('2014-11-09').toDate()})

    Results.direct.insert({competitionId: burpiesId, competitionName: "Burpies x 100", userId: "1234", userName: "Alan Turing", values: {abs: 412, display: '6:52', data: {mins: 6, secs: 52}}, userBest: true, competitionBest: 'male', date: moment('2014-11-24').toDate()})
    Results.direct.insert({competitionId: burpiesId, competitionName: "Burpies x 100", userId: "4321", userName: "Suzie Mae", values: {abs: 410, display: '6:50', data: {mins: 6, secs: 50}}, userBest: true, competitionBest: 'female', date: moment('2014-12-01').toDate()})
