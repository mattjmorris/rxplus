Template.profile.events
  'submit form': (event, template) ->
    event.preventDefault()
    lbs = template.$('#lbs').val()
    feet = template.$('#feet').val()
    inches = template.$('#inches').val()
    birthdate = template.$('#birthdate').val()
    Meteor.users.update(
      { _id: Meteor.user()._id},
      {
        $set: {
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
  birthDateOrDefault: ->
    Meteor.user().profile.birthdate or '1981-01-01'