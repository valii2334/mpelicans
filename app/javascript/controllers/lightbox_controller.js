import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const options = {
      keyboard: true,
      size: 'lg',
      constraint: true
    };
    
    document.querySelectorAll('.lightbox-image').forEach((el) => el.addEventListener('click', (e) => {
      e.preventDefault();
      const lightbox = new Lightbox(el, options);
      lightbox.show();
    }));
  }
}
