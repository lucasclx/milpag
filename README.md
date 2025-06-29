# Mil Páginas - Sistema de E-commerce para Livraria

Sistema completo de e-commerce desenvolvido em Java utilizando Servlets e JSP, com banco de dados MySQL e interface responsiva.

## 📚 Sobre o Projeto

O "Mil Páginas" é um sistema de e-commerce especializado em livros, desenvolvido seguindo as melhores práticas de desenvolvimento Java web. O projeto utiliza tecnologias clássicas como Servlets e JSP, demonstrando como criar uma aplicação web robusta sem frameworks modernos.

## 🚀 Tecnologias Utilizadas

- **Backend:**
  - Java 8+
  - Servlets 4.0
  - JSP (JavaServer Pages)
  - JDBC para persistência de dados
  - MySQL 8.0+

- **Frontend:**
  - HTML5
  - CSS3 (Design responsivo)
  - JavaScript (ES6+)
  - Font Awesome (Ícones)

- **Ferramentas:**
  - Apache Tomcat 9.0+
  - MySQL Workbench (opcional)
  - Eclipse/IntelliJ IDEA

## 🏗️ Arquitetura

O projeto segue o padrão MVC (Model-View-Controller):

```
src/main/java/com/milpaginas/
├── controller/          # Servlets (Controladores)
├── model/              # Classes de modelo (Entidades)
├── dao/                # Data Access Objects (Persistência)
├── util/               # Classes utilitárias
├── filter/             # Filtros de servlet
└── listener/           # Listeners de aplicação

src/main/webapp/
├── WEB-INF/           # Configurações e bibliotecas
├── css/               # Estilos CSS
├── js/                # Scripts JavaScript
├── images/            # Imagens da aplicação
└── *.jsp              # Páginas JSP
```

## ⚙️ Funcionalidades

### 👥 Módulo de Usuários
- ✅ Cadastro de novos usuários
- ✅ Sistema de login/logout
- ✅ Gerenciamento de perfil
- ✅ Controle de acesso (Cliente/Administrador)
- ✅ Criptografia de senhas

### 📖 Módulo de Livros
- ✅ Catálogo de livros com paginação
- ✅ Busca por título, autor ou editora
- ✅ Visualização detalhada de livros
- ✅ Gerenciamento de estoque
- ✅ CRUD completo (Admin)

### 🛒 Carrinho de Compras
- ✅ Adicionar/remover livros
- ✅ Atualizar quantidades
- ✅ Persistência por usuário
- ✅ Cálculo automático de totais

### 📦 Módulo de Pedidos
- ✅ Finalização de compra
- ✅ Histórico de pedidos
- ✅ Gerenciamento de status
- ✅ Controle de estoque automático

## 🗄️ Banco de Dados

O sistema utiliza MySQL com as seguintes tabelas principais:

- `usuarios` - Dados dos usuários
- `livros` - Catálogo de livros
- `carrinho` - Itens do carrinho
- `pedidos` - Pedidos realizados
- `itens_pedido` - Itens de cada pedido

## 📋 Pré-requisitos

- Java JDK 8 ou superior
- MySQL 8.0 ou superior
- Apache Tomcat 9.0 ou superior
- IDE Java (Eclipse, IntelliJ, etc.)

## 🛠️ Instalação e Configuração

### 1. Clone o Repositório
```bash
git clone <url-do-repositorio>
cd milpaginas
```

### 2. Configuração do Banco de Dados

1. Instale o MySQL e crie um usuário:
```sql
CREATE USER 'milpaginas'@'localhost' IDENTIFIED BY 'sua_senha';
GRANT ALL PRIVILEGES ON *.* TO 'milpaginas'@'localhost';
FLUSH PRIVILEGES;
```

2. Execute o script SQL:
```bash
mysql -u milpaginas -p < docs/sql/milpaginas_database.sql
```

3. Configure a conexão em `src/main/webapp/WEB-INF/db.properties`:
```properties
db.url=jdbc:mysql://localhost:3306/milpaginas?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC
db.username=milpaginas
db.password=sua_senha
db.driver=com.mysql.cj.jdbc.Driver
```

### 3. Configuração das Dependências

