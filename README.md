# telar-saas-infrastructure

Infraestructura AWS para Telar, definida con Terraform.

## REQUISITOS OBLIGATORIOS

- Linux
- Terraform instalado
- **Ansible** instalado
- AWS CLI instalado
- **Docker** instalado y corriendo
- Node.js 22 instalado
- **Corepack** habilitado
- **pnpm** disponible mediante Corepack
- **jq** instalado
- Una cuenta AWS (**PAY AS YOU GO OBLIGATORIO**) autenticada con permisos suficientes para crear infraestructura
- Credenciales AWS configuradas por cualquier método soportado por AWS CLI, por ejemplo access keys, SSO o variables de entorno

Antes de empezar, verifica que AWS y Docker respondan:

```bash
aws sts get-caller-identity --profile iac
docker info
node --version
corepack --version
jq --version
```

Si usas otro perfil, reemplaza `iac` en los comandos y archivos de configuración.

## 1. Crear el backend remoto de Terraform

El bootstrap crea el bucket S3 que guardará el estado remoto de Terraform.

```bash
cp iac/bootstrap/tfvars.example iac/bootstrap/terraform.tfvars
```

Luego aplica el bootstrap:

```bash
terraform -chdir=iac/bootstrap init
```

```bash
terraform -chdir=iac/bootstrap apply
```

Al terminar, consulta los valores para configurar el backend:

```bash
terraform -chdir=iac/bootstrap output backend_config_
```

Copia el ejemplo del backend del entorno dev:

```bash
cp iac/environments/dev/backend.hcl.example iac/environments/dev/backend.hcl
```

Luego edita `iac/environments/dev/backend.hcl` con los valores del output.

Ejemplo:

```hcl
profile = "iac"
bucket = "nombre_del_bucket"
encrypt = true
key = "telar/dev/terraform.tfstate"
region = "us-east-1"
use_lockfile = true
```

En tu cuenta, `bucket` será el nombre real creado por bootstrap, por ejemplo:

```hcl
bucket = "telar-dev-us-east-1-0123456789--tfstate"
```

## 2. Configurar el entorno dev

Copia el archivo de variables del entorno:

```bash
cp iac/environments/dev/terraform.tfvars.example iac/environments/dev/terraform.tfvars
```

Edita `iac/environments/dev/terraform.tfvars` y ajusta los valores a tu cuenta, región y proyecto. Asegúrate de que `aws_profile` tenga el mismo nombre del perfil autenticado.

No configures `ecs_container_image` para el primer despliegue. Terraform crea el repositorio ECR, construye la imagen placeholder desde `iac/services/placeholder`, la sube al ECR de tu cuenta y usa esa imagen para que ECS pueda arrancar.

Docker debe poder ejecutarse sin problemas antes de aplicar `apply`.

## 3. Inicializar y aplicar dev

Inicializa Terraform usando el backend remoto:

```bash
terraform -chdir=iac/environments/dev init -backend-config=backend.hcl
```

Valida la configuración:

```bash
terraform -chdir=iac/environments/dev validate
```

Aplica la infraestructura:

```bash
terraform -chdir=iac/environments/dev apply
```

**Durante este `apply`, Terraform ejecuta Docker localmente para publicar la imagen placeholder en ECR. Si Docker no está corriendo, el despliegue fallará en ese paso.**
