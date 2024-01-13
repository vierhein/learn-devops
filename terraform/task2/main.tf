terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.15.0"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

module "docker_containers" {
  source             = "./modules/docker-container"
  container_config   = var.container_config
  env                = var.env
}

output "container_info" {
    value = "${module.docker_containers.container_info}"
}
