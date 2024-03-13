# Rebase Labs

Aplicação desenvolvida durante o treinamento da Rebase Labs, que tem como foco entender os fundamentos do ecosistema de desenvolvimento web com Ruby. Priorizamos fazer as coisas em um baixo nível, minimizando o uso de bibliotecas que facilitem demais o nosso trabalho.

Esse é um repositório de exploração, de descobrimento, meu foco aqui é aprender então difícilmente algo estará otimizado ou feito da melhor forma. 

Proceed with caution. 

## Setup

#### Pré-requisitos

- Docker

#### Instruções

1. Baixe e entre no repositório localmente
`git clone https://github.com/Luckvc/rebase-labs.git`
`cd rebase-labs`

2. Execute o comando para criar os containers
`docker compose up`

3. Acesse o website pelo endereço `http://localhost:3000/index`


## Endpoints

URL base `http://localhost:9292`

- `/hello`

Endpoint: `GET`

Content-type: `text/html`

Expected response: 
```html
Hello world!
```

- `/tests`

Endpoint: `GET`

Content-type: `application/json`

Expected response: 
```json
[ {
    "id": "303",
    "token": "T9O6AI",
    "date": "2021-11-21",
    "patient": {
      "id": "53",
      "cpf": "066.126.400-90",
      "name": "Matheus Barroso",
      "email": "maricela@streich.com",
      "birthdate": "1972-03-09",
      "address": "9378 Rua Stella Braga",
      "city": "Senador Elói de Souza",
      "state": "Pernambuco"
    },
    "doctor": {
      "id": "13",
      "crm": "B000B7CDX4",
      "crm_state": "SP",
      "name": "Sra. Calebe Louzada",
      "email": "kendra@nolan-sawayn.co"
    },
    "tests": [
      {
        "id": "35127",
        "type": "hemácias",
        "limits": "45-52",
        "result": "48",
        "exam_id": "303"
      },
      {
        "id": "35128",
        "type": "leucócitos",
        "limits": "9-61",
        "result": "75",
        "exam_id": "303"
      }]
} ]
```

- `/search?token=`

Endpoint: `GET`
Params: `token`

Content-type: `application/json`

Expected response status 200: 
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

Expected response status 404: 
```json
{}
```

- `/import`

Endpoint: `POST`
Accepted file extention: `.csv`
Request content-type: `text/csv`

Expected response status 200: 
```json
["Dados Importados"]
```

Expected response status 415: 
```json
["Arquivo não suportado"]
```

Expected response status 422: 
```json
["Dados Incompatíveis"]
```