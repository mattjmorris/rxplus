Template.layout.helpers
  'userIsMattMorris': ->
    Meteor.user().profile.name is 'Matt J. Morris'