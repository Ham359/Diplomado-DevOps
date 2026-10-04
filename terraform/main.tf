provider "local"{}

#1. Simular la creacion de un servidor (como si fuera EC2 AWS)

resource "local_file""servidor_produccion" {
	content="Servidor Ubuntu 24.04 - IP: 192.168.1.100"
	filename= "${path.module}/servidor_simulador.txt"
}

#2. PUENTE DE CONEXION T , crear el host.ini para ansible

resource "local_file" "generar_inventario_ansible"{
	content = <<EDF
[produccion]
localhost ansible_conecction=local

[produccion:vars]
entorno=produccion_critica
EOF
	filename="../ansible/host.ini"
#Obligando a terraform a crear el servidor PRIMERO
depends_on = [local_file.servidor_oriduccion]
}

