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
    "id": "1",
    "patient_cpf": "000.000.000-00",
    "patient_name": "Jane Doe Silva",
    "patient_email": "gerald.crona@ebert-quigley.com",
    "patient_birthdate": "2001-03-11",
    "patient_address": "165 Rua Rafaela",
    "patient_city": "Ituverava",
    "patient_state": "Alagoas",
    "doctor_crm": "B000BJ20J4",
    "doctor_crm_state": "PI",
    "doctor_name": "John Doe Carvalho",
    "doctor_email": "denna@wisozk.biz",
    "exam_token": "IQCZ17",
    "exam_date": "2021-08-05",
    "exam_type": "hemácias",
    "exam_limits": "45-52",
    "exam_result": "97"
  },
  {
    "id": "2",
    "patient_cpf": "000.000.000-00",
    "patient_name": "Jane Doe Silva",
    "patient_email": "gerald.crona@ebert-quigley.com",
    "patient_birthdate": "2001-03-11",
    "patient_address": "165 Rua Rafaela",
    "patient_city": "Ituverava",
    "patient_state": "Alagoas",
    "doctor_crm": "B000BJ20J4",
    "doctor_crm_state": "PI",
    "doctor_name": "John Doe Carvalho",
    "doctor_email": "denna@wisozk.biz",
    "exam_token": "IQCZ17",
    "exam_date": "2021-08-05",
    "exam_type": "leucócitos",
    "exam_limits": "9-61",
    "exam_result": "89"
  },
  {
    "id": "3",
    "patient_cpf": "000.000.000-00",
    "patient_name": "Jane Doe Silva",
    "patient_email": "gerald.crona@ebert-quigley.com",
    "patient_birthdate": "2001-03-11",
    "patient_address": "165 Rua Rafaela",
    "patient_city": "Ituverava",
    "patient_state": "Alagoas",
    "doctor_crm": "B000BJ20J4",
    "doctor_crm_state": "PI",
    "doctor_name": "John Doe Carvalho",
    "doctor_email": "denna@wisozk.biz",
    "exam_token": "IQCZ17",
    "exam_date": "2021-08-05",
    "exam_type": "plaquetas",
    "exam_limits": "11-93",
    "exam_result": "97"
  } ]

```