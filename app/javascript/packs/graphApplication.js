import { initializeSelect2,
         handleChangeSidebar,
         handleChangeNavForm,
         handleChangeUserSelectionForm
        } from '../modules/sidebar';

document.addEventListener('turbolinks:load', () => {
  initializeSelect2();
  handleChangeSidebar();
  handleChangeNavForm();
  handleChangeUserSelectionForm();
})
