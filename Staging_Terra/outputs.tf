output "web_server_public_ip" {
   value  = aws_instance.Web_Server.public_ip
   
 }

output "mysql_host" {
  value = aws_db_instance.financedb.address
}

output "mysql_username" {
  value = aws_db_instance.financedb.username
}

output "mysql_password" {
  value     = aws_db_instance.financedb.password
  sensitive = true
}

output "mysql_database_name" {
  value     = aws_db_instance.financedb.db_name
  sensitive = true
}

