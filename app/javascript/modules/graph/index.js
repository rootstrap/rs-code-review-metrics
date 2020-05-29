import $ from 'jquery';
import 'select2';
import 'select2/dist/css/select2.css';
import '@ttskch/select2-bootstrap4-theme/dist/select2-bootstrap4.css';

let elementSelector = (className) => {
  return document.querySelector(`.${className}`)
}

export const handleChangeSidebar = () => {
  const sidebarProjectSelectionInput = elementSelector('project-selection');
  let navFilterForm = elementSelector('nav-filter');

  sidebarProjectSelectionInput.onchange = () => {
    const periodSelected = document.getElementById('metric_period');
    if (periodSelected.selectedIndex === 0) {
      periodSelected.selectedIndex = 1
    }
    navFilterForm.submit();
  }
}

export const handleChangeNavForm = () => {
  const navFilterForm = elementSelector('nav-filter');
  navFilterForm.onchange = function () {
    let sidebarProjectSelectionInput = elementSelector('project-selection');
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
