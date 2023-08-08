// Entry point for the build script in your package.json
import * as bootstrap from "bootstrap";

import "./src/jquery";
import "./src/jquery-ui";
import "./src/jquery-ujs";

// AdminKit (required)
import "./modules/bootstrap";
import "./modules/sidebar";
import "./modules/theme";
import "./modules/fullscreen";
import "./modules/feather";

// Lightbox
import Lightbox from 'bs5-lightbox';
window.Lightbox = Lightbox;

// jquery-lazy
import 'jquery-lazy';
$(function() {
  $('.lazy').Lazy();
});

// File upload preview
import { FileUploadWithPreview } from 'file-upload-with-preview';
window.FileUploadWithPreview = FileUploadWithPreview;

import "./controllers"
import "trix"
import "@rails/actiontext"
