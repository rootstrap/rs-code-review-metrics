import $ from 'jquery';
import 'select2';
import 'select2/dist/css/select2.css';
import '@ttskch/select2-bootstrap4-theme/dist/select2-bootstrap4.css';

let elementSelector = (className) => {
  return document.querySelector(`.${className}`);
};

export const disablePeriod = () => {
  const button = document.getElementById('submitButton');
  const sidebarSelectionInput = elementSelector('repository-selection') || elementSelector('department-selection')
    || elementSelector('product-selection');
  if (sidebarSelectionInput && sidebarSelectionInput.selectedIndex === 0){
    button.disabled = true;
  }
};

export const handleChangeSidebar = () => {
  const sidebarSelectionInput = elementSelector('repository-selection') || elementSelector('department-selection')
    || elementSelector('product-selection');
  if (sidebarSelectionInput != null) {
    sidebarSelectionInput.onchange = () => {
      submitNavForm();
    };
  }
};

const submitNavForm = () => {
  let navFilterForm = elementSelector('nav-filter');
  const periodSelected = document.getElementById('metric_period');
  if (periodSelected && periodSelected.selectedIndex === 0) {
    periodSelected.selectedIndex = 1;
  }
  navFilterForm.submit();
};


export const handleChangeUser = () => {
  const userSelect = document.querySelector('.user-selection');
  if (userSelect != null) {
    const current_base_url = window.location.origin;
    userSelect.onchange = function() {
      const optionSelected = userSelect.options.selectedIndex;
      const resource = 'development_metrics/users/' +
      `${userSelect.options[optionSelected].value}/repositories`;
      window.location.href = `${current_base_url}/${resource}`;
    };
  }
};

export const initializeSelect2 = () => {
  if (!elementSelector('select2')) {
    $('.repository-selection, .product-selection, .department-selection, .user-selection').select2({
      theme: 'bootstrap4',
    });
  }
};
