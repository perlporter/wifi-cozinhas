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
});

submit.addEventListener('click', (e) => {
    const link_login = e.target.getAttribute('data-loginonly');
    // const link_dst = 'https://wa.me/5521997064846';
    const link_dst = 'https://api.whatsapp.com/send?phone=5511911625843&text=Olá,+gostaria+do+link+para+acessar+a+internet';
    const link_username = e.target.getAttribute('data-mac');
    // const comment = 'nivel01';
           
    document.getElementById("debug").innerText = `${link_login}?dst=${link_dst}&username=T-${link_username}`;
    window.location.href = `${link_login}?dst=${link_dst}&username=T-${link_username}`;
});


// /ip hotspot host remove [/ip hotspot nivel find where !primario] T-