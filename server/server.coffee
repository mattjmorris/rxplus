Meteor.startup ->
  config = switch (process.env.ROOT_URL)
    when "http://localhost:3000/"
      { appId: '1494763437453412', secret: '6ca43a0e51b9a09165615a32e68ca02a' }
    else
      { appId: '874064879279555', secret: '9f93b366e007b6fd8a70c3e29f09330c' }
  config.service = "facebook"
  config.loginStyle = "redirect"

  # remove the config in case it already exists and replace it with our custom config
  Accounts.loginServiceConfiguration.remove { service: "facebook" }
  Accounts.loginServiceConfiguration.insert config

  if Competitions.find().count() is 0
    Competitions.insert {
      title: "T2B Chained"
      description: "As many toes to bar as you can without dropping off the bar or touching your feet to the ground"
      sortOrder: 1
      scheme: "reps"
      topAthlete: "Ryan VanVoorhis"
      topResult: 35
    }
    Competitions.insert {
      title: "Burpies 100",
      description: "Time it takes to complete 100 burpies"
      sortOrder: -1
      scheme: "time"
      topAthlete: "Matt J. Morris"
      topResult: "6:50"
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
