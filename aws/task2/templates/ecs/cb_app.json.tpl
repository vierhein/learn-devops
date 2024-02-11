[
  {
    "name": "cb-app",
    "image": "${app_image}",
    "cpu": ${fargate_cpu},
    "memory": ${fargate_memory},
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": ${app_port},
        "hostPort": ${app_port}
      }
    ],
    "secrets": [
      {
        "name": "environment_secrets",
        "valueFrom": "${secret_manager_arn}"
      }
    ],
    "environment": [
      {
        "name": "variablelocal",
        "value": "value123"
      }
    ]
  }
]