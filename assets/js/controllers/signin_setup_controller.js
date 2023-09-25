import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["signin"]
  connect() {
    if (window.trooper.clerk) {
      this.setup()
    }
  }

  setup() {
    const clerk = window.trooper.clerk;
    clerk.mountSignIn(this.signinTarget)
  }
}
