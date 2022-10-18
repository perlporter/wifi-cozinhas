const submit = document.getElementById('submit');
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


submit.addEventListener('click', (e) => {
    const link_login = e.target.getAttribute('data-loginonly');
    const link_dst = e.target.getAttribute('data-dst')
    const link_username = e.target.getAttribute('data-mac');
    window.location.href = `${link_login}?dst=${link_dst}&username=T-${link_username}`;
})
