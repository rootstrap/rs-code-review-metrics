import { initializeSelect2,
         handleChangeSidebar,
         handleChangeUser,
         disablePeriod
        } from '../modules/sidebar';

document.addEventListener('turbolinks:load', () => {
  initializeSelect2();
  handleChangeSidebar();
  handleChangeUser();
  disablePeriod();
});
