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

resource "docker_container" "containers" {
  count = length(var.container_config)

  name  = var.container_config[count.index].name
  image = var.container_config[count.index].image
  ports {
    internal = var.container_config[count.index].ports[0]
    external = var.container_config[count.index].ports[1]
  }

  memory         = var.env == "dev" ? 128 : 256
}

output "container_info" {
  value = {
    ids   = [for container in docker_container.containers : container.id]
    ports = [for container in docker_container.containers : container.ports]
  }
}
