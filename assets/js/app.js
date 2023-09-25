window.trooper = {}

import htmx from "htmx.org"
window.trooper.htmx = htmx

import { Application } from "@hotwired/stimulus"
window.Stimulus = Application.start()

import SigninSetupController from "./controllers/signin_setup_controller.js"
import SignupSetupController from "./controllers/signup_setup_controller.js"

Stimulus.register('signin-setup', SigninSetupController)
Stimulus.register('signup-setup', SignupSetupController)

import { initClerk } from "./clerk.js"

document.addEventListener("DOMContentLoaded", (event) => {
  initClerk()
});
