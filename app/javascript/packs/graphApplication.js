import { initializeSelect2,
         handleChangeSidebar,
         handleChangeUser,
         disablePeriod
} from '../modules/sidebar';

import { chartElementClickInitializer } from '../modules/chart';

document.addEventListener('turbolinks:load', () => {
  initializeSelect2();
  handleChangeSidebar();
  handleChangeUser();
  disablePeriod();
  chartElementClickInitializer();
});
