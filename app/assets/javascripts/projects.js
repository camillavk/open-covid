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

function disableShortDescription () {
  $('#project_short_description').keyup(function() {
    let inputLength = $(this).val().length

    if (inputLength > 140) {
      $("#project-form-submit").attr("disabled", true)
      $(".form-error-info").removeClass("hide")
      $(this).addClass("input-error")
    } else {
      $("#project-form-submit").attr("disabled", false)
      $(".form-error-info").addClass("hide")
      $(this).removeClass("input-error")
    }
  })
}

document.addEventListener("turbolinks:load", function() {
  initializeDataList();
  filterProjects();
  disableShortDescription();
})