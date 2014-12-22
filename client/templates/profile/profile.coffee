Template.profile.events
  'submit form': (event, template) ->
    event.preventDefault()
    name = template.$('#name').val()
    lbs = template.$('#lbs').val()
    feet = template.$('#feet').val()
    inches = template.$('#inches').val()
    birthdate = template.$('#birthdate').val()
    Meteor.users.update(
      { _id: Meteor.user()._id},
      {
        $set: {
          "profile.name": name
          "profile.lbs": lbs,
          "profile.feet": feet,
          "profile.inches": inches,
          "profile.birthdate": birthdate
        }
      },
      (e, n) ->
        FlashMessages.sendError(e) if e
        FlashMessages.sendSuccess("Your profile has been updated.")
    )


Template.profile.helpers
  userBirthdate: ->
    moment(Meteor.user().profile.birthdate).format('YYYY-MM-DD')