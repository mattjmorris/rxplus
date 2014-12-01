@Results = new Mongo.Collection('results')

# TODO - use check to validate doc fields
@Results.before.insert (userId, doc) ->

  # add in user id to the document
  doc.userId = userId

  competition = Competitions.findOne({name: doc.competition})

  # add in competition id to the document
  doc.competitionId = competition._id

  # is this the best for this user?
  doc.userBest = true
  existingResult = Results.findOne({competition: doc.competition, userName: doc.userName, userBest: true})
  if existingResult?
    if competition.sortOrder is 1
      doc.userBest = false if doc.value >= existingResult.value
    else
      doc.userBest = false if doc.value <= existingResult.value
    Results.update({_id: existingResult._id}, {$set: {userBest: false}}) if doc.userBest

  # is this the best result for the competition, for this gender?
  gender = Meteor.user().services.facebook.gender
  topGenderStr = if gender is "female" then "topFemale" else "topMale"
  newBestForCompetition = true
  if competition.sortOrder is 1
    newBestForCompetition = false if doc.value >= competition[topGenderStr].value
  else
    newBestForCompetition = false if doc.value <= competition[topGenderStr].value
  if newBestForCompetition
    topResultsForGender = {}
    topResultsForGender[topGenderStr] = {userId: userId, userName: Meteor.user().profile.name, value: doc.value}
    Competitions.update({_id: competition._id}, {$set: topResultsForGender})
