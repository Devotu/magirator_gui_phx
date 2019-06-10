import "phoenix_html"

import { sortFunctions } from "./sort.js"

const sortTable = document.getElementById('myBtn');

if (sortTable != null) {
  sortTable.addEventListener('click', () => { sortFunctions.sortTableByColumn('statTable', 0); }, false);
}