const el = document.getElementById("project")
const connectSec = document.getElementById("connect")
const indicator = document.getElementById("scroll");
const iObserver = new IntersectionObserver(
    entries => {
        if(entries[0]['intersectionRatio'] == 0) {
            // element is hidden
            indicator.classList.remove("show")
            indicator.classList.add("hidden")
            console.log(false)
        }
        else {
            console.log(true)
            indicator.classList.remove("hidden")

            indicator.classList.add("show")
        }
    }
  );
  

  iObserver.observe(el);