import "phoenix_html"

import { sortFunctions } from "./sort.js"

Array.from(document.getElementsByClassName("sortButton")).forEach(e => 
  e.addEventListener('click', () => 
    {
      sortFunctions.sortTableByColumn(findSortParent(e), e.dataset.sortColumn, findOrderAndInvert(e)); 
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

function findOrderAndInvert(element) {
  let current = element.dataset.sortDesc;
  element.dataset.sortDesc = invertBooleanNumber(element.dataset.sortDesc); 
  return current == 1;
}

//Converts 1 => 0 & 0 => 1
function invertBooleanNumber(number) {
  return Math.pow((number - 1), 2)
}


Array.from(document.getElementsByClassName("restrict-tier")).forEach(e => 
  e.addEventListener('click', () => 
    {
      restrictDecksToTierMatch(); 
      restrictTags(); 
    }, 
    false
  )
);


function restrictDecksToTierMatch(tier, decks) {
  console.log(restrictDecksToTierMatch)
}


function restrictTags(deckOne, deckTwo) {
  console.log(restrictTags)
}