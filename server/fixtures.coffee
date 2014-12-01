Meteor.startup ->

  if Competitions.find().count() is 0
    Competitions.insert {
      name: "Space Apples"
      description: "Eat the apples when you see them, but avoid the nectarines."
      sortOrder: -1
      scheme: "amount"
      topMale: { "userId": '1234', userName: "Alan Turing", value: 35 }
      topFemale: {}
    }
    ,
      (error, id) ->
        console.log id

    Competitions.insert {
      name: "Water Bananas",
      description: "Time it takes to eat 100 bananas under water"
      sortOrder: 1
      scheme: "time"
      topMale: {"userId": "YwcN8AqSE4L5pfDyP", userName: "Matt J. Morris", value: "6:50"}
      topFemale: {}
    }
    ,
      (error, id) ->
        console.log id

  if Results.find().count() is 0
    Results.direct.insert({competition: "Space Apples", userId: "YwcN8AqSE4L5pfDyP", userName: "Matt J. Morris", value: 26, userBest: false, date: moment('2014-11-08').toDate()})
    Results.direct.insert({competition: "Space Apples", userId: "YwcN8AqSE4L5pfDyP", userName: "Matt J. Morris", value: 32, userBest: true, date: moment('2014-11-09').toDate()})
    Results.direct.insert({competition: "Space Apples", userId: "1234", userName: "Alan Turing", value: 32, userBest: false, date: moment('2014-11-08').toDate()})
    Results.direct.insert({competition: "Space Apples", userId: "1234", userName: "Alan Turing", value: 35, userBest: true, date: moment('2014-11-09').toDate()})

    Results.direct.insert({competition:"Water Bananas", userId: "YwcN8AqSE4L5pfDyP", userName: "Matt J. Morris", value: "6:50", userBest: true, date: moment('2014-11-24').toDate()})
