# 🚀 Guia Detalhado de Instalação - Mil Páginas

Este guia fornece instruções passo a passo para configurar o projeto Mil Páginas em diferentes ambientes.

## 📋 Requisitos do Sistema

### Software Necessário
- **Java JDK 8+** (Recomendado: Java 11 ou 17)
- **MySQL 8.0+** ou **MariaDB 10.3+**
- **Apache Tomcat 9.0+** ou **10.0+**
- **IDE Java** (Eclipse, IntelliJ IDEA, NetBeans, ou VS Code)

### Especificações Mínimas
- **RAM:** 4 GB (8 GB recomendado)
- **Espaço em Disco:** 2 GB livres
- **SO:** Windows 10+, macOS 10.14+, ou Linux (Ubuntu 18.04+)

## 🔧 Instalação Passo a Passo

### 1. Instalação do Java JDK

#### Windows:
1. Baixe o JDK do [site oficial da Oracle](https://www.oracle.com/java/technologies/downloads/) ou [OpenJDK](https://openjdk.org/)
2. Execute o instalador
3. Configure a variável de ambiente `JAVA_HOME`:
   ```cmd
   setx JAVA_HOME "C:\Program Files\Java\jdk-11.0.x"
   setx PATH "%JAVA_HOME%\bin;%PATH%"
   ```

#### macOS:
```bash
# Usando Homebrew
brew install openjdk@11

# Configurar JAVA_HOME no ~/.zshrc ou ~/.bash_profile
export JAVA_HOME=$(/usr/libexec/java_home -v 11)
export PATH=$JAVA_HOME/bin:$PATH
```

#### Linux (Ubuntu/Debian):
```bash
sudo apt update
sudo apt install openjdk-11-jdk

# Verificar instalação
java -version
javac -version
```

### 2. Instalação do MySQL

#### Windows:
1. Baixe o [MySQL Community Server](https://dev.mysql.com/downloads/mysql/)
2. Execute o installer
3. Configure senha para o usuário root
4. Inicie o serviço MySQL

#### macOS:
```bash
# Usando Homebrew
brew install mysql

# Iniciar o serviço
brew services start mysql

# Configuração inicial
mysql_secure_installation
```

#### Linux (Ubuntu/Debian):
```bash
sudo apt update
sudo apt install mysql-server

# Configuração inicial
sudo mysql_secure_installation

# Iniciar o serviço
sudo systemctl start mysql
sudo systemctl enable mysql
```

### 3. Instalação do Apache Tomcat

#### Método 1: Download Manual
1. Baixe do [site oficial do Tomcat](https://tomcat.apache.org/download-90.cgi)
2. Extraia para um diretório (ex: `C:\tomcat` ou `/opt/tomcat`)
3. Configure a variável `CATALINA_HOME`:

**Windows:**
```cmd
setx CATALINA_HOME "C:\tomcat"
```

**Linux/macOS:**
```bash
export CATALINA_HOME=/opt/tomcat
export PATH=$CATALINA_HOME/bin:$PATH
```

#### Método 2: Usando Package Manager

**macOS:**
```bash
brew install tomcat
```

**Linux:**
```bash
sudo apt install tomcat9
```

### 4. Configuração do Banco de Dados

#### 4.1 Acessar MySQL
```bash
mysql -u root -p
```

#### 4.2 Criar Usuário e Banco
```sql
-- Criar usuário para a aplicação
CREATE USER 'milpaginas_user'@'localhost' IDENTIFIED BY 'milpaginas_pass123';

-- Conceder privilégios
GRANT ALL PRIVILEGES ON milpaginas.* TO 'milpaginas_user'@'localhost';
FLUSH PRIVILEGES;

-- Sair do MySQL
EXIT;
```

#### 4.3 Importar Schema
```bash
# Navegar até o diretório do projeto
cd /caminho/para/milpaginas

# Importar o banco de dados
mysql -u milpaginas_user -p < docs/sql/milpaginas_database.sql
```

### 5. Configuração do Projeto

#### 5.1 Download das Dependências

Baixe e coloque no diretório `src/main/webapp/WEB-INF/lib/`:

1. **MySQL Connector/J:**
   - [Download MySQL Connector](https://dev.mysql.com/downloads/connector/j/)
   - Arquivo: `mysql-connector-java-8.0.x.jar`

2. **Gson (para JSON):**
   - [Download Gson](https://github.com/google/gson)
   - Arquivo: `gson-2.8.x.jar`

3. **JSTL (JavaServer Pages Standard Tag Library):**
   - Baixe `jstl-1.2.jar`

#### 5.2 Configurar Conexão com Banco

Edite o arquivo `src/main/webapp/WEB-INF/db.properties`:

```properties
# Configuração do banco de dados
db.url=jdbc:mysql://localhost:3306/milpaginas?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=America/Sao_Paulo
db.username=milpaginas_user
db.password=milpaginas_pass123
db.driver=com.mysql.cj.jdbc.Driver
db.maxConnections=20

# Configurações adicionais
db.connectionTimeout=30000
db.validationQuery=SELECT 1
```

## 🛠️ Configuração da IDE

### Eclipse IDE

1. **Instalar Eclipse IDE for Enterprise Java Developers**
2. **Configurar Tomcat:**
   - Window → Preferences → Server → Runtime Environments
   - Add → Apache Tomcat v9.0
   - Selecionar diretório do Tomcat

3. **Importar Projeto:**
   - File → Import → Existing Projects into Workspace
   - Selecionar a pasta do projeto

4. **Configurar Build Path:**
   - Clique direito no projeto → Properties
   - Java Build Path → Libraries
   - Add External JARs → Adicionar JARs do `WEB-INF/lib/`

### IntelliJ IDEA

1. **Abrir Projeto:**
   - Open → Selecionar pasta do projeto

2. **Configurar Tomcat:**
   - Run → Edit Configurations
   - Add → Tomcat Server → Local
   - Configurar Application Server

3. **Configurar Dependencies:**
   - File → Project Structure → Libraries
   - Add JARs do diretório `WEB-INF/lib/`

### VS Code

1. **Instalar Extensions:**
   - Extension Pack for Java
   - Tomcat for Java

2. **Configurar:**
   - Ctrl+Shift+P → Java: Configure Classpath
   - Adicionar JARs das dependências

## 🏃 Executando a Aplicação

### Método 1: Via IDE

1. **Eclipse:**
   - Clique direito no projeto → Run As → Run on Server
   - Selecionar Tomcat Server

2. **IntelliJ:**
   - Clique no botão Run (ícone play verde)
   - Ou Shift+F10

### Método 2: Via Linha de Comando

1. **Compilar o projeto:**
```bash
# Navegar até o diretório do projeto
cd milpaginas

# Criar diretório para classes compiladas
mkdir -p build/classes

# Compilar (ajustar paths conforme seu ambiente)
javac -cp "src/main/webapp/WEB-INF/lib/*:$CATALINA_HOME/lib/*" \
      -d build/classes \
      $(find src/main/java -name "*.java")

# Copiar classes compiladas
cp -r build/classes/* src/main/webapp/WEB-INF/classes/
```

2. **Deploy no Tomcat:**
```bash
# Copiar aplicação para webapps
cp -r . $CATALINA_HOME/webapps/milpaginas

# Ou criar WAR file
jar -cvf milpaginas.war -C src/main/webapp .
cp milpaginas.war $CATALINA_HOME/webapps/
```

3. **Iniciar Tomcat:**
```bash
# Windows
%CATALINA_HOME%\bin\startup.bat

# Linux/macOS
$CATALINA_HOME/bin/startup.sh
```

## 🌐 Verificação da Instalação

### 1. Testar Conexão com Banco
```bash
mysql -u milpaginas_user -p -e "SELECT COUNT(*) FROM milpaginas.usuarios;"
```

### 2. Acessar a Aplicação
1. Abra o navegador
2. Acesse: `http://localhost:8080/milpaginas`
3. Verifique se a página inicial carrega

### 3. Testar Login Administrativo
- **URL:** `http://localhost:8080/milpaginas/login`
- **Email:** `admin@milpaginas.com`
- **Senha:** `password` (ou conforme configurado no SQL)

## 🔍 Solução de Problemas Comuns

### Problema: Erro de Conexão com MySQL
```
Solução:
1. Verificar se MySQL está rodando:
   - Linux/macOS: sudo systemctl status mysql
   - Windows: services.msc → MySQL

2. Testar conexão manual:
   mysql -u milpaginas_user -p

3. Verificar configurações de firewall
```

### Problema: ClassNotFoundException
```
Solução:
1. Verificar se JARs estão em WEB-INF/lib/
2. Limpar e recompilar projeto
3. Verificar classpath da IDE
```

### Problema: Porta 8080 em uso
```
Solução:
1. Alterar porta do Tomcat:
   - Editar server.xml: <Connector port="8081" ...>

2. Ou matar processo na porta:
   - Linux/macOS: sudo lsof -t -i:8080 | xargs kill
   - Windows: netstat -ano | findstr :8080
```

### Problema: Encoding de Caracteres
```
Solução:
1. Adicionar ao server.xml do Tomcat:
   <Connector ... URIEncoding="UTF-8" />

2. Verificar filtro de encoding no web.xml
```

## 📝 Configurações Opcionais

### SSL/HTTPS (Desenvolvimento)
```xml
<!-- Adicionar ao server.xml -->
<Connector port="8443" 
           protocol="HTTP/1.1" 
           SSLEnabled="true"
           scheme="https" 
           secure="true"
           keystoreFile="${user.home}/.keystore"
           keystorePass="changeit" />
```

### Pool de Conexões
```xml
<!-- Adicionar ao context.xml -->
<Resource name="jdbc/milpaginas"
          auth="Container"
          type="javax.sql.DataSource"
          driverClassName="com.mysql.cj.jdbc.Driver"
          url="jdbc:mysql://localhost:3306/milpaginas"
          username="milpaginas_user"
          password="milpaginas_pass123"
          maxTotal="20"
          maxIdle="10"
          maxWaitMillis="-1" />
```

### Logs Detalhados
```xml
<!-- Adicionar ao logging.properties -->
com.milpaginas.level = FINE
java.util.logging.ConsoleHandler.level = FINE
```

## 🎯 Próximos Passos

1. **Explorar a aplicação**
2. **Criar dados de teste**
3. **Configurar ambiente de produção**
4. **Implementar backup do banco**
5. **Configurar monitoramento**

## 📞 Suporte

Se encontrar problemas durante a instalação:

1. **Verifique os logs:**
   - Tomcat: `$CATALINA_HOME/logs/catalina.out`
   - MySQL: `/var/log/mysql/error.log`

2. **Documentação oficial:**
   - [Tomcat Documentation](https://tomcat.apache.org/tomcat-9.0-doc/)
   - [MySQL Documentation](https://dev.mysql.com/doc/)

3. **Issues no GitHub:**
   - Abra uma issue detalhando o problema

---

**✅ Instalação concluída com sucesso! Bem-vindo ao Mil Páginas!**