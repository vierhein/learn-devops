module "docker_containers" {
  source             = "./modules/docker-container"
  container_config   = var.container_config
  env                = var.env
}

