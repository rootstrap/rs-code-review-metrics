import $ from 'jquery';
import 'select2';
import 'select2/dist/css/select2.css';
import '@ttskch/select2-bootstrap4-theme/dist/select2-bootstrap4.css';

let elementSelector = (className) => {
  return document.querySelector(`.${className}`);
}

export const handleChangeSidebar = () => {
  const sidebarSelectionInput = elementSelector('project-selection') || elementSelector('department-selection');
  let navFilterForm = elementSelector('nav-filter');

  sidebarSelectionInput.onchange = () => {
    const periodSelected = document.getElementById('metric_period');
    if (periodSelected.selectedIndex === 0) {
      periodSelected.selectedIndex = 1;
    }
    navFilterForm.submit();
  }
}

export const handleChangeNavForm = () => {
  const navFilterForm = elementSelector('nav-filter');
  if (navFilterForm != null) {
    navFilterForm.onchange = function () {
      let sidebarSelectionInput = elementSelector('project-selection') || elementSelector('department-selection');
      if (sidebarSelectionInput !== 0){
        this.submit();
      } else {
        const url = window.location.href.split('?')[0];
        window.location.assign(url);
      }
    }
  }
}

export const handleChangeUser = () => {
  const userSelect = document.querySelector('.user-selection')
  const current_base_url = window.location.origin;
  userSelect.onchange = function() {
    const optionSelected = userSelect.options.selectedIndex;
    const resource = `users/${userSelect.options[optionSelected].value}/projects`;
    window.location.href = `${current_base_url}/${resource}`
  }
}

export const initializeSelect2 = () => {
  $('.project-selection, .department-selection, .user-selection').select2({
    theme: 'bootstrap4',
  })
}
