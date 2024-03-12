document.addEventListener("DOMContentLoaded", loadHomePage ());
document.getElementById("all_exams_link").addEventListener("click", function() { showHomePage() });
document.getElementById("search-form").addEventListener("submit", (event) => { 
  event.preventDefault();

  showExam(document.getElementById("search-token").value.toUpperCase());
});

async function loadHomePage() {
  exams = await loadExams();
  displayExams(exams);
}

async function showHomePage() {
  document.getElementById("show-exam").innerHTML = "";
  document.getElementById("home-page").style.display = 'block';
  document.getElementById("search-token").value = ""
}

async function loadExams() {
  response = await fetch('http://localhost:9292/tests');

  return await response.json();
}

function displayExams(exams) {
  exams.forEach(function(exam) {
      const tr = document.createElement('tr');
      tr.classList.add("table-row");
      tr.classList.add("exam-table-row");
      tr.addEventListener("click", function() { showExam(exam['token']) });
      
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

      td_tag = document.createElement('td');
      td_tag.classList.add("table-item");
      td_text = document.createTextNode(exam['token']);
      td_tag.appendChild(td_text);
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
  exam = await fetchExam(token);
  document.getElementById("show-exam").innerHTML = "";
  document.getElementById("home-page").style.display = 'none';

  if (Object.keys(exam).length === 0) return tokenNotFound();
  
  loadExam(exam);
}

function tokenNotFound() {
  const h2 = document.createElement('h2');
  const notFound = document.createTextNode('Nenhum resultado encontrado.');
  h2.classList.add("not-found");
  h2.appendChild(notFound);
  const showExamDiv = document.getElementById("show-exam");
  showExamDiv.appendChild(h2);
}

async function fetchExam(token) {
  response = await fetch('http://localhost:9292/tests/' + token);
  
  return await response.json();
}

function loadExam(exam) {
  const showExamDiv = document.getElementById("show-exam");
  const template = document.getElementById("template");

  const examPage = template.content.cloneNode(true);

  document.getElementById("home-page").style.display = 'none';

  examPage.getElementById("token").appendChild(document.createTextNode(exam['token']));
  examPage.getElementById("date").appendChild(document.createTextNode(exam['date']));

  examPage.getElementById("patient_name").appendChild(document.createTextNode(exam['patient']['name']));
  examPage.getElementById("patient_cpf").appendChild(document.createTextNode(exam['patient']['cpf']));
  examPage.getElementById("patient_email").appendChild(document.createTextNode(exam['patient']['email']));
  examPage.getElementById("patient_birthdate").appendChild(document.createTextNode(exam['patient']['birthdate']));
  examPage.getElementById("patient_address").appendChild(document.createTextNode(exam['patient']['address']));

  examPage.getElementById("doctor_name").appendChild(document.createTextNode(exam['doctor']['name']));
  examPage.getElementById("doctor_crm").appendChild(document.createTextNode(exam['doctor']['crm']));
  examPage.getElementById("doctor_crm_state").appendChild(document.createTextNode(exam['doctor']['crm_state']));
  examPage.getElementById("doctor_email").appendChild(document.createTextNode(exam['doctor']['email']));

  exam['tests'].forEach(function(test) {
    const element = examPage.getElementById('test-table-body')
    element.appendChild(buildTest(test))
  });

  showExamDiv.appendChild(examPage);
}

function buildTest(test) {
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

    return tr;
}