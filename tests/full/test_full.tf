terraform {
  required_version = ">= 1.3.0"

  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }

    aci = {
      source  = "CiscoDevNet/aci"
      version = ">=2.0.0"
    }
  }
}

module "main" {
  source = "../.."

  name        = "LOCAL1"
  description = "My Description"
  realm       = "tacacs"
  tacacs_providers = [{
    hostname_ip = "10.1.1.10"
    priority    = 10
  }]
}

data "aci_rest_managed" "aaaLoginDomain" {
  dn = "uni/userext/logindomain-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "aaaLoginDomain" {
  component = "aaaLoginDomain"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.aaaLoginDomain.content.name
    want        = module.main.name
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest_managed.aaaLoginDomain.content.descr
    want        = "My Description"
  }
}

data "aci_rest_managed" "aaaDomainAuth" {
  dn = "${data.aci_rest_managed.aaaLoginDomain.id}/domainauth"

  depends_on = [module.main]
}

resource "test_assertions" "aaaDomainAuth" {
  component = "aaaDomainAuth"

  equal "realm" {
    description = "realm"
    got         = data.aci_rest_managed.aaaDomainAuth.content.realm
    want        = "tacacs"
  }

  equal "providerGroup" {
    description = "providerGroup"
    got         = data.aci_rest_managed.aaaDomainAuth.content.providerGroup
    want        = module.main.name
  }
}

data "aci_rest_managed" "aaaTacacsPlusProviderGroup" {
  dn = "uni/userext/tacacsext/tacacsplusprovidergroup-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "aaaTacacsPlusProviderGroup" {
  component = "aaaTacacsPlusProviderGroup"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.aaaTacacsPlusProviderGroup.content.name
    want        = module.main.name
  }
}

data "aci_rest_managed" "aaaProviderRef" {
  dn = "${data.aci_rest_managed.aaaTacacsPlusProviderGroup.id}/providerref-10.1.1.10"

  depends_on = [module.main]
}

resource "test_assertions" "aaaProviderRef" {
  component = "aaaProviderRef"

  equal "name" {
    description = "name"
    got         = data.aci_rest_managed.aaaProviderRef.content.name
    want        = "10.1.1.10"
  }

  equal "order" {
    description = "order"
    got         = data.aci_rest_managed.aaaProviderRef.content.order
    want        = "10"
  }
}
