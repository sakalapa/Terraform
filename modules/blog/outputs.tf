output "public_dns" {
  value = module.autoscaling.autoscaling_group_enabled_metrics
}

output "env_dns_name" {
  value = module.blog_alb.lb_dns_name
}