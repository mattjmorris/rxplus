@Competitions = new Mongo.Collection('competitions')

@Competitions.before.insert (userId, doc) ->
  doc.name = _.capitalize(doc.name)
  doc.createdAt = moment().toDate()
