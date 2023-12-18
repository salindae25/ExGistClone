// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.

import { Socket } from "phoenix"
import { LiveSocket } from "phoenix_live_view"
import topbar from "../vendor/topbar"


let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")

if (hljs.initLineNumbersOnLoad) {
    hljs.initLineNumbersOnLoad();
}
let Hooks = {}
Hooks.HighlightText = {
    mounted() {
        console.log(this.el.id);
        const name = this.el.getAttribute("data-name")
        const highlightedCodeArea = document.querySelector(`#${this.el.id} pre code`)
        if (name && highlightedCodeArea) {
            highlightedCodeArea.className = highlightedCodeArea.className.replace(/language-\S+/g, "")
            highlightedCodeArea.classList.add(`language-${this.getSyntaxType(name)}`)
            hljs.highlightElement(highlightedCodeArea)
            if (hljs.initLineNumbersOnLoad) {
                hljs.initLineNumbersOnLoad();
            }
        }
    },
    getSyntaxType(name) {
        const extension = name ? name.split('.').pop() : 'ex'
        switch (extension) {
            case 'txt':
                return "text"
                break;
            case 'html':
                return "html"
                break;
            case 'heex':
                return "html"
                break;
            case "json":
                return "json"
                break
            case "css":
                return "css"
            case 'js':
                return "javascript"
                break;
            case "ex":
                return "elixir"
            default:
                return "elixir"
                break;
        }
    }
}
Hooks.UpdateLineNumber = {
    mounted() {

        const lineNumberElement = document.querySelector("#line-number")
        this.el.addEventListener("input", () => {
            this.updateLineNumber(this.el.value)
        })
        this.el.addEventListener("scroll", () => {
            if (!lineNumberElement) return;
            lineNumberElement.scrollTop = this.el.scrollTop
        })
        this.el.addEventListener("keydown", (e) => {
            if (e.key === 'Tab') {
                e.preventDefault();
                insertTabCharacter(this.el)
            }
        })
        this.handleEvent("clear-textarea", () => {
            this.el.value = ""
            if (!lineNumberElement) return;
            lineNumberElement.textContent = "1\n"
        })

        this.updateLineNumber(this.el.value)
    },
    updateLineNumber(value) {
        const lineNumberElement = document.querySelector("#line-number")
        if (!lineNumberElement) return;

        const lines = value.split('\n')
        lineNumberElement.textContent = lines.map((x, i) => `${i + 1}`).join('\n')
    }
}
let liveSocket = new LiveSocket("/live", Socket, { params: { _csrf_token: csrfToken }, hooks: Hooks })

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" })
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

function insertTabCharacter(elem) {
    const { value, selectionStart, selectionEnd } = elem;

    // Insert tab character
    elem.value = `${value.substring(0, selectionEnd)}\t${value.substring(selectionEnd)}`;

    // Move cursor to new position
    elem.selectionStart = elem.selectionEnd = selectionEnd + 1;
}