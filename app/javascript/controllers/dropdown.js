import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["menu"]

  toggle() {
    this.menuTarget.classList.toggle("hidden");
  }

  close(event) {
    // Close the menu if clicked outside
    if (event.target.closest("[data-dropdown-target='menu']") === null && event.target.closest("[data-dropdown-target='button']") === null) {
      this.menuTarget.classList.add("hidden");
    }
  }

  connect() {
    // Close the dropdown if clicked outside
    window.addEventListener("click", this.close.bind(this));
  }

  disconnect() {
    // Clean up event listener
    window.removeEventListener("click", this.close.bind(this));
  }
}