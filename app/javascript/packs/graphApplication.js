import { initializeSelect2,
         handleChangeSidebar,
         handleChangeNavForm,
         handleChangeUser
        } from '../modules/sidebar';

document.addEventListener('turbolinks:load', () => {
  initializeSelect2();
  handleChangeSidebar();
  handleChangeNavForm();
  handleChangeUser();
})
