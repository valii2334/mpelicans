import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    link: String,
    description: String
  }

  connect() {
    
  }

  share() {
    FB.ui(
      {
        method: 'feed',
        display: 'page',
        link: this.linkValue,
        description: this.descriptionValue
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
