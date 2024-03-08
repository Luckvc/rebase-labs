const fragment = new DocumentFragment();
const url = 'http://localhost:9292/tests';

document.addEventListener("DOMContentLoaded", loadExams());


async function loadExams() {

  response = await fetch('http://localhost:9292/tests');

  data = await response.json();

  data.forEach(function(exam) {
    const tr = document.createElement('tr');

    let td_tag = document.createElement('td');
    let td_text = document.createTextNode(exam['patient_cpf']);
    td_tag.appendChild(td_text);
    tr.appendChild(td_tag);

    td_tag = document.createElement('td');
    td_text = document.createTextNode(exam['patient_name']);
    td_tag.appendChild(td_text);
    tr.appendChild(td_tag);

    td_tag = document.createElement('td');
    td_text = document.createTextNode(exam['patient_email']);
    td_tag.appendChild(td_text);
    tr.appendChild(td_tag);

    td_tag = document.createElement('td');
    td_text = document.createTextNode(exam['patient_birthdate']);
    td_tag.appendChild(td_text);
    tr.appendChild(td_tag);

    td_tag = document.createElement('td');
    td_text = document.createTextNode(exam['patient_address']);
    td_tag.appendChild(td_text);
    tr.appendChild(td_tag);

    td_tag = document.createElement('td');
    td_text = document.createTextNode(exam['patient_city']);
    td_tag.appendChild(td_text);
    tr.appendChild(td_tag);

    td_tag = document.createElement('td');
    td_text = document.createTextNode(exam['patient_state']);
    td_tag.appendChild(td_text);
    tr.appendChild(td_tag);

    td_tag = document.createElement('td');
    td_text = document.createTextNode(exam['doctor_crm']);
    td_tag.appendChild(td_text);
    tr.appendChild(td_tag);

    td_tag = document.createElement('td');
    td_text = document.createTextNode(exam['doctor_crm_state']);
    td_tag.appendChild(td_text);
    tr.appendChild(td_tag);

    td_tag = document.createElement('td');
    td_text = document.createTextNode(exam['doctor_name']);
    td_tag.appendChild(td_text);
    tr.appendChild(td_tag);

    td_tag = document.createElement('td');
    td_text = document.createTextNode(exam['doctor_email']);
    td_tag.appendChild(td_text);
    tr.appendChild(td_tag);

    td_tag = document.createElement('td');
    td_text = document.createTextNode(exam['exam_token']);
    td_tag.appendChild(td_text);
    tr.appendChild(td_tag);

    td_tag = document.createElement('td');
    td_text = document.createTextNode(exam['exam_date']);
    td_tag.appendChild(td_text);
    tr.appendChild(td_tag);

    td_tag = document.createElement('td');
    td_text = document.createTextNode(exam['exam_type']);
    td_tag.appendChild(td_text);
    tr.appendChild(td_tag);

    td_tag = document.createElement('td');
    td_text = document.createTextNode(exam['exam_limits']);
    td_tag.appendChild(td_text);
    tr.appendChild(td_tag);

    td_tag = document.createElement('td');
    td_text = document.createTextNode(exam['exam_result']);
    td_tag.appendChild(td_text);
    tr.appendChild(td_tag);

    const element = document.getElementById('table-body')
    element.appendChild(tr)
  });
}