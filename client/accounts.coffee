Meteor.startup ->
  AccountsEntry.config
    homeRoute: '/',
    dashboardRoute: '/',
    profileRoute: '/profile',
    passwordSignupFields: 'USERNAME_AND_EMAIL',
    extraSignUpFields: [
      {
        field: 'name',
        label: 'Full Name',
        type: 'text',
        required: true
      },
      {
        field: 'gender',
        label: "Gender ('m' or 'f')",
        type: 'text',
        name: 'male',
        required: true
      },
      {
        field: 'feet',
        label: 'Your height - number of FEET (3-7)',
        type: 'number',
        required: true
      },
      {
        field: 'inches',
        label: 'Your height - number of INCHES (0-11)',
        type: 'number',
        max: 11
        required: true
      },
      {
        field: 'lbs',
        label: 'Your weight, in lbs',
        type: 'number',
        required: true
      },
      {
        field: 'birthdate',
        label: 'Your birthdate',
        type: 'date',
        required: true
      }
    ]
