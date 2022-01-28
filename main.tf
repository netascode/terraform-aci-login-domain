resource "aci_rest_managed" "aaaLoginDomain" {
  dn         = "uni/userext/logindomain-${var.name}"
  class_name = "aaaLoginDomain"
  content = {
    name  = var.name
    descr = var.description
  }
}

resource "aci_rest_managed" "aaaDomainAuth" {
  dn         = "${aci_rest_managed.aaaLoginDomain.dn}/domainauth"
  class_name = "aaaDomainAuth"
  content = {
    realm         = var.realm
    providerGroup = var.realm == "tacacs" ? var.name : null
  }
}

resource "aci_rest_managed" "aaaTacacsPlusProviderGroup" {
  count      = var.realm == "tacacs" ? 1 : 0
  dn         = "uni/userext/tacacsext/tacacsplusprovidergroup-${var.name}"
  class_name = "aaaTacacsPlusProviderGroup"
  content = {
    name = var.name
  }
}

resource "aci_rest_managed" "aaaProviderRef" {
  for_each   = { for prov in var.tacacs_providers : prov.hostname_ip => prov if var.realm == "tacacs" }
  dn         = "${aci_rest_managed.aaaTacacsPlusProviderGroup[0].dn}/providerref-${each.value.hostname_ip}"
  class_name = "aaaProviderRef"
  content = {
    name  = each.value.hostname_ip
    order = each.value.priority
  }
}
