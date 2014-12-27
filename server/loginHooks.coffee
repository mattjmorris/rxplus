#Accounts.onLogin (aio) ->
#  console.log aio.user
#  unless aio.user.profile.weight
#    Router.go('profile')
#    try
#      FlashMessages.sendWarning("Please fill out your profile")
#    catch error
#      console.log "Non-critical error: ", error