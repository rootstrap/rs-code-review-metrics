import { initializeSelect2, handleChangeSidebar, handleChangeNavForm } from '../modules/graph';

document.addEventListener('turbolinks:load', () => {
  initializeSelect2();
  handleChangeSidebar();
  handleChangeNavForm();
})
