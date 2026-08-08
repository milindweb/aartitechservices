function initContactForm() {
  var form = document.getElementById("contactForm");
  if (!form) { setTimeout(initContactForm, 100); return; }

  var scriptURL = SITE_CONFIG.appsScriptUrl;
  var siteName = SITE_CONFIG.contact.siteName;
  var responseDiv = document.getElementById("response");
  var phoneInput = document.getElementById("phone");
  var phoneError = document.getElementById("phoneError");
  var submitting = false;

  form.addEventListener("submit", function(e) {
    e.preventDefault();
    if (submitting) return;
    var pattern = /^[6-9][0-9]{9}$/;
    if (!pattern.test(phoneInput.value)) { phoneError.style.display = "block"; return; }
    phoneError.style.display = "none";
    submitting = true;
    fetch(scriptURL, {
      method: "POST", mode: "no-cors",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        site: siteName, service: form.service.value, name: form.name.value,
        email: form.email.value, phone: form.phone.value,
        message: form.message.value
      })
    })
    .then(function() {
      responseDiv.innerHTML = "<div class='alert success'>Thank you! We will contact you shortly.</div>";
      setTimeout(function() { responseDiv.innerHTML = ""; }, 15000);
      form.reset();
    })
    .catch(function() {
      responseDiv.innerHTML = "<div class='alert error'>Something went wrong. Please try again.</div>";
    })
    .finally(function() {
      submitting = false;
    });
  });
}

initContactForm();
