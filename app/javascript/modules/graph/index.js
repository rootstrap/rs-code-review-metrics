import $ from 'jquery';
import 'select2';
import 'select2/dist/css/select2.css';
import '@ttskch/select2-bootstrap4-theme/dist/select2-bootstrap4.css';

const selectInputObject = (className) => {
  let object = { element: document.querySelector(`select.${className}-selection`) }
  object.optionSelected = object.element.options[object.element.selectedIndex].text;
  return object
}

const noOptionSelected = (option) => {
  return option === 'no option selected'
}

export const handleSelectFilterChange = () => {
  const sidebarProjectSelectionInput = document.querySelector('.project-selection');
  const navFilterForm = document.querySelector('.nav-filter');

  sidebarProjectSelectionInput.onchange = () => {
    const periodSelected = document.getElementById('metric_period');
    if (periodSelected.selectedIndex === 0) {
      periodSelected.selectedIndex = 1
    }
    navFilterForm.submit();
  }

  navFilterForm.onchange = function () {
    let sidebarProjectSelectionInput = document.querySelector('.project-selection');
    if (sidebarProjectSelectionInput.selectedIndex !== 0){
      this.submit();
    } else {
      const url = window.location.href.split('?')[0];
      window.location.assign(url);
    }
  }
}

export const initializeSelect2 = () => {
  $('.project-selection').select2({
    theme: 'bootstrap4',
  })
}