Baixe e adicione as seguintes bibliotecas ao diretório `src/main/webapp/WEB-INF/lib/`:

- MySQL Connector/J 8.0+
- Gson 2.8+ (para JSON)
- Servlet API 4.0+ (se não estiver no Tomcat)

Links para download:
- [MySQL Connector/J](https://dev.mysql.com/downloads/connector/j/)
- [Gson](https://github.com/google/gson)

### 4. Configuração do Tomcat

1. Configure o Tomcat na sua IDE
2. Adicione o projeto como uma aplicação web
3. Configure as seguintes JVM options se necessário:
```
-Dfile.encoding=UTF-8
-Djava.awt.headless=true
```

### 5. Compilação e Deploy

1. **Compilação Manual:**
```bash
# Criar estrutura de diretórios
mkdir -p build/classes

# Compilar classes Java
javac -cp "src/main/webapp/WEB-INF/lib/*:$TOMCAT_HOME/lib/*" \
      -d build/classes \
      src/main/java/com/milpaginas/**/*.java

# Copiar arquivos compilados
cp -r build/classes/* src/main/webapp/WEB-INF/classes/
```

2. **Deploy no Tomcat:**
   - Copie a pasta do projeto para `$TOMCAT_HOME/webapps/milpaginas`
   - Ou configure como projeto web na IDE

### 6. Primeiro Acesso

1. Inicie o Tomcat
2. Acesse: `http://localhost:8080/milpaginas`
3. Cadastre um novo usuário ou use o admin padrão:
   - **Email:** admin@milpaginas.com
   - **Senha:** password (definida no script SQL)

## 🧪 Testando a Aplicação

### Funcionalidades para Testar:

1. **Cadastro e Login:**
   - Registre um novo usuário
   - Faça login e logout
   - Teste validações de campos

2. **Navegação:**
   - Explore o catálogo de livros
   - Use a busca por diferentes critérios
   - Teste a paginação

3. **Carrinho:**
   - Adicione livros ao carrinho
   - Modifique quantidades
   - Remova itens

4. **Pedidos:**
   - Complete uma compra
   - Visualize o histórico
   - Teste como admin o gerenciamento

5. **Administração:**
   - Faça login como admin
   - Adicione/edite livros
   - Gerencie pedidos

## 🔧 Solução de Problemas

### Erro de Conexão com Banco
- Verifique se o MySQL está rodando
- Confirme as credenciais em `db.properties`
- Teste a conexão manualmente

### Erro 404 - Página não encontrada
- Verifique o deploy no Tomcat
- Confirme os mappings no `web.xml`
- Cheque se as dependências estão no lugar

### Erro de Encoding
- Configure UTF-8 no Tomcat
- Verifique o `CharacterEncodingFilter`

### Performance
- Configure pool de conexões
- Otimize queries SQL
- Implemente cache se necessário

## 📁 Estrutura de Arquivos

```
milpaginas/
├── README.md
├── docs/
│   ├── sql/
│   │   └── milpaginas_database.sql
│   └── images/
├── src/
│   └── main/
│       ├── java/
│       │   └── com/milpaginas/
│       │       ├── controller/
│       │       ├── dao/
│       │       ├── filter/
│       │       ├── listener/
│       │       ├── model/
│       │       └── util/
│       └── webapp/
│           ├── WEB-INF/
│           │   ├── web.xml
│           │   ├── db.properties
│           │   └── lib/
│           ├── css/
│           ├── js/
│           ├── images/
│           └── *.jsp
```

## 🤝 Contribuição

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 📄 Licença

Este projeto é licenciado sob a MIT License - veja o arquivo [LICENSE](LICENSE) para detalhes.

## 📞 Suporte

Para dúvidas ou problemas:
- Abra uma issue no GitHub
- Entre em contato: contato@milpaginas.com

## 🔮 Próximas Funcionalidades

- [ ] Sistema de wishlist
- [ ] Avaliações e comentários
- [ ] Relatórios avançados
- [ ] API REST
- [ ] Integração com gateway de pagamento
- [ ] Sistema de cupons de desconto
- [ ] Notificações por email

---

**Desenvolvido com ❤️ para demonstrar as capacidades do Java web clássico**