var sortFunctions = (function () 
{
  function sortTableByColumn(target, column) { 
    console.log('sorting ' + target + ' on column ' + column) 

    let table = document.getElementById(target);
    let sorting = true;
    
    while (sorting) {
      sorting = false;
      let rows = table.rows;
      /* Loop through all table rows (except the
      first, which contains table headers): */

      // Start by saying there should be no switching:
      let shouldSwitch = false;

      let i = 0;
      for (i = 1; i < (rows.length - 1); i++) {
        // /* Get the two elements you want to compare,
        // one from current row and one from the next: */
        let x = rows[i].cells[column];
        let y = rows[i + 1].cells[column];

        // // Check if the two rows should switch place:
        if (isNumeric(x.innerHTML)) 
        {
          if (parseFloat(x.innerHTML) > parseFloat(y.innerHTML)) {
            // If so, mark as a switch and break the loop:
            shouldSwitch = true;
            break;
          }
        } 
        else 
        {
          if (x.innerHTML.toLowerCase() > y.innerHTML.toLowerCase()) {
            // If so, mark as a switch and break the loop:
            shouldSwitch = true;
            break;
          }
        }
      }

      if (shouldSwitch) {
        /*If a switch has been marked, make the switch
        and mark that a switch has been done:*/
        rows[i].parentNode.insertBefore(rows[i + 1], rows[i]);
        sorting = true;
      }
    }
  }

  function isNumeric(n) {
    return !isNaN(parseFloat(n)) && isFinite(n);
  }

  return {
    sortTableByColumn: function (target, column) {
      sortTableByColumn(target, column)
    }
  }
})()

export { sortFunctions }