const fragment = new DocumentFragment();
const url = 'http://localhost:9292/tests';

document.addEventListener("DOMContentLoaded", loadExams());


async function loadExams() {

  response = await fetch('http://localhost:9292/tests');

  data = await response.json();

  data.forEach(function(exam) {
    exam['tests'].forEach(function(test) {
      const tr = document.createElement('tr');

      let td_tag = document.createElement('td');
      let td_text = document.createTextNode(exam['patient']['cpf']);
      td_tag.appendChild(td_text);
      tr.appendChild(td_tag);

      td_tag = document.createElement('td');
      td_text = document.createTextNode(exam['patient']['name']);
      td_tag.appendChild(td_text);
      tr.appendChild(td_tag);
  
      td_tag = document.createElement('td');
      td_text = document.createTextNode(exam['patient']['email']);
      td_tag.appendChild(td_text);
      tr.appendChild(td_tag);
  
      td_tag = document.createElement('td');
      td_text = document.createTextNode(exam['patient']['birthdate']);
      td_tag.appendChild(td_text);
      tr.appendChild(td_tag);
  
      td_tag = document.createElement('td');
      td_text = document.createTextNode(exam['patient']['address']);
      td_tag.appendChild(td_text);
      tr.appendChild(td_tag);
  
      td_tag = document.createElement('td');
      td_text = document.createTextNode(exam['patient']['city']);
      td_tag.appendChild(td_text);
      tr.appendChild(td_tag);
  
      td_tag = document.createElement('td');
      td_text = document.createTextNode(exam['patient']['state']);
      td_tag.appendChild(td_text);
      tr.appendChild(td_tag);
  
      td_tag = document.createElement('td');
      td_text = document.createTextNode(exam['doctor']['crm']);
      td_tag.appendChild(td_text);
      tr.appendChild(td_tag);
  
      td_tag = document.createElement('td');
      td_text = document.createTextNode(exam['doctor']['crm_state']);
      td_tag.appendChild(td_text);
      tr.appendChild(td_tag);
  
      td_tag = document.createElement('td');
      td_text = document.createTextNode(exam['doctor']['name']);
      td_tag.appendChild(td_text);
      tr.appendChild(td_tag);
  
      td_tag = document.createElement('td');
      td_text = document.createTextNode(exam['doctor']['email']);
      td_tag.appendChild(td_text);
      tr.appendChild(td_tag);
  
      td_tag = document.createElement('td');
      td_text = document.createTextNode(exam['token']);
      td_tag.appendChild(td_text);
      tr.appendChild(td_tag);
  
      td_tag = document.createElement('td');
      td_text = document.createTextNode(exam['date']);
      td_tag.appendChild(td_text);
      tr.appendChild(td_tag);
  
      td_tag = document.createElement('td');
      td_text = document.createTextNode(test['type']);
      td_tag.appendChild(td_text);
      tr.appendChild(td_tag);
  
      td_tag = document.createElement('td');
      td_text = document.createTextNode(test['limits']);
      td_tag.appendChild(td_text);
      tr.appendChild(td_tag);
  
      td_tag = document.createElement('td');
      td_text = document.createTextNode(test['result']);
      td_tag.appendChild(td_text);
      tr.appendChild(td_tag);
  
      const element = document.getElementById('table-body')
      element.appendChild(tr)
    })
    });
}