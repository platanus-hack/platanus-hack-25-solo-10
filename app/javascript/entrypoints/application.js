// Import Turbo for Hotwire
import '@hotwired/turbo-rails'

// Import and start Stimulus
import { Application } from '@hotwired/stimulus'

const application = Application.start()
application.debug = false
window.Stimulus = application

// Auto-load all Stimulus controllers
const controllers = import.meta.glob('../controllers/**/*_controller.js', { eager: true })
Object.entries(controllers).forEach(([path, module]) => {
  const controllerName = path
    .replace('../controllers/', '')
    .replace('_controller.js', '')
    .replace(/\//g, '--')
    .replace(/_/g, '-')

  if (module.default) {
    application.register(controllerName, module.default)
  }
})
