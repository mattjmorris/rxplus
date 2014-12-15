@Results = new Mongo.Collection('results')

# TODO - use check to validate doc fields
@Results.before.insert (userId, doc) ->

  # which competition is this for?
  competition = Competitions.findOne(doc.competitionId)

  doc.createdAt = moment().toDate()

  ###
    Set an absolute comparison value so we can more easily sort, even if there are multiple parts to the data.
    For time, 'absolute' comparison value will be total seconds. For reps, it is simply the number of reps.
  ###
  if competition.scheme is 'time'
    doc.values.abs = doc.values.data.mins * 60 + doc.values.data.secs
    doc.values.display = _.pad(doc.values.data.mins + "", 2, '0') + ":" + _.pad(doc.values.data.secs + "", 2, '0')
  else if competition.scheme is 'reps'
    doc.values.abs = doc.values.data.reps
    doc.values.display = doc.values.data.reps + ""
  else
    throw Meteor.Error("Unknown scheme: #{competition.scheme}")

  ###
    Is this the best result for this user, out of all of the user's results for this competition?
    Note (new.values.abs - old.values.abs) * sortOrder should always be < 0 if new one is 'better'
  ###
  userBest = true
  existingResult = Results.findOne({competitionId: doc.competitionId, userId: doc.userId, userBest: true})
  if existingResult?
    userBest = (doc.values.abs - existingResult.values.abs) * competition.sortOrder < 0
    Results.update({_id: existingResult._id}, {$set: {userBest: false}}) if userBest
  doc.userBest = userBest

  ###
    Is this the best result for the competition, for this gender?
  ###
  compBest = true
  topResultsForGender = {}
  topGenderStr = "top" + _.capitalize(Meteor.user().services.facebook.gender)
  if competition[topGenderStr]?.values?
    compBest = (doc.values.abs - competition[topGenderStr].values.abs) * competition.sortOrder < 0
  if compBest
    topResultsForGender[topGenderStr] = {userId: userId, userName: Meteor.user().profile.name, values: doc.values}
    Competitions.update({_id: competition._id}, {$set: topResultsForGender})

  try
    if userBest
      FlashMessages.sendSuccess("New PR")
    else
      FlashMessages.sendInfo("Keep working on your PR")
    if compBest
      FlashMessages.sendSuccess("New Competition Top Result")
  catch error
    console.log "error sending flash message (kind of)"
