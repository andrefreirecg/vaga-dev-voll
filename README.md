
# 💬 Desafio Voll - Sistema de Troca de Mensagens

Projeto desenvolvido como parte do desafio para vaga de Desenvolvedor Júnior na Voll Solutions.

## 🚀 Tecnologias

- **Backend:** Ruby on Rails (API Mode) + PostgreSQL + Redis
- **Frontend:** Vue.js (Vite)
- **Ambiente:** Docker + Docker Compose

## 📦 Como rodar a aplicação (DOCKER / DOCKER COMPOSE)

### Pré-requisitos

- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)

### 🔧 Passo a passo

1. Clone o repositório:

```
git clone https://github.com/andrefreirecg/vaga-dev-voll.git
```

2. Acesse a pasta do projeto:

```
cd vaga-dev-voll
```

3. Execute o projeto

```
docker compose up -d --build
```

## 📦 Como rodar a aplicação (Manualmente)

### Pré-requisitos

- [Ruby V.3.2.3](https://www.ruby-lang.org/en/news/2024/01/18/ruby-3-2-3-released/)
- [Rails V.8.0.2](https://rubyonrails.org/2025/3/12/Rails-Version-8-0-2-has-been-released)
- [Node V.20.19.2](https://nodejs.org/pt/blog/release/v20.19.2) + YARN
- [Redis V.6.2.18](https://redis.io/docs/latest/operate/rs/release-notes/rs-6-2-18-releases/)
- [PostgreSQL V.14.18](https://www.postgresql.org/docs/release/14.18/)

### 🔧 Passo a passo

1. Clone o repositório:

```
git clone https://github.com/andrefreirecg/vaga-dev-voll.git
```

2. Copie e **CONFIGURE** os envs:

```
cp backend/.env.sample backend/.env
cp frontend/.env.sample frontend/.env
```

3. Instale as dependencias do backend

```
bundle install
```

4. Execute as migrations do backend
```
rails db:migrate
```

4. Execute o backend ***O processo ocupa o terminal***
```
rails s
```

5. Acesse o frontend e instale as dependencias
```
cd ../frontend
yarn install

```
6. Execute o frontend 
```
yarn dev
```


### ✅ Acesse

-   Frontend: [http://localhost:5173](http://localhost:5173)
    
-   Backend: [http://localhost:3000](http://localhost:3000)

## 🔐 Autenticação

No frontend, informe apenas seu `user_id` (usuário gerado por seed ou API).
Você pode criar uma nova conta com poucos cliques na interface ou via API.


## 📫 Endpoints disponíveis

### Autenticação

-   `POST /login` – Realiza login do usuário.
    
-   `GET /me` – Retorna dados do usuário autenticado.
    
-   `POST /logout` – Realiza logout do usuário.
    

----------

### Usuários

-   `POST /users` – Cria um novo usuário.
    
-   `GET /users/:id` – Retorna dados do usuário pelo ID.
    
-   `DELETE /users/:id` – Deleta usuário pelo ID.
    
-   `GET /users/all` – Lista todos os usuários.
    

----------

### Conversas

-   `POST /conversations` – Cria uma nova conversa.
    
-   `GET /conversations/:id` – Mostra os detalhes de uma conversa pelo ID.
    
-   `DELETE /conversations/:id` – Deleta uma conversa pelo ID.
    
-   `GET /conversations/user/:id` – Lista todas as conversas do usuário pelo ID.
    

----------

### Mensagens

-   `POST /messages` – Envia uma nova mensagem.
    
-   `GET /messages/conversation/:conversation_id` – Lista mensagens paginadas de uma conversa.
    
-   `DELETE /messages/:id` – Deleta uma mensagem pelo ID.
    

----------

### Outros

-   Qualquer rota não definida retorna erro 404 com mensagem “Endpoint não encontrado”.
    

----------

**Nota:** Todos os endpoints requerem autenticação (via header ou frontend).


## ✅ Diferenciais Implementados

-   ✅ Comunicação em tempo real com WebSockets (ActionCable)
    
-   ✅ Redis para processamento assíncrono
    
-   ✅ Autenticação simplificada via user_id ou name
    
-   ✅ Docker + Docker Compose para ambiente unificado
    
-   ✅ `.env.sample` para facilitar configuração manual

-   ✅ Autenticação com JWT

 -   ✅ Paginação nas mensagens

-   ✅ Limitação de apenas um usuário logado com aquele ID por vez


## 📬 Contato

Desenvolvido por **André Barciela Freire**  
- [📧 andrefreirecg@gmail.com](mailto:andrefreirecg@gmail.com)
- [📱💬 11 9 1446-4496](https://wa.me/+5511914464496)
