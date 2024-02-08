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
    "secrets": [{
      "name": "environment_secrets",
      "valueFrom": "arn:aws:secretsmanager:eu-central-1:357197750522:secret:test-57GDMj"
    }]
  }
]