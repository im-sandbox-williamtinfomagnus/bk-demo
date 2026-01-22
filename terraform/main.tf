terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

resource "docker_image" "java_runtime" {
  name = "eclipse-temurin:25-jre"
}

resource "docker_container" "java_web" {
  name  = "java-web-demo"
  image = docker_image.java_runtime.image_id

  ports {
    internal = 8080
    external = 8080
  }

  command = [
    "java",
    "-jar",
    "/app/app.jar"
  ]

  volumes {
    host_path      = "C:/Users/willi/projects/work/karnataka-bank/app/build/libs"
    container_path = "/app"
  }
}
