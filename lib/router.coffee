Router.configure {
  layoutTemplate: 'layout'
}

Router.route '/',
  name: 'home'

Router.route('/leaderboard/:title', ->
  @render('leaderboard', {
    data: {
      title: @params.title
    }
  })
)