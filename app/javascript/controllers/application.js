import { Application } from "@hotwired/stimulus"
import Clipboard from "stimulus-clipboard"
import Notification from "stimulus-notification";
import ScrollIntoView from "./scroll_into_view_controller";

const application = Application.start()

application.register("clipboard", Clipboard)
application.register("notification", Notification)
application.register("scroll-into-view", ScrollIntoView)

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }
