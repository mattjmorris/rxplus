Meteor.startup ->
  Accounts.loginServiceConfiguration.remove {
      service: "facebook"
    }

  Accounts.loginServiceConfiguration.insert {
    service: "facebook"
#    appId: '1494763437453412'
#    secret: '6ca43a0e51b9a09165615a32e68ca02a'
    # prod:
    appId: '874064879279555'
    secret: '9f93b366e007b6fd8a70c3e29f09330c'
    loginStyle: "redirect"
  }