$(document).ready(function() {
  $("button").click(function() {
    $(this).next().slideToggle(600);
  });
});

$(document).on('turbolinks:load', function() {
  const canvas = document.getElementsByTagName("canvas").length;
  if(canvas === 0) {
    $("button").hide();
  } else {
    $("button").show();
  }
})
