import $ from 'jquery';
import 'select2';
import 'select2/dist/css/select2.css';
import '@ttskch/select2-bootstrap4-theme/dist/select2-bootstrap4.css';

let elementSelector = (className) => {
  return document.querySelector(`.${className}`);
}

export const disablePeriod = () => {
  const button = document.getElementById('submitButton');
  let sidebarSelectionInput = elementSelector('project-selection') || elementSelector('department-selection');
  if (sidebarSelectionInput.selectedIndex === 0){
    button.disabled = true;
  }
}

export const handleChangeSidebar = () => {
  const sidebarSelectionInput = elementSelector('project-selection') || elementSelector('department-selection');
  let navFilterForm = elementSelector('nav-filter');
  if (sidebarSelectionInput != null) {
    sidebarSelectionInput.onchange = () => {
      const periodSelected = document.getElementById('metric_period');
      if (periodSelected.selectedIndex === 0) {
        periodSelected.selectedIndex = 1;
      }
      navFilterForm.submit();
    }
  }
}


export const handleChangeUser = () => {
  const userSelect = document.querySelector('.user-selection')
  if (userSelect != null) {
    const current_base_url = window.location.origin;
    userSelect.onchange = function() {
      const optionSelected = userSelect.options.selectedIndex;
      const resource = `users/${userSelect.options[optionSelected].value}/projects`;
      window.location.href = `${current_base_url}/${resource}`
    }
  }
}

export const initializeSelect2 = () => {
  $('.project-selection, .department-selection, .user-selection').select2({
    theme: 'bootstrap4',
  })
}
