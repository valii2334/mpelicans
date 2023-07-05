import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    latElementId: String,
    longElementId: String,
    lat: 46.769813,
    long: 23.589032
  }

  connect() {
    this.initMap();
  }

  async initMap() {
    const { Map, InfoWindow } = await google.maps.importLibrary("maps");
    const { AdvancedMarkerElement, PinElement } = await google.maps.importLibrary("marker");
    const { LatLng } = await google.maps.importLibrary("core");
    const { SearchBox } = await google.maps.importLibrary("places");

    const map = new google.maps.Map(document.getElementById("map"), {
      zoom: 18,
      center: { lat: this.latValue, lng: this.longValue },
    });
  
    const input = document.getElementById("pac-input");
    const searchBox = new google.maps.places.SearchBox(input);
  
    // map.controls[google.maps.ControlPosition.TOP_LEFT].push(input);
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
      this.setMarkerPositionAndPanTo(marker, e.latLng, map, true);
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
        this.setMarkerPositionAndPanTo(marker, place.geometry.location, map, true);

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
    this.currentLocation(map, marker);
  }
  
  setMarkerPositionAndPanTo(marker, latLng, map, locationManuallySet) {
    marker.setPosition(latLng);
    map.panTo(latLng);

    this.setLatLngFormValues(latLng.lat, latLng.lng);

    if (locationManuallySet) {
      this.locationWasSetManually();
    }
  }

  currentLocation(map, marker) {
    const options = {
      enableHighAccuracy: true
    };

    const successCallback = (position) => {
      this.setLatLngFormValues(position.coords.latitude, position.coords.longitude)
      this.setMarkerPositionAndPanTo(marker, new google.maps.LatLng(position.coords.latitude, position.coords.longitude), map, true);
    };
      
    const errorCallback = (error) => {
      this.setMarkerPositionAndPanTo(marker, new google.maps.LatLng(this.latValue, this.longValue), map, false);
    };
    
    navigator.geolocation.getCurrentPosition(successCallback, errorCallback, options);
  }

  locationWasSetManually() {
    $('#form_submit_button')[0].disabled = false
  }

  setLatLngFormValues(lat, long) {
    $(this.latElementIdValue).val(lat);
    $(this.longElementIdValue).val(long);
  }
}