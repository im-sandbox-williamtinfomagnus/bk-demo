resource "null_resource" "render_deploy" {
  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command     = "curl -X POST \"${var.render_deploy_hook}\""
  }
}