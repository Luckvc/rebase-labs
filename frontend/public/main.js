document.addEventListener("DOMContentLoaded", loadExams());


async function loadExams() {

  response = await fetch('http://localhost:9292/tests');

  data = await response.json();

  data.forEach(function(exam) {
      const tr = document.createElement('tr');

      td_tag = document.createElement('td');
      td_text = document.createTextNode(exam['patient']['name']);
      td_tag.appendChild(td_text);
      tr.appendChild(td_tag);

      td_tag = document.createElement('td');
      td_text = document.createTextNode(exam['doctor']['name']);
      td_tag.appendChild(td_text);
      tr.appendChild(td_tag);

      td_tag = document.createElement('td');
      a_tag = document.createElement('a');
      a_text = document.createTextNode(exam['token']);
      a_tag.appendChild(a_text);
      a_tag.href = "http://localhost:3000/" + exam['token'];
      td_tag.appendChild(a_tag);
      tr.appendChild(td_tag);
  
      td_tag = document.createElement('td');
      td_text = document.createTextNode(exam['date']);
      td_tag.appendChild(td_text);
      tr.appendChild(td_tag);

      const element = document.getElementById('table-body')
      element.appendChild(tr)
    });
}