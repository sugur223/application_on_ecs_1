# Terraformのtfstateファイルから、ALBのDNS名をコンソールに出力します。

output "alb_dns_name" {
  description = "ALB DNS Name"
  value       = aws_lb.alb.dns_name
}