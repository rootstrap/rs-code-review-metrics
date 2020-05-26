import $ from 'jquery';
import 'select2';
import 'select2/dist/css/select2.css';
import '@ttskch/select2-bootstrap4-theme/dist/select2-bootstrap4.css'


const selectInputObject = (className) => {
  let object = { element: document.querySelector(`select.${className}-selection`) }
  object.optionSelected = object.element.options[object.element.selectedIndex].text;
  return object
}

const invalidSelectOption = (projectOptionSelected) => {
  return optionIsEmpty(projectOptionSelected) || projectOptionSelected === 'no project'
}

const optionIsEmpty = (option) => {
  return option === ''
}

export const handleSelectFilterChange = () => {
  const sidebarForm = document.querySelector('.sidebar-form');

  sidebarForm.onchange = function () {
    let projectSelect = selectInputObject('project');
    let periodSelect = selectInputObject('period');

    if (invalidSelectOption(projectSelect.optionSelected)) {
      const url = window.location.href.split('?')[0]
      window.location.assign(url);
    } else {
      optionIsEmpty(periodSelect.optionSelected) && (periodSelect.element.selectedIndex = 1)
      this.submit();
    }
  }
}

export const initializeSelect2 = () => {
  $('.project-selection').select2({
    theme: 'bootstrap4',
  })
}
