output "bastion_fqdn" {
  description = "Bastion hostname to connect by SSH"
  value       = aws_route53_record.bastion.fqdn
}

output "bastion_ssh_user" {
  description = "Username to use when connecting by SSH to the bastion host"
  value       = module.bastion.ssh_user
}

output "bastion_security_group_id" {
  description = "The security group ID of Application Load Balancer"
  value       = module.bastion.security_group_id
}
