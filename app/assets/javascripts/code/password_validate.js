$(document).on("turbolinks:load",function(){
	$.formUtils.addValidator({
    name : 'pwd_check',
    validatorFunction : function(value, $el, config, language, $form) {
      var field_name = $el.attr('id').replace("_confirmation",'');
      return value === $("#"+field_name).val();
    },
    errorMessage : 'Password does not match',
    errorMessageKey: 'badPasswordConfirmation'
  });
  $.validate();

  $(".orders").find("#order_item_quantity").change(function(){
    $(this).closest("form").find(".price-span")
    .text((
      $(this).val()*$(this).closest(".caption")
      .find("#order_item_price").val()
    ).toFixed(2));
  });

  $( "#query" ).autocomplete({
    source: function( request, response ) {
      $.ajax({
        url: "/products/autocomplete",
        dataType: "json",
        data: {
          q: request.term
        },
        success: function( data ) {
          var links = [];
          for(i = 0; i < data.length; i++) {
            console.log(data[i]._id);
            var tmp = {};
            tmp.value = "/products/".concat(data[i]._id);
            tmp.label = data[i].name;
            links.push(tmp);
          }
          if (data.length == 6) {
            links[links.length-1] = {
              value: "/products/result?q="+request.term+"&offset=0",
              label: "See all"
            }
          }
          response( links );  
        }
      });
    },
    select: function( event, ui ) { 
            window.location.href = ui.item.value;
        }
  });

  var infScr = {};
  infScr.scroll = true;
  infScr.delay = 1000;
  infScr.busy = false;
  infScr.count = 9;
  infScr.offset = 0;
  infScr.end = false;

  infScr.getData = function () {
    $.get("/products/get_data?q=" + "som" + "&offset=" + this.offset, 
      function (response) {
        // console.log(response);
        if (response.length ==  0 && !infScr.end) {
          $("#container").append('<div class="alert alert-info clear">That\'s all</div>');
          infScr.end = true;
        }
        $("#container").append(response);
        infScr.busy = false;
      });
  };

  if(infScr.scroll == true) {
     $(window).scroll(function() {
        if($(window).scrollTop() + $(window).height() > $("#container").height() 
          && !infScr.busy) {
           infScr.busy = true;
           infScr.offset += infScr.count;
           setTimeout(function() {
              infScr.getData();      
           }, infScr.delay);         
        }  
     });
  }
});
