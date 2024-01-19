container_config = [
  {
    name  = "container1"
    image = "nginx:latest"
    ports = [80, 80]
  },
  {
    name  = "container2"
    image = "tomcat:latest"
    ports = [8080, 8080]
  }
]

