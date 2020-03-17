function initializeDataList () {
  $('.flexdatalist').flexdatalist({
    minLength: 0,
    noResultsText: 'No results found for "{keyword}". Hit enter to create a new tag.',
    searchByWord: true
});
}

function filterProjects () {
  $('.project-filter').change(function() {
    let tag_filters = $(this).val()
    $.ajax({
      url: "/projects",
      dataType: 'script',
      data: { tag_filters },
      success() {}
    })
  });
}

document.addEventListener("turbolinks:load", function() {
  initializeDataList();
  filterProjects();
})