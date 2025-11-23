import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    url: String,
    title: String,
    text: String
  }

  share() {
    const url = this.urlValue || window.location.href
    const title = this.titleValue || 'Video Transcription'
    const text = this.textValue || 'Mira este video'

    if (navigator.share) {
      navigator.share({
        title: title,
        text: text,
        url: url
      }).catch((error) => {
        console.log('Error sharing:', error)
        this.copyToClipboard(url)
      })
    } else {
      this.copyToClipboard(url)
    }
  }

  copyToClipboard(text) {
    navigator.clipboard.writeText(text).then(() => {
      alert('URL copiada al portapapeles')
    }).catch((error) => {
      console.log('Error copying to clipboard:', error)
      // Fallback para navegadores antiguos
      const textArea = document.createElement('textarea')
      textArea.value = text
      textArea.style.position = 'fixed'
      textArea.style.opacity = '0'
      document.body.appendChild(textArea)
      textArea.select()
      try {
        document.execCommand('copy')
        alert('URL copiada al portapapeles')
      } catch (err) {
        alert('No se pudo copiar la URL. Por favor, cópiala manualmente: ' + text)
      }
      document.body.removeChild(textArea)
    })
  }
}

