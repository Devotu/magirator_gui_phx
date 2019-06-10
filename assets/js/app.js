import "phoenix_html"

import { sortFunctions } from "./sort.js"

Array.from(document.getElementsByClassName("sortButton")).forEach(e => 
  e.addEventListener('click', () => 
    {
      sortFunctions.sortTableByColumn('statTable', e.dataset.sortColumn); 
    }, false)
  );