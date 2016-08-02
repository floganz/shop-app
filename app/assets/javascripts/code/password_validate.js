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

  $(".orders").find("#order_quantity").change(function(){
    $(this).closest("form").find(".price-span")
    .text((
      $(this).val()*$(this).closest(".caption")
      .find("#order_price").val()
    ).toFixed(2));
  })
});
