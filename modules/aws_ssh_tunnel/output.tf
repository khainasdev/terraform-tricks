output "ssh_command" {
  value = "ssh -i /path/to/bastion-key.pem ec2-user@${local.bastion_domain}"
}
