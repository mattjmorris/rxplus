Meteor.startup ->
  config = switch (process.env.ROOT_URL)
    when "http://localhost:3000/"
      { appId: '1494763437453412', secret: '6ca43a0e51b9a09165615a32e68ca02a' }
    else
      { appId: '1595681620660773', secret: '967787fe518ca14c0033918ac13fadb3' }
  config.service = "facebook"
  config.loginStyle = "redirect"

  # remove the config in case it already exists and replace it with our custom config
  Accounts.loginServiceConfiguration.remove { service: "facebook" }
  Accounts.loginServiceConfiguration.insert config
