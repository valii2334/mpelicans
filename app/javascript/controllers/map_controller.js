import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    pins: Array
  }

  connect() {
    this.initMap();
  }

  async initMap () {
    const lat = this.pinsValue[0].position.lat;
    const lng = this.pinsValue[0].position.lng;

    // Request needed libraries.
    const { Map } = await google.maps.importLibrary("maps");
    const { AdvancedMarkerElement } = await google.maps.importLibrary("marker");
    const { LatLng } = await google.maps.importLibrary("core");
    const center = new LatLng(lat, lng);
    const map = new Map(document.getElementById("map"), {
      zoom: 11,
      center,
      mapId: "4504f8b37365c3d0",
    });

    for (const property of this.pinsValue) {      
      const AdvancedMarkerElement = new google.maps.marker.AdvancedMarkerElement({
        map,
        content: this.buildContent(property),
        position: property.position,
        title: property.title,
      });
  
      AdvancedMarkerElement.addListener("click", () => {
        this.toggleHighlight(AdvancedMarkerElement, property);
      });
    }
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
  
    content.classList.add("property");

    if (property.link_to_self) {
      content.innerHTML = `
      <div class="icon">
        <i aria-hidden="true" class="fa fa-icon fa-map-pin" title="${property.title}"></i>
      </div>
      <div class="details">
        <div class="title">${property.title}</div>
        <a target="_blank" href=${property.link_to_self}>View Journey Stop</a>
        <a target="_blank" href=${property.link_to_google_maps}>View location in Google Maps</a>
      </div>
      `;
    } else {
      content.innerHTML = `
      <div class="icon">
        <i aria-hidden="true" class="fa fa-icon fa-map-pin" title="${property.title}"></i>
      </div>
      <div class="details">
        <div class="title">${property.title}</div>
        <a target="_blank" href=${property.link_to_google_maps}>View location in Google Maps</a>
      </div>
      `;
    }

    return content;
  }
}