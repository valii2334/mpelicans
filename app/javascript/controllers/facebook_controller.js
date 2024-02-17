import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    link: String
  }

  connect() {
    
  }

  share() {
    FB.ui(
      {
        method: 'share',
        href: this.linkValue
      },
      // callback
      function(response) {
        if (response && !response.error_message) {
          alert('Posting completed.');
        } else {
          alert('Error while posting.');
        }
      }
    );
  }
}
