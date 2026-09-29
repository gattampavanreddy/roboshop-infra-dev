module "component" {
    source = "git::https://github.com/gattampavanreddy/terraform-roboshop-component.git?ref=main" 
    component = each.key
    rule_priority = each.value.rule_priority
}

