#Meteor.startup ->
#  Meteor.loginWithFacebook {
#      requestPermissions: ['publish_actions']
#    }
#  ,
#    (err) ->
#      if (err)
#        Session.set('errorMessage', err.reason || 'Unknown error')
