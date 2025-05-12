import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="character-counter"
export default class extends Controller {
  static targets = [ "input", "counter" ]

  initialize() {
    this.count = this.countCharacters.bind(this)
  }

  connect() {
    this.inputTarget.addEventListener("keyup", this.count)
  }

  disconnect() {
    this.inputTarget.removeEventListener("keyup", this.count)
  }

  countCharacters() {
    this.counterTarget.innerHTML = this.inputTarget.value.length.toString()
  }
}
