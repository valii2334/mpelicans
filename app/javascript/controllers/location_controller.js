import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    latElementId: String,
    longElementId: String,
    lat: 46.769813,
    long: 23.589032
  }

  connect() {
    this.currentLocation();
    this.initMap();
  }

  async initMap() {
    const { Map, InfoWindow } = await google.maps.importLibrary("maps");
    const { AdvancedMarkerElement, PinElement } = await google.maps.importLibrary("marker");
    const { LatLng } = await google.maps.importLibrary("core");
    const { SearchBox } = await google.maps.importLibrary("places");

    const map = new google.maps.Map(document.getElementById("map"), {
      zoom: 13,
      center: { lat: this.latValue, lng: this.longValue },
    });
  
    const input = document.getElementById("pac-input");
    const searchBox = new google.maps.places.SearchBox(input);
  
    map.controls[google.maps.ControlPosition.TOP_LEFT].push(input);
    // Bias the SearchBox results towards current map's viewport.
    map.addListener("bounds_changed", () => {
      searchBox.setBounds(map.getBounds());
    });
  
    // Create an initial marker
    const marker = new google.maps.Marker({
      map: map
    });

    // Pan to current position or to default position
    map.panTo({ lat: this.latValue, lng: this.longValue});

    // On every click set marker position
    map.addListener("click", (e) => {
      this.setMarkerPositionAndPanTo(marker, e.latLng, map);
    });

    searchBox.addListener("places_changed", () => {
      const places = searchBox.getPlaces();
  
      if (places.length == 0) {
        return;
      }
  
      // For each place, get the icon, name and location.
      const bounds = new google.maps.LatLngBounds();
  
      places.forEach((place) => {
        if (!place.geometry || !place.geometry.location) {
          console.log("Returned place contains no geometry");
          return;
        }
  
        // Create a marker
        this.setMarkerPositionAndPanTo(marker, place.geometry.location, map);

        if (place.geometry.viewport) {
          // Only geocodes have viewport.
          bounds.union(place.geometry.viewport);
        } else {
          bounds.extend(place.geometry.location);
        }
      });
      map.fitBounds(bounds);
    });

    // Set initial marker on map
    this.setMarkerPositionAndPanTo(marker, { lat: this.latValue, lng: this.longValue}, map);
  }
  
  setMarkerPositionAndPanTo(marker, latLng, map) {
    marker.setPosition(latLng);
    map.panTo(latLng);

    this.setLatLngFormValues(latLng.lat, latLng.lng)
  }

  currentLocation() {
    const options = {
      enableHighAccuracy: true
    };

    const successCallback = (position) => {
      this.setLatLngFormValues(position.coords.latitude, position.coords.longitude)

      this.latValue = position.coords.latitude;
      this.longValue = position.coords.longitude;
    };
      
    const errorCallback = (error) => {
      this.locationWasNotSet();
    };
    
    navigator.geolocation.getCurrentPosition(successCallback, errorCallback, options);
  }

  locationWasSet() {
    $('#form_submit_button')[0].disabled = false
  }

  locationWasNotSet() {
    $('#form_submit_button')[0].disabled = true
  }

  setLatLngFormValues(lat, long) {
    $(this.latElementIdValue).val(lat);
    $(this.longElementIdValue).val(long);

    this.locationWasSet();
  }
}