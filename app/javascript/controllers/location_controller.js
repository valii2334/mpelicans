import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {

  }

  currentLocation() {
    const options = {
      enableHighAccuracy: true
    };

    const successCallback = (position) => {
      console.log(position);
      $('#journey_lat').val(position.coords.latitude);
      $('#journey_long').val(position.coords.longitude);

      this.locationWasSet();
    };
      
    const errorCallback = (error) => {
      console.log(error);
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