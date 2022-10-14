// Entry point for the build script in your package.json
import "./controllers"
import * as bootstrap from "bootstrap"

import "./src/jquery"
import "./src/jquery-ui"

// AdminKit (required)
import "./modules/bootstrap";
import "./modules/sidebar";
import "./modules/theme";
import "./modules/fullscreen";
import "./modules/feather";

$(document).ready(function () {
  $('form').submit(function(){
    $(this).find(':submit').attr('disabled','disabled');
    $(this).find(':submit').val('Creating...');
  });
});
