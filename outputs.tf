output "dn" {
  value       = aci_rest.aaaLoginDomain.id
  description = "Distinguished name of `aaaLoginDomain` object."
}

output "name" {
  value       = aci_rest.aaaLoginDomain.content.name
  description = "Login domain name."
}
