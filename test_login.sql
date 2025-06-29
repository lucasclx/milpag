-- Script para testar se o banco foi criado corretamente
USE milpaginas;

-- Verificar se a tabela usuarios existe
DESCRIBE usuarios;

-- Verificar se o admin foi inserido
SELECT id, nome, email, senha, tipo_usuario FROM usuarios WHERE email = 'admin@milpaginas.com';

-- Verificar todos os usuários
SELECT id, nome, email, tipo_usuario, data_cadastro FROM usuarios;