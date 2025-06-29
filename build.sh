#!/bin/bash

# Script de Build para Mil Páginas
# Este script compila o projeto Java sem usar Maven

set -e  # Parar execução em caso de erro

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Função para imprimir mensagens coloridas
print_message() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Verificar se JAVA_HOME está definido
if [ -z "$JAVA_HOME" ]; then
    print_message $RED "Erro: JAVA_HOME não está definido"
    print_message $YELLOW "Configure JAVA_HOME apontando para sua instalação do JDK"
    exit 1
fi

# Verificar se CATALINA_HOME está definido (opcional)
if [ -z "$CATALINA_HOME" ]; then
    print_message $YELLOW "Aviso: CATALINA_HOME não está definido"
    print_message $YELLOW "Algumas funcionalidades podem não funcionar corretamente"
fi

print_message $BLUE "=== Mil Páginas - Build Script ==="
print_message $BLUE "Iniciando compilação do projeto..."

# Definir diretórios
PROJECT_DIR="$(pwd)"
SRC_DIR="$PROJECT_DIR/src/main/java"
WEBAPP_DIR="$PROJECT_DIR/src/main/webapp"
BUILD_DIR="$PROJECT_DIR/build"
CLASSES_DIR="$BUILD_DIR/classes"
LIB_DIR="$WEBAPP_DIR/WEB-INF/lib"
DIST_DIR="$PROJECT_DIR/dist"

# Criar diretórios necessários
print_message $BLUE "Criando diretórios de build..."
mkdir -p "$CLASSES_DIR"
mkdir -p "$DIST_DIR"

# Verificar se as dependências existem
print_message $BLUE "Verificando dependências..."

DEPENDENCIES=(
    "mysql-connector-java"
    "gson"
    "servlet-api"
)

# Construir classpath
CLASSPATH="$CLASSES_DIR"

# Adicionar JARs da lib
if [ -d "$LIB_DIR" ]; then
    for jar in "$LIB_DIR"/*.jar; do
        if [ -f "$jar" ]; then
            CLASSPATH="$CLASSPATH:$jar"
            print_message $GREEN "✓ Encontrado: $(basename "$jar")"
        fi
    done
else
    print_message $RED "Erro: Diretório $LIB_DIR não encontrado"
    exit 1
fi

# Adicionar Servlet API do Tomcat se disponível
if [ -n "$CATALINA_HOME" ] && [ -d "$CATALINA_HOME/lib" ]; then
    for jar in "$CATALINA_HOME/lib"/*.jar; do
        if [ -f "$jar" ]; then
            CLASSPATH="$CLASSPATH:$jar"
        fi
    done
    print_message $GREEN "✓ Servlet API do Tomcat adicionado"
fi

# Encontrar todos os arquivos .java
print_message $BLUE "Encontrando arquivos fonte..."
JAVA_FILES=$(find "$SRC_DIR" -name "*.java" | wc -l)
print_message $GREEN "✓ Encontrados $JAVA_FILES arquivos Java"

# Compilar código Java
print_message $BLUE "Compilando código Java..."
if find "$SRC_DIR" -name "*.java" -exec javac -cp "$CLASSPATH" -d "$CLASSES_DIR" -encoding UTF-8 {} +; then
    print_message $GREEN "✓ Compilação concluída com sucesso"
else
    print_message $RED "✗ Erro na compilação"
    exit 1
fi

# Copiar arquivos de recursos (se existirem)
if [ -d "$SRC_DIR/../resources" ]; then
    print_message $BLUE "Copiando arquivos de recursos..."
    cp -r "$SRC_DIR/../resources/"* "$CLASSES_DIR/"
    print_message $GREEN "✓ Recursos copiados"
fi

# Copiar classes compiladas para WEB-INF/classes
print_message $BLUE "Copiando classes para aplicação web..."
mkdir -p "$WEBAPP_DIR/WEB-INF/classes"
cp -r "$CLASSES_DIR/"* "$WEBAPP_DIR/WEB-INF/classes/"
print_message $GREEN "✓ Classes copiadas para WEB-INF/classes"

# Criar arquivo WAR
WAR_FILE="$DIST_DIR/milpaginas.war"
print_message $BLUE "Criando arquivo WAR..."

cd "$WEBAPP_DIR"
if jar -cvf "$WAR_FILE" .; then
    print_message $GREEN "✓ Arquivo WAR criado: $WAR_FILE"
else
    print_message $RED "✗ Erro ao criar arquivo WAR"
    exit 1
fi

cd "$PROJECT_DIR"

# Informações sobre o build
WAR_SIZE=$(du -h "$WAR_FILE" | cut -f1)
print_message $BLUE "Informações do build:"
print_message $GREEN "  - Arquivo WAR: $WAR_FILE"
print_message $GREEN "  - Tamanho: $WAR_SIZE"
print_message $GREEN "  - Classes compiladas: $JAVA_FILES"

# Verificar se Tomcat está disponível para deploy automático
if [ -n "$CATALINA_HOME" ] && [ -d "$CATALINA_HOME/webapps" ]; then
    read -p "Deseja fazer deploy no Tomcat local? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_message $BLUE "Fazendo deploy no Tomcat..."
        
        # Remover deploy anterior se existir
        if [ -d "$CATALINA_HOME/webapps/milpaginas" ]; then
            rm -rf "$CATALINA_HOME/webapps/milpaginas"
            print_message $YELLOW "✓ Deploy anterior removido"
        fi
        
        if [ -f "$CATALINA_HOME/webapps/milpaginas.war" ]; then
            rm -f "$CATALINA_HOME/webapps/milpaginas.war"
        fi
        
        # Copiar novo WAR
        cp "$WAR_FILE" "$CATALINA_HOME/webapps/"
        print_message $GREEN "✓ Deploy realizado com sucesso"
        print_message $BLUE "Aplicação disponível em: http://localhost:8080/milpaginas"
    fi
fi

# Instruções finais
print_message $BLUE "=== Build Concluído ==="
print_message $GREEN "Para fazer deploy manual:"
print_message $YELLOW "1. Copie $WAR_FILE para \$CATALINA_HOME/webapps/"
print_message $YELLOW "2. Inicie/reinicie o Tomcat"
print_message $YELLOW "3. Acesse http://localhost:8080/milpaginas"

print_message $GREEN "Para desenvolvimento:"
print_message $YELLOW "1. Configure $WEBAPP_DIR como documento root"
print_message $YELLOW "2. Certifique-se que as dependências estão em WEB-INF/lib/"

print_message $BLUE "=== Dependências Necessárias ==="
print_message $YELLOW "Baixe e coloque em src/main/webapp/WEB-INF/lib/:"
print_message $YELLOW "• mysql-connector-java-8.0.x.jar"
print_message $YELLOW "• gson-2.8.x.jar"
print_message $YELLOW "• jstl-1.2.jar (opcional, para tags JSP)"

print_message $GREEN "Build finalizado com sucesso! 🎉"