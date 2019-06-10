import "phoenix_html"

import { sortFunctions } from "./sort.js"

Array.from(document.getElementsByClassName("sortButton")).forEach(e => 
  e.addEventListener('click', () => 
    {
      sortFunctions.sortTableByColumn(findSortParent(e), e.dataset.sortColumn); 
    }, false)
  );

function findSortParent(element) {

  if (element.parentElement === null || typeof element.parentElement === "undefined") 
  {
    console.log("No parent element containing marker");
    return "";
  }

  if (typeof element.parentElement.dataset.sortTarget === "undefined") 
  {
    return findSortParent(element.parentElement);
  }

  return element.parentElement.dataset.sortTarget;
}