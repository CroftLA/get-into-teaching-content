resource "cloudfoundry_app" "app_application" {
    name         = var.paas_app_application_name
    space        = data.cloudfoundry_space.space.id
    docker_image = var.paas_app_docker_image
    stopped      = var.application_stopped
    strategy     = "blue-green-v2"
    memory       = 1024
    dynamic "service_binding" {
      for_each = cloudfoundry_user_provided_service.logging
      content {
        service_instance = service_binding.value["id"]
      }
    }
    routes {
        route = cloudfoundry_route.app_route.id
    }    
    environment = {
          HTTPAUTH_PASSWORD = var.HTTPAUTH_PASSWORD
          HTTPAUTH_USERNAME = var.HTTPAUTH_USERNAME
          RAILS_ENV = var.RAILS_ENV
          RAILS_MASTER_KEY = var.RAILS_MASTER_KEY
    }    
}
