import { Controller } from "@hotwired/stimulus"

// Dismisses a flash message when the close button is clicked.
export default class extends Controller {
  hide() {
    this.element.remove()
  }
}
