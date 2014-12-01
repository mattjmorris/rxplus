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
