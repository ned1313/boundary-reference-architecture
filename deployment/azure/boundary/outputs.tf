output "auth_method_id" {
  value = boundary_auth_method.password.id
}

output "project_scope_id" {
  value = boundary_scope.core_infra.id
}

output "target_id" {
  value = boundary_target.backend_servers_ssh.id
}