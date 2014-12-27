@Users = Meteor.users

#@Users.before.insert (userId, doc) ->
#  gender = 'male'
#  if _.str.startsWith(doc.profile.gender, 'f') or  _.str.startsWith(doc.profile.gender, 'F')
#    gender = 'female'
#  doc.profile.gender = gender
