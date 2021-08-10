resource "aci_rest" "aaaLoginDomain" {
  dn         = "uni/userext/logindomain-${var.name}"
  class_name = "aaaLoginDomain"
  content = {
    name  = var.name
    descr = var.description
  }
}

resource "aci_rest" "aaaDomainAuth" {
  dn         = "${aci_rest.aaaLoginDomain.id}/domainauth"
  class_name = "aaaDomainAuth"
  content = {
    realm         = var.realm
    providerGroup = var.realm == "tacacs" ? var.name : null
  }
}

resource "aci_rest" "aaaTacacsPlusProviderGroup" {
  count      = var.realm == "tacacs" ? 1 : 0
  dn         = "uni/userext/tacacsext/tacacsplusprovidergroup-${var.name}"
  class_name = "aaaTacacsPlusProviderGroup"
  content = {
    name = var.name
  }
}

resource "aci_rest" "aaaProviderRef" {
  for_each   = { for prov in var.tacacs_providers : prov.hostname_ip => prov if var.realm == "tacacs" }
  dn         = "${aci_rest.aaaTacacsPlusProviderGroup[0].id}/providerref-${each.value.hostname_ip}"
  class_name = "aaaProviderRef"
  content = {
    name  = each.value.hostname_ip
    order = each.value.priority
  }
}
