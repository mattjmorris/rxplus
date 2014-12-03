Template.create.events
  "submit form": (event) ->
    event.preventDefault()
    name = event.target.name.value
    description = event.target.description.value
    # reps or time
    measurement = event.target.optionsMeasurement.value
    # high or low
    better = event.target.optionsBetter.value

    sortOrder = if better is 'low' then 1 else -1

    unless name and description
      FlashMessages.sendError("Name and Description are required")
      throw new Meteor.Error("Need a date and a value")

    # TODO - don't allow insert if name already exists (but how to stop - probably via hook)
    Competitions.insert {
      name: name,
      description: description
      sortOrder: sortOrder
      scheme: measurement
      topMale: {}
      topFemale: {}
    }

    # Clear form
    event.target.name.value = ""
    event.target.description.value = ""

    Router.go('home')
    FlashMessages.sendSuccess("#{name} created.")
