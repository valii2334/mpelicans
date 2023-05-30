import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    latElementId: String,
    longElementId: String
  }

  connect() {
  }

  currentLocation() {
    const options = {
      enableHighAccuracy: true
    };

    const successCallback = (position) => {
      $(this.latElementIdValue).val(position.coords.latitude);
      $(this.longElementIdValue).val(position.coords.longitude);

      this.locationWasSet();
    };
      
    const errorCallback = (error) => {
      this.locationWasNotSet();
    };
    
    navigator.geolocation.getCurrentPosition(successCallback, errorCallback, options);
  }

  locationWasSet() {
    $('#location_not_set_text')[0].classList.add("d-none");
    $('#location_set_text')[0].classList.remove("d-none");
    $('#form_submit_button')[0].disabled = false
  }

  locationWasNotSet() {
    $('#location_not_set_text')[0].classList.remove("d-none");
    $('#location_set_text')[0].classList.add("d-none");
    $('#form_submit_button')[0].disabled = true
  }
}