terraform {
  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }

    aci = {
      source  = "netascode/aci"
      version = ">=0.2.0"
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

data "aci_rest" "aaaLoginDomain" {
  dn = "uni/userext/logindomain-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "aaaLoginDomain" {
  component = "aaaLoginDomain"

  equal "name" {
    description = "name"
    got         = data.aci_rest.aaaLoginDomain.content.name
    want        = module.main.name
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest.aaaLoginDomain.content.descr
    want        = "My Description"
  }
}

data "aci_rest" "aaaDomainAuth" {
  dn = "${data.aci_rest.aaaLoginDomain.id}/domainauth"

  depends_on = [module.main]
}

resource "test_assertions" "aaaDomainAuth" {
  component = "aaaDomainAuth"

  equal "realm" {
    description = "realm"
    got         = data.aci_rest.aaaDomainAuth.content.realm
    want        = "tacacs"
  }

  equal "providerGroup" {
    description = "providerGroup"
    got         = data.aci_rest.aaaDomainAuth.content.providerGroup
    want        = module.main.name
  }
}

data "aci_rest" "aaaTacacsPlusProviderGroup" {
  dn = "uni/userext/tacacsext/tacacsplusprovidergroup-${module.main.name}"

  depends_on = [module.main]
}

resource "test_assertions" "aaaTacacsPlusProviderGroup" {
  component = "aaaTacacsPlusProviderGroup"

  equal "name" {
    description = "name"
    got         = data.aci_rest.aaaTacacsPlusProviderGroup.content.name
    want        = module.main.name
  }
}

data "aci_rest" "aaaProviderRef" {
  dn = "${data.aci_rest.aaaTacacsPlusProviderGroup.id}/providerref-10.1.1.10"

  depends_on = [module.main]
}

resource "test_assertions" "aaaProviderRef" {
  component = "aaaProviderRef"

  equal "name" {
    description = "name"
    got         = data.aci_rest.aaaProviderRef.content.name
    want        = "10.1.1.10"
  }

  equal "order" {
    description = "order"
    got         = data.aci_rest.aaaProviderRef.content.order
    want        = "10"
  }
}
