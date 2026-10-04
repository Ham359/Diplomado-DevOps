
pipeline {
	agent any

	stages {
	  stage('1. Auditoria de Codigo (Linting)'){
		steps{
		  echo 'Validando sintaxis de Terreform y Ansible...'
		  dir('terraform') { sh 'terraform validate'}
		  dir('ansible') { sh 'ansible-playbook --syntax-check playbook.yml' }

	  stage('2. Planificacion (Terreaform Plan) '){
		steps{
		  dir('terraform'){
		    sh 'terraform init'
		    sh 'terraform plan'
		}
	      }
	    }

	  stage('3. Aprobacion Manual (Gatekeeper)') {
		  steps{
			input message: '¿El terraform plan se ve correcto? Aprobar infraestructura', ok: 'Aprobar y Despues'
		}
	  }

	  stage('4.Aprovisionamiento (Terraform Apply)') {
		  steps{
		    dir('terraform') { sh 'terraform apply -auto-approve' }
		  }
	 }
	  stage('5. Configuracion Ansible') {
		  steps{
		     dir('ansible') {
		       echo 'Esperando 5 seg a que la red del servidor se estabilice'
		       sleep 5
		       sh 'ansible-playbook -i hosts.ini playbook.yml'
					}
				}
			}
		}
	}
}
