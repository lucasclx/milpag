# 🔧 Correção do Erro de Servlet Duplicado

## ✅ Problema Resolvido

O erro que você encontrou foi causado por **configuração duplicada de servlets**. O problema foi corrigido removendo as anotações `@WebServlet` de todos os servlets, já que estamos usando configuração via `web.xml`.

## 🛠️ Correções Aplicadas

### 1. **Servlets Corrigidos:**
- ✅ `LoginServlet.java` - Removida anotação `@WebServlet("/login")`
- ✅ `LogoutServlet.java` - Removida anotação `@WebServlet("/logout")`
- ✅ `RegisterServlet.java` - Removida anotação `@WebServlet("/register")`
- ✅ `BookServlet.java` - Removida anotação `@WebServlet("/books")`
- ✅ `CartServlet.java` - Removida anotação `@WebServlet("/cart")`
- ✅ `OrderServlet.java` - Removida anotação `@WebServlet("/orders")`

### 2. **Dependência Removida:**
- ✅ Removido import do Gson no `CartServlet`
- ✅ Implementado JSON manual simples
- ✅ Não requer bibliotecas externas

## 📋 Próximos Passos

### 1. **Baixar Dependências Obrigatórias**

Você precisa baixar e colocar estes JARs em `src/main/webapp/WEB-INF/lib/`:

#### **MySQL Connector/J** (Obrigatório)
```bash
# Download do driver MySQL
wget https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-8.0.33.jar
```

#### **JSTL** (Recomendado para JSP)
```bash
# Download da JSTL para JSP
wget https://repo1.maven.org/maven2/javax/servlet/jstl/1.2/jstl-1.2.jar
```

### 2. **Configurar Banco de Dados**

1. **Criar o banco:**
```sql
mysql -u root -p < docs/sql/milpaginas_database.sql
```

2. **Verificar configuração em `WEB-INF/db.properties`:**
```properties
db.url=jdbc:mysql://localhost:3306/milpaginas?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC
db.username=root
db.password=sua_senha_aqui
db.driver=com.mysql.cj.jdbc.Driver
```

### 3. **Deploy no Eclipse**

1. **Limpar projeto:**
   - Clique direito no projeto → Clean...
   - Project → Clean → Selecionar o projeto

2. **Refresh do projeto:**
   - F5 ou clique direito → Refresh

3. **Executar no servidor:**
   - Clique direito no projeto → Run As → Run on Server

## 🚀 Download Manual das Dependências

Se não conseguir baixar automaticamente, acesse os links:

### **MySQL Connector/J:**
- 🔗 https://dev.mysql.com/downloads/connector/j/
- Baixe a versão **Platform Independent (Architecture Independent), ZIP Archive**
- Extraia e copie o arquivo `.jar` para `WEB-INF/lib/`

### **JSTL (Opcional):**
- 🔗 https://repo1.maven.org/maven2/javax/servlet/jstl/1.2/jstl-1.2.jar
- Baixe diretamente e coloque em `WEB-INF/lib/`

## 🔍 Verificação Final

Após aplicar as correções e dependências:

1. **Estrutura de arquivos:**
```
src/main/webapp/WEB-INF/lib/
├── mysql-connector-java-8.0.33.jar  ✅ Obrigatório
└── jstl-1.2.jar                     ✅ Recomendado
```

2. **Teste de conexão:**
   - O ApplicationStartupListener irá testar a conexão no startup
   - Verifique os logs do Tomcat para confirmar

3. **Acesso à aplicação:**
   - URL: `http://localhost:8080/milpaginas`
   - Login admin: `admin@milpaginas.com` / `password`

## ⚠️ Problemas Comuns

### **Erro: ClassNotFoundException**
- **Causa:** MySQL Connector não está no classpath
- **Solução:** Verificar se o `.jar` está em `WEB-INF/lib/`

### **Erro: Connection refused**
- **Causa:** MySQL não está rodando ou configuração incorreta
- **Solução:** 
  ```bash
  sudo systemctl start mysql
  # ou
  sudo service mysql start
  ```

### **Erro: Access denied**
- **Causa:** Credenciais incorretas no `db.properties`
- **Solução:** Verificar usuário e senha no MySQL

## 🎉 Aplicação Funcionando

Depois de aplicar todas as correções, a aplicação deve:

1. ✅ Iniciar sem erros no Tomcat
2. ✅ Conectar com o banco de dados
3. ✅ Permitir cadastro e login de usuários
4. ✅ Exibir catálogo de livros
5. ✅ Funcionar completamente

## 📞 Suporte

Se ainda encontrar problemas:
1. Verifique os logs do Tomcat no console do Eclipse
2. Confirme que o MySQL está rodando
3. Teste a conexão com o banco manualmente
4. Verifique se todos os JARs estão no local correto

---

**✅ Correções aplicadas com sucesso! O projeto deve funcionar normalmente agora.**