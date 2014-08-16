Router.map ->
  @route "entrySignIn",
    path: "/sign-in"
    onBeforeAction: ->
      Session.set "entryError", undefined
      Session.set "buttonText", "in"
      Session.set "fromWhere", Router.current().path

    onRun: ->
      pkgRendered = undefined
      userRendered = undefined
      Router.go AccountsEntry.settings.dashboardRoute  if Meteor.userId()
      if AccountsEntry.settings.signInTemplate
        @template = AccountsEntry.settings.signInTemplate
        pkgRendered = Template.entrySignIn.rendered
        userRendered = Template[@template].rendered
        if userRendered
          Template[@template].rendered = ->
            pkgRendered.call this
            userRendered.call this
        else
          Template[@template].rendered = pkgRendered
        Template[@template].events AccountsEntry.entrySignInEvents
        Template[@template].helpers AccountsEntry.entrySignInHelpers

  @route "entrySignUp",
    path: "/sign-up"
    onBeforeAction: ->
      Session.set "entryError", undefined
      Session.set "buttonText", "up"

    onRun: ->
      pkgRendered = undefined
      userRendered = undefined
      if AccountsEntry.settings.signUpTemplate
        @template = AccountsEntry.settings.signUpTemplate
        @layoutTemplate = noSidebarLayout
        pkgRendered = Template.entrySignUp.rendered
        userRendered = Template[@template].rendered
        if userRendered
          Template[@template].rendered = ->
            pkgRendered.call this
            userRendered.call this
        else
          Template[@template].rendered = pkgRendered
        Template[@template].events AccountsEntry.entrySignUpEvents
        Template[@template].helpers AccountsEntry.entrySignUpHelpers

  @route "entryForgotPassword",
    path: "/forgot-password"
    onBeforeAction: ->
      Session.set "entryError", undefined

  @route "entrySignOut",
    path: "/sign-out"
    onBeforeAction: (pause) ->
      Session.set "entryError", undefined
      if AccountsEntry.settings.homeRoute
        Meteor.logout ->
          Router.go AccountsEntry.settings.homeRoute

      pause()

  @route "entryResetPassword",
    path: "reset-password/:resetToken"
    onBeforeAction: ->
      Session.set "entryError", undefined
      Session.set "resetToken", @params.resetToken
