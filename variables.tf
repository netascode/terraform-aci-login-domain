variable "name" {
  description = "Login domain name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "description" {
  description = "Description."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", var.description))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }
}

variable "realm" {
  description = "Realm. Choices: `local`, `tacacs`."
  type        = string

  validation {
    condition     = contains(["local", "tacacs"], var.realm)
    error_message = "Allowed values: `local` or`tacacs`."
  }
}

variable "tacacs_providers" {
  description = "List of TACACS providers. Allowed values `priority`: 0-16. Default value `priority`: .0"
  type = list(object({
    hostname_ip = string
    priority    = optional(number)
  }))
  default = []

  validation {
    condition = alltrue([
      for p in var.tacacs_providers : (p.priority >= 0 && p.priority <= 16)
    ])
    error_message = "`priority`: Minimum value: 0. Maximum value: 16."
  }
}
