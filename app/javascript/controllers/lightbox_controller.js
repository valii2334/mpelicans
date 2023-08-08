import { Controller } from "@hotwired/stimulus"
import Lightbox from 'bs5-lightbox';

export default class extends Controller {
  connect() {
    const options = {
      keyboard: true,
      size: 'lg'
    };
    
    document.querySelectorAll('.lightbox-image').forEach((el) => el.addEventListener('click', (e) => {
      e.preventDefault();
      const lightbox = new Lightbox(el, options);
      lightbox.show();
    }));
  }
}
