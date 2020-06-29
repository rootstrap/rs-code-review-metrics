import { initializeSelect2,
         handleChangeSidebar,
         handleChangeNavForm,
         handleChangeUser,
         disablePeriod
        } from '../modules/sidebar';

document.addEventListener('turbolinks:load', () => {
  initializeSelect2();
  handleChangeSidebar();
  handleChangeNavForm();
  handleChangeUser();
  disablePeriod();
})
