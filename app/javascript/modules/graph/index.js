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

export const initializeSelect2 = () => {
  $('.project-selection, .department-selection').select2({
    theme: 'bootstrap4',
  })
}
