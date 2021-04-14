data "azurerm_key_vault" "boundary" {
  name                = var.vault_name
  resource_group_name = var.controller_resource_group_name
}

# Create a self-signed certificate in Key Vault for workers
resource "azurerm_key_vault_certificate" "boundary" {
  name         = local.resource_group_name
  key_vault_id = data.azurerm_key_vault.boundary.id

  certificate_policy {
    issuer_parameters {
      name = "Self"
    }

    key_properties {
      exportable = true
      key_size   = 2048
      key_type   = "RSA"
      reuse_key  = true
    }

    lifetime_action {
      action {
        action_type = "AutoRenew"
      }

      trigger {
        days_before_expiry = 30
      }
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }

    x509_certificate_properties {
      # Server Authentication = 1.3.6.1.5.5.7.3.1
      # Client Authentication = 1.3.6.1.5.5.7.3.2
      extended_key_usage = ["1.3.6.1.5.5.7.3.1", "1.3.6.1.5.5.7.3.2"]

      key_usage = [
        "digitalSignature",
        "keyEncipherment",
      ]

      subject_alternative_names {
        dns_names = local.cert_san
      }

      subject            = "CN=${var.cert_cn}"
      validity_in_months = 12
    }
  }
}