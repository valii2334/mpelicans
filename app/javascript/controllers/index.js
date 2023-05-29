// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application"

import DocumentsController from "./documents_controller"
import LightboxController from "./lightbox_controller"

application.register("documents", DocumentsController)
application.register("lightbox", LightboxController)