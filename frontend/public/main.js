document.addEventListener("DOMContentLoaded", homePage());
document.getElementById("all_exams_link").addEventListener("click", function() { showHomePage() });

async function homePage() {
  document.getElementById("exam-page").style.display = 'none';
  loadExams();
}

async function showHomePage() {
  document.getElementById("exam-page").style.display = 'none';
  document.getElementById("home-page").style.display = 'block';
}

async function loadExams() {

  response = await fetch('http://localhost:9292/tests');

  data = await response.json();

  data.forEach(function(exam) {
      const tr = document.createElement('tr');
      tr.classList.add("table-row");
      
      td_tag = document.createElement('td');
      td_tag.classList.add("table-item");
      td_text = document.createTextNode(exam['patient']['name']);
      td_tag.appendChild(td_text);
      tr.appendChild(td_tag);

      td_tag = document.createElement('td');
      td_tag.classList.add("table-item");
      td_text = document.createTextNode(exam['doctor']['name']);
      td_tag.appendChild(td_text);
      tr.appendChild(td_tag);

      btn_tag = document.createElement('button');
      btn_tag.classList.add("token-btn")
      a_text = document.createTextNode(exam['token']);
      btn_tag.addEventListener("click", function() { showExam(exam['token']) });
      btn_tag.appendChild(a_text);

      td_tag = document.createElement('td');
      td_tag.classList.add("table-item");
      td_tag.appendChild(btn_tag);
      tr.appendChild(td_tag);
  
      td_tag = document.createElement('td');
      td_tag.classList.add("table-item");
      td_text = document.createTextNode(exam['date']);
      td_tag.appendChild(td_text);
      tr.appendChild(td_tag);

      const element = document.getElementById('exam-table-body')
      element.appendChild(tr)
    });
}

async function showExam(token) {
  response = await fetch('http://localhost:9292/tests/' + token);

  data = await response.json();

  document.getElementById("exam-page").style.display = 'block';
  document.getElementById("home-page").style.display = 'none';

  document.getElementById("token").appendChild(document.createTextNode(data['token']));
  document.getElementById("date").appendChild(document.createTextNode(data['date']));

  document.getElementById("patient_name").appendChild(document.createTextNode(data['patient']['name']));
  document.getElementById("patient_cpf").appendChild(document.createTextNode(data['patient']['cpf']));
  document.getElementById("patient_email").appendChild(document.createTextNode(data['patient']['email']));
  document.getElementById("patient_birthdate").appendChild(document.createTextNode(data['patient']['birthdate']));
  document.getElementById("patient_address").appendChild(document.createTextNode(data['patient']['address']));

  document.getElementById("doctor_name").appendChild(document.createTextNode(data['doctor']['name']));
  document.getElementById("doctor_crm").appendChild(document.createTextNode(data['doctor']['crm']));
  document.getElementById("doctor_crm_state").appendChild(document.createTextNode(data['doctor']['crm_state']));
  document.getElementById("doctor_email").appendChild(document.createTextNode(data['doctor']['email']));

  data['tests'].forEach(function(test) {
    const tr = document.createElement('tr');
    tr.classList.add("table-row");

    td_tag = document.createElement('td');
    td_tag.classList.add("table-item");
    td_text = document.createTextNode(test['type']);
    td_tag.appendChild(td_text);
    tr.appendChild(td_tag);

    td_tag = document.createElement('td');
    td_tag.classList.add("table-item");
    td_text = document.createTextNode(test['limits']);
    td_tag.appendChild(td_text);
    tr.appendChild(td_tag);

    td_tag = document.createElement('td');
    td_tag.classList.add("table-item");
    td_text = document.createTextNode(test['result']);
    td_tag.appendChild(td_text);
    tr.appendChild(td_tag);

    const element = document.getElementById('test-table-body')
    element.appendChild(tr)
  });
}