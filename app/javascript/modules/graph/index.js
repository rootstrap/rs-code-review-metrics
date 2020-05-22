const handleSidebarChange = () => {
  let selectInput = document.querySelector('select.period-selection');
  let optionSelected = selectInput.options[selectInput.selectedIndex].text;
  const sidebarForm = document.querySelector('.sidebar-form');

  if (optionSelected === '') {
    const url = window.location.href.split('?')[0]
    window.history.replaceState({}, document.title, url);
  }

  sidebarForm.onchange = function () {
    this.submit()
  }
}

export default handleSidebarChange;
