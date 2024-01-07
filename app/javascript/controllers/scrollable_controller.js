import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    window.addEventListener('load', function () {
      const params = new URLSearchParams(window.location.search);
      document.getElementById(params.get('scroll_to')).scrollIntoView(true);

      setTimeout(() => {
        document.getElementById(params.get('scroll_to')).scrollIntoView(true);
      }, "500");
    });
  }
}