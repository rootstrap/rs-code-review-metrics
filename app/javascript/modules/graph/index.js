import $ from 'jquery';
import 'select2';
import 'select2/dist/css/select2.css';
import '@ttskch/select2-bootstrap4-theme/dist/select2-bootstrap4.css'


const selectInputObject = (className) => {
  let object = { element: document.querySelector(`select.${className}-selection`) }
  object.optionSelected = object.element.options[object.element.selectedIndex].text;
  return object
}

const noOptionSelected = (option) => {
  return option === 'no option selected'
}

export const handleSelectFilterChange = () => {
  const sidebarForm = document.querySelector('.sidebar-form');

  sidebarForm.onchange = function () {
    let projectSelect = selectInputObject('project');
    let periodSelect = selectInputObject('period');
    let metricNameSelect = selectInputObject('metric-name');

    if (noOptionSelected(projectSelect.optionSelected)) {
      const url = window.location.href.split('?')[0]
      window.location.assign(url);
    } else {
      noOptionSelected(periodSelect.optionSelected) && (periodSelect.element.selectedIndex = 1)
      noOptionSelected(metricNameSelect.optionSelected) && (metricNameSelect.element.selectedIndex = 1)
      this.submit();
    }
  }
}

export const initializeSelect2 = () => {
  $('.project-selection').select2({
    theme: 'bootstrap4',
  })
}
