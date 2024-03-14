# Rebase Labs

Aplicação desenvolvida durante o treinamento da Rebase Labs, que tem como foco entender os fundamentos do ecosistema de desenvolvimento web com Ruby. Priorizamos fazer as coisas em um baixo nível, minimizando o uso de bibliotecas que facilitem demais o nosso trabalho.

Esse é um repositório de exploração, de descobrimento, meu foco aqui é aprender então difícilmente algo estará otimizado ou feito da melhor forma. 

Proceed with caution. 

## Setup

#### Pré-requisitos

- Docker

#### Instruções

1. Baixe e entre no repositório localmente:
```
git clone https://github.com/Luckvc/rebase-labs.git
cd rebase-labs
```
2a. Execute o comando para criar os containers:
```
docker compose up
```
2b. Para popular o banco de dados pelo terminal. Abra outro terminal e execute o comando:
```
docker exec rebase-labs-backend-1 ruby import_from_csv.rb
```
1. Acesse o website pelo endereço:
```
http://localhost:3000/
```

## Endpoints

URL base `http://localhost:9292`


### Hello, World

- `/ping`

Endpoint para visualização de status da aplicação.

Endpoint: `GET`

Response content-type: `text/html`

<details>
  <summary>Resposta esperada</summary>

  ```html
  Pong!
  ```
</details>

<br>

### Testes
- `/tests`

Retorna todos os testes da base de dados.

Endpoint: `GET`

Response content-type: `application/json`

<details>
  <summary>Respostas esperadas</summary>

  Status 200 com resultado: 
  ```json
  [ {
    "id": "1",
    "token": "IQ1457",
    "date": "2021-08-05",
    "patient": {
      "id": "1",
      "cpf": "048.343.170-88",
      "name": "Lucas Vasques",
      "email": "gerald.crona@ebert-quigley.com",
      "birthdate": "2001-03-11",
      "address": "165 Rua Rafaela",
      "city": "Ituverava",
      "state": "Alagoas"
    },
    "doctor": {
      "id": "1",
      "crm": "B123BJ20J4",
      "crm_state": "PI",
      "name": "Maria Luisa Baos",
      "email": "denna@wisozk.biz"
    },
    "tests": [
      {
        "id": "1",
        "type": "hemácias",
        "limits": "45-52",
        "result": "97",
        "exam_id": "1"
      }
    ]
  },
  {
    "id": "2",
    "token": "Z9ZERQ",
    "date": "2021-04-29",
    "patient": {
      "id": "2",
      "cpf": "011.431.696-82",
      "name": "Frederico Mozzato",
      "email": "leona@bahringer.net",
      "birthdate": "1978-01-26",
      "address": "s/n Marginal Eloah Dantas",
      "city": "Serra Negra do Norte",
      "state": "Santa Catarina"
    },
    "doctor": {
      "id": "2",
      "crm": "B1322W2RBG",
      "crm_state": "PE",
      "name": "Dr. Rafael",
      "email": "diann_klein@schinner.org"
    },
    "tests": [
      {
        "id": "2",
        "type": "ácido úrico",
        "limits": "15-61",
        "result": "52",
        "exam_id": "2"
      }
    ]
  },
  {
    "id": "3",
    "token": "0OXID",
    "date": "2021-07-15",
    "patient": {
      "id": "3",
      "cpf": "089.125.562-70",
      "name": "Paulo Henrique",
      "email": "herta_wehner@krajcik.name",
      "birthdate": "1998-02-25",
      "address": "5334 Rodovia Thiago Bittencourt",
      "city": "Jequitibá",
      "state": "Paraná"
    },
    "doctor": {
      "id": "3",
      "crm": "B1232W2RBG",
      "crm_state": "CE",
      "name": "Dr. Leandro",
      "email": "diann_klein@schinner.org"
    },
    "tests": [
      {
        "id": "3",
        "type": "ldl",
        "limits": "45-54",
        "result": "48",
        "exam_id": "3"
      }
    ]
  } ]
  ```

  Status 200 sem resultado: 
  ```json
  []
  ```

</details>
<br>

### Busca por token

- `/search?token=`

Recebe o token de um exame e retorna todos os dados do mesmo.

Endpoint: `GET`

Params: `token`

Response content-type:: `application/json`

<details>
  <summary>Respostas esperadas</summary>

  Status 200: 
  ```json
  {
    "id": "301",
    "token": "IQCZ17",
    "date": "2021-08-05",
    "patient": {
      "id": "51",
      "cpf": "048.973.170-88",
      "name": "Emilly Batista Neto",
      "email": "gerald.crona@ebert-quigley.com",
      "birthdate": "2001-03-11",
      "address": "165 Rua Rafaela",
      "city": "Ituverava",
      "state": "Alagoas"
    },
    "doctor": {
      "id": "11",
      "crm": "B000BJ20J4",
      "crm_state": "PI",
      "name": "Maria Luiza Pires",
      "email": "denna@wisozk.biz"
    },
    "tests": [
      {
        "id": "35101",
        "type": "hemácias",
        "limits": "45-52",
        "result": "97",
        "exam_id": "301"
      }]
  }
  ```

  Status 404: 
  ```json
  {}
  ```

</details>

<br>

### Importar dados

- `/import`

Recebe um arquivo csv e importa para a base de dados de forma asyncrona.

**OBS.:** Problemas de compatibilidade de dados ainda não são reportados, uma vez que a importação acontece de forma assíncrona. 

Endpoint: `POST`

Accepted file extention: `.csv`

Request content-type: `text/csv`

Response content-type: `application/json`

<details>
  <summary>Respostas esperadas</summary>

  Status 200: 
  ```json
  ["Dados Importados"]
  ```

  Status 415: 
  ```json
  ["Arquivo não suportado"]
  ```
</details>