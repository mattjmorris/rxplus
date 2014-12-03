# TODO - beter, more generic way of passing in multiple vals for comparison, with potential for multiple sort order vals

@Results = new Mongo.Collection('results')

# TODO - use check to validate doc fields
@Results.before.insert (userId, doc) ->

  ###
  Takes arrays of vals and compares them based on sort order
  ASSUMPTION - sort order is same for all vals.
  ASSUMPTION - at most 2 vals per array (for now). In future, can allow any number of vals if make a recursive func
  ###
  aBetterThanB = (vals1, vals2, sortOrder) ->
    throw Meteor.Error("sortOrder can only be 1 or -1, not #{sortOrder}") unless (sortOrder is 1 or sortOrder is -1)

    better = false
    # smaller is better
    if sortOrder is 1
      if vals1[0] < vals2[0] or ( vals1[0] is vals2[0] and vals1[1] < vals2[1] )
        better = true
    else
      if vals1[0] > vals2[0] or ( vals1[0] is vals2[0] and vals1[1] > vals2[1] )
        better = true

    better

  # NOTE - changing this to not set user or competition id here so it is more flexible in what we pass in,
  # such as if want to associate various users and competitions from an admin view

  doc.createdAt = moment().toDate()

  competition = Competitions.findOne(doc.competitionId)

  # is this the best for this user?
  doc.userBest = true
  existingResult = Results.findOne({competitionId: doc.competitionId, userId: doc.userId, userBest: true})
  if existingResult?
    if competition.scheme is 'reps'
      doc.userBest = aBetterThanB([doc.reps.amount], [existingResult.reps.amount], competition.sortOrder)
    else if competition.scheme is 'time'
      doc.userBest = aBetterThanB([doc.time.mins, doc.time.secs], [existingResult.time.mins, existingResult.time.secs], competition.sortOrder)
    else
      throw new Meteor.Error "Unknown scheme: #{competition.scheme}"
    Results.update({_id: existingResult._id}, {$set: {userBest: false}}) if doc.userBest

  # is this the best result for the competition, for this gender?
  gender = Meteor.user().services.facebook.gender
  topGenderStr = if gender is "female" then "topFemale" else "topMale"
  newBestForCompetition = true
  if competition[topGenderStr]?[competition.scheme]?
    if competition.scheme is 'reps'
      newBestForCompetition = aBetterThanB([doc.reps.amount], [competition[topGenderStr].reps.amount], competition.sortOrder)
    else if competition.scheme is 'time'
      existingTime = competition[topGenderStr].time
      newBestForCompetition = aBetterThanB([doc.time.mins, doc.time.secs], [existingTime.mins, existingTime.secs], competition.sortOrder)
  if newBestForCompetition
    topResultsForGender = {}
    topResultsForGender[topGenderStr] = {userId: userId, userName: Meteor.user().profile.name}
    # copy the reps or time from the doc
    topResultsForGender[topGenderStr][competition.scheme] = doc[competition.scheme]
    Competitions.update({_id: competition._id}, {$set: topResultsForGender})


