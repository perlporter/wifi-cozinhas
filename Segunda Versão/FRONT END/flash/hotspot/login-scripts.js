const submitFirst = document.getElementById('submitFirst');
const submitSecond = document.getElementById('submitSecond');
const check = document.getElementById('accept');

check.addEventListener('change', (e) => {
    console.log(e.currentTarget.checked)
    const isChecked = e.currentTarget.checked;
    if (isChecked) {
        submit.removeAttribute('disabled');
    } else {
        submit.setAttribute('disabled', true);
    }
})


// Submit primeira autenticação - WHATSAPP

submitFirst.addEventListener('click', (e) => {
    const link_login = e.target.getAttribute('data-loginonly');
    const link_dst = e.target.getAttribute('data-dst')
    const link_username = e.target.getAttribute('data-mac');
    window.location.href = `${link_login}?dst=${link_dst}&username=T-${link_username}`;
})


// Submit segunda autenticação - Termos de uso
submitSecond.addEventListener('click', (e) => {
    const link_login = e.target.getAttribute('data-loginonly');
    const link_dst = e.target.getAttribute('data-dst')
    const link_username = e.target.getAttribute('data-mac');
    window.location.href = `${link_login}?dst=${link_dst}&username=T-${link_username}`;
})

const params = new URLSearchParams(window.location.search)

// Verificando se existe o parametro second_auth=true

const projectDiv = document.getElementById('project');
const summaryDiv = document.getElementById('summary');
const projectBoxDiv = document.getElementsByClassName('project-box')[0];
if (params.has('second_auth')) {
    projectDiv.style.display = 'block';
    summaryDiv.style.display = 'none';
    projectBoxDiv.style.display = 'none';
} else {
    projectDiv.style.display = 'none';
    summaryDiv.style.direction = 'block';
    projectBoxDiv.style.display = 'block';
}
