document.addEventListener("DOMContentLoaded", loadHomePage ());
document.getElementById("all_exams_link").addEventListener("click", function() { showHomePage() });
document.getElementById("import_data_link").addEventListener("click", function() { showImportDataPage() });
document.getElementById("search-form").addEventListener("submit", (event) => { 
  event.preventDefault();

  showExam(document.getElementById("search-token").value.toUpperCase());
});
document.getElementById("import-form").addEventListener("submit", (event) => { 
  event.preventDefault();
  document.getElementById("import-message").innerHTML = "";

  uploadFile(document.getElementById("import-file").files[0]);
});


async function loadHomePage() {
  exams = await loadExams();
  displayExams(exams);
}

async function showHomePage() {
  document.getElementById("show-exam").innerHTML = "";
  document.getElementById("import-data-page").style.display = 'none';
  document.getElementById("home-page").style.display = 'block';
  document.getElementById("search-token").value = ""
}

async function loadExams() {
  response = await fetch('/tests');
  if (response.status == 200) { document.getElementById('exam-table-body').innerHTML = ""; }
  return await response.json();
}

function displayExams(exams) {
  exams.forEach(function(exam) {
      const tr = document.createElement('tr');
      tr.classList.add("table-row");
      tr.classList.add("exam-table-row");
      tr.addEventListener("click", function() { showExam(exam['token']) });
      
      tdTag = document.createElement('td');
      tdTag.classList.add("table-item");
      tdText = document.createTextNode(exam['patient']['name']);
      tdTag.appendChild(tdText);
      tr.appendChild(tdTag);

      tdTag = document.createElement('td');
      tdTag.classList.add("table-item");
      tdText = document.createTextNode(exam['doctor']['name']);
      tdTag.appendChild(tdText);
      tr.appendChild(tdTag);

      tdTag = document.createElement('td');
      tdTag.classList.add("table-item");
      tdText = document.createTextNode(exam['token']);
      tdTag.appendChild(tdText);
      tr.appendChild(tdTag);
  
      td_tag = document.createElement('td');
      td_tag.classList.add("table-item");
      td_text = document.createTextNode(new Date(exam['date']).toLocaleDateString("pt-br"));
      td_tag.appendChild(td_text);
      tr.appendChild(td_tag);

      const element = document.getElementById('exam-table-body')
      element.appendChild(tr)
    });
}



async function fetchExam(token) {
  response = await fetch('/tests/' + token);
  
  return await response.json();
}

function tokenNotFound() {
  const h2 = document.createElement('h2');
  const notFound = document.createTextNode('Nenhum resultado encontrado.');
  h2.classList.add("not-found");
  h2.appendChild(notFound);
  const showExamDiv = document.getElementById("show-exam");
  showExamDiv.appendChild(h2);
}

async function showExam(token) {
  exam = await fetchExam(token);
  document.getElementById("show-exam").innerHTML = "";
  document.getElementById("home-page").style.display = 'none';
  document.getElementById("import-data-page").style.display = 'none';

  if (Object.keys(exam).length === 0) return tokenNotFound();
  
  loadExam(exam);
}

function loadExam(exam) {
  const showExamDiv = document.getElementById("show-exam");
  const template = document.getElementById("template");

  const examPage = template.content.cloneNode(true);

  document.getElementById("home-page").style.display = 'none';

  examPage.getElementById("token").appendChild(document.createTextNode(exam['token']));
  examPage.getElementById("date").appendChild(document.createTextNode(new Date(exam['date']).toLocaleDateString("pt-br")));

  examPage.getElementById("patient_name").appendChild(document.createTextNode(exam['patient']['name']));
  examPage.getElementById("patient_cpf").appendChild(document.createTextNode(exam['patient']['cpf']));
  examPage.getElementById("patient_email").appendChild(document.createTextNode(exam['patient']['email']));
  examPage.getElementById("patient_birthdate").appendChild(document.createTextNode(new Date(exam['patient']['birthdate']).toLocaleDateString("pt-br")));
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

  tdTag = document.createElement('td');
  tdTag.classList.add("table-item");
  tdText = document.createTextNode(test['type']);
  tdTag.appendChild(tdText);
  tr.appendChild(tdTag);

  tdTag = document.createElement('td');
  tdTag.classList.add("table-item");
  tdText = document.createTextNode(test['limits']);
  tdTag.appendChild(tdText);
  tr.appendChild(tdTag);

  tdTag = document.createElement('td');
  tdTag.classList.add("table-item");
  tdText = document.createTextNode(test['result']);
  tdTag.appendChild(tdText);
  tr.appendChild(tdTag);

  return tr;
}



function showImportDataPage() {
  document.getElementById("show-exam").innerHTML = "";
  document.getElementById("home-page").style.display = 'none';
  document.getElementById("import-data-page").style.display = 'block';
  document.getElementById("import-message").innerHTML = "";
  document.getElementById("import-file").value = "";
}

async function uploadFile(file) {
  if (file.type != 'text/csv') { return flashMessage('Arquivo inválido', 'error')};

  const formData = new FormData();
  formData.append('file', file);
  try {
    const response = await fetch("/import", {
      method: "POST",
      body: formData,
    });

    const result = await response.json();

    importMessage(result);
    
    newDataCheck(getExamsTableRowCount());

    setTimeout(() => {
      loadHomePage();
    }, 5000);
  } catch (error) {
    console.error("Error:", error);
  }
}

function importMessage(message) {
  document.getElementById("import-file").value = "";
  flashMessage('Arquivo em processamento.', 'processing');

  showHomePage();
}

function flashMessage(message, status) {
  const flashMessage = document.getElementById('flash-message');
  const flashMessageText = document.getElementById('flash-message-text');
  flashMessageText.innerHTML = "";
  
  flashMessageText.appendChild(document.createTextNode(message));

  flashMessage.classList.add(status);
  
  flashMessage.style.display = 'block';
  flashMessage.classList.add('show');
  
  setTimeout(() => {
    flashMessage.classList.remove('show');
    flashMessage.classList.add('hide');

    
    setTimeout(() => {
      flashMessage.classList.remove('hide');
      flashMessage.style.display = 'none';
      flashMessage.classList.remove(status);
      flashMessageText.innerHTML = "";
    }, 300);
  }, 4700);
}

function getExamsTableRowCount() {
  var table = document.getElementById("exams-table");
  var rows = table.getElementsByTagName("tr");
  return rows.length - 1
}

function newDataCheck(rowCount) {
  setTimeout(() => {
    if (getExamsTableRowCount() > rowCount) {
      return flashMessage('Dados importados com sucesso.', 'success');
    } 

    flashMessage('Houve algum problema ao importar os dados.', 'error');
  }, 6000);
}