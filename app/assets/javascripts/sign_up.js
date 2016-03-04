function signUpValidation(){
  // For owner
  $('#owner-reg-form').on('keypress', function(){
    if((($('#user_preferred_payment').val() === "Paypal" && $('#owner-paypal-acct').val() === "") || ($('#user_preferred_payment').val() === "Venmo" && $('#owner-venmo-acct').val() === "")) || $('#owner-email').val() === "" || $('#owner-password').val() === "" || $('#owner-confirm-password').val() === ""){
      $('#owner-signup').addClass('disabled');
      $('#owner-reg-form').on("keypress", function (e) {
        if (e.keyCode == 13) {
          return false;
        }
      });
    }else{
      $('#owner-signup').removeClass('disabled');
      $('#owner-reg-form').on("keypress", function (e) {
        if (e.keyCode == 13) {
          $('#owner-signup').trigger('click');
        }
      });
    }    
  });
  
  // For guest
  $('#guest-reg-form').on('keypress', function(){
    if($('#guest-email').val() === "" || $('#guest-password').val() === "" || $('#guest-confirm-password').val() === "" || $('#guest-owner-email').val() === ""){
      $('#guest-signup').addClass('disabled');
      $('#guest-reg-form').on("keypress", function (e) {
        if (e.keyCode == 13) {
          return false;
        }
      });
    }else{
      $('#guest-signup').removeClass('disabled');
      $('#guest-reg-form').on("keypress", function (e) {
        if (e.keyCode == 13) {
          $('#guest-signup').trigger('click');
        }
      });
    }    
  });
}

$(document).on('page:load', signUpValidation);
$('document').ready(signUpValidation);