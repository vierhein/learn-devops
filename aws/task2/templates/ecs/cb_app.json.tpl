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
        "name": "environment_var1",
        "valueFrom": "${secret_value_key1}"
      },
      {
        "name": "environment_var2",
        "valueFrom": "${secret_value_key2}"
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