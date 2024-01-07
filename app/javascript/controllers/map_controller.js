import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    pins: Array,
    mapid: String
  }

  connect() {
    this.initMap();
  }

  async initMap () {
    // Request needed libraries.
    const { Map, InfoWindow } = await google.maps.importLibrary("maps");
    const { AdvancedMarkerElement, PinElement } = await google.maps.importLibrary("marker");
    const { LatLng } = await google.maps.importLibrary("core");
    const map = new Map(document.getElementById(this.mapidValue), {
      mapId: "4504f8b37365c3d0"
    });

    var bounds = new google.maps.LatLngBounds();

    for (const property of this.pinsValue) {    
      const AdvancedMarkerElement = new google.maps.marker.AdvancedMarkerElement({
        map,
        position: property.position,
        title: property.title
      });

      bounds.extend(property.position);

      const infoWindow = new InfoWindow();

      AdvancedMarkerElement.addListener("click", ({ domEvent, latLng }) => {
        const { target } = domEvent;
  
        infoWindow.close();
        infoWindow.setContent(this.buildContent(property));
        infoWindow.open(AdvancedMarkerElement.map, AdvancedMarkerElement);
      });
    }

    google.maps.event.addListenerOnce(map, 'bounds_changed', function(event) {
      this.setZoom(map.getZoom()-1);

      if (this.getZoom() > 15) {
        this.setZoom(15);
      }
    });
    
    map.fitBounds(bounds);
  }

  toggleHighlight(markerView, property) {
    if (markerView.content.classList.contains("highlight")) {
      markerView.content.classList.remove("highlight");
      markerView.zIndex = null;
    } else {
      markerView.content.classList.add("highlight");
      markerView.zIndex = 1;
    }
  }

  buildContent(property) {
    const content = document.createElement("div");

    if (property.link_to_self) {
      content.innerHTML = `
      <div class="details">
        <div class="title"><b>${property.title}</b></div>
        <br>
        <a href=${property.link_to_self}>View Journey Stop</a>
        <br>
        <a target="_blank" href=${property.link_to_google_maps}>View location in Google Maps</a>
      </div>
      `;
    } else {
      content.innerHTML = `
      <div class="details">
        <div class="title"><b>${property.title}</b></div>
        <br>
        <a target="_blank" href=${property.link_to_google_maps}>View location in Google Maps</a>
      </div>
      `;
    }

    return content;
  }
}