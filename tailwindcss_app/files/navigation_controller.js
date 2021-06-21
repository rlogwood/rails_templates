import { Controller } from "stimulus"

/* Note: the click action on a link href causes a new request and reinitialization of the controller
 * therefore it looks like data-action="navigation#hide" *is not needed* on these elements
 */

export default class extends Controller {
    static targets = [ "menu" ]

    initialize() {
        this.showingMenu = false
    }

    connect() {
        // TODO: remove the logging once testing complete
        console.log("navigation controller started!")
    }

    show() {
        console.log("showing menu")
        this.menuTarget.classList.remove("hidden")
        this.showingMenu = true
    }

    hide() {
        console.log("showing menu")
        this.menuTarget.classList.add("hidden")
        this.showingMenu = false
    }

    toggle() {
        this.showingMenu ? this.hide() : this.show()
    }

}
