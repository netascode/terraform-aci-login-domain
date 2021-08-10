<!-- BEGIN_TF_DOCS -->
[![Tests](https://github.com/netascode/terraform-aci-login-domain/actions/workflows/test.yml/badge.svg)](https://github.com/netascode/terraform-aci-login-domain/actions/workflows/test.yml)

# Terraform ACI Login Domain Module

Manages ACI Login Domain

Location in GUI:
`Admin` » `AAA` » `Authentication` » `AAA`

## Examples

```hcl
module "aci_login_domain" {
  source = "netascode/login-domain/aci"

  name        = "TACACS1"
  description = "My Description"
  realm       = "tacacs"
  tacacs_providers = [{
    hostname_ip = "10.1.1.10"
    priority    = 10
  }]
}

```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aci"></a> [aci](#requirement\_aci) | >= 0.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aci"></a> [aci](#provider\_aci) | >= 0.2.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Login domain name. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Description. | `string` | `""` | no |
| <a name="input_realm"></a> [realm](#input\_realm) | Realm. Choices: `local`, `tacacs`. | `string` | n/a | yes |
| <a name="input_tacacs_providers"></a> [tacacs\_providers](#input\_tacacs\_providers) | List of TACACS providers. Allowed values `priority`: 0-16. Default value `priority`: .0 | <pre>list(object({<br>    hostname_ip = string<br>    priority    = optional(number)<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `aaaLoginDomain` object. |
| <a name="output_name"></a> [name](#output\_name) | Login domain name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest.aaaDomainAuth](https://registry.terraform.io/providers/netascode/aci/latest/docs/resources/rest) | resource |
| [aci_rest.aaaLoginDomain](https://registry.terraform.io/providers/netascode/aci/latest/docs/resources/rest) | resource |
| [aci_rest.aaaProviderRef](https://registry.terraform.io/providers/netascode/aci/latest/docs/resources/rest) | resource |
| [aci_rest.aaaTacacsPlusProviderGroup](https://registry.terraform.io/providers/netascode/aci/latest/docs/resources/rest) | resource |
<!-- END_TF_DOCS -->