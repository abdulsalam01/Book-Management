import { Application } from "@hotwired/stimulus"
import DropdownController from "./dropdown";

const application = Application.start()

// Register the dropdown controller
application.register("dropdown", DropdownController);

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application


export { application }
