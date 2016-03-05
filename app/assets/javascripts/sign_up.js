function signUpValidation(){
  // For owner
  $('#owner-reg-form').on('keypress', function(){
    if((($('#owner-preferred-payment').val() === "Paypal" && $('#owner-paypal-acct').val() === "") || ($('#owner-preferred-payment').val() === "Venmo" && $('#owner-venmo-acct').val() === "")) || $('#owner-email').val() === "" || $('#owner-password').val() === "" || $('#owner-confirm-password').val() === ""){
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

function editValidation(){
  // For owner
  $('#owner-edit-form').on('keypress', function(){
    if((($('#owner-edit-preferred-payment').val() === "Paypal" && $('#owner-edit-paypal-acct').val() === "") || ($('#owner-edit-preferred-payment').val() === "Venmo" && $('#owner-edit-venmo-acct').val() === "")) || $('#owner-edit-email').val() === "" || $('#owner-old-password').val() === ""){
      $('#owner-update').addClass('disabled');
      $('#owner-edit-form').on("keypress", function (e) {
        if (e.keyCode == 13) {
          return false;
        }
      });
    }else{
      $('#owner-update').removeClass('disabled');
      $('#owner-edit-form').on("keypress", function (e) {
        if (e.keyCode == 13) {
          $('#owner-update').trigger('click');
        }
      });
    }    
  });
  
  // For guest
  $('#guest-edit-form').on('keypress', function(){
    if($('#guest-email').val() === "" || $('#guest-old-password').val() === "" || $('#guest-owner-email').val() === ""){
      $('#guest-update').addClass('disabled');
      $('#guest-edit-form').on("keypress", function (e) {
        if (e.keyCode == 13) {
          return false;
        }
      });
    }else{
      $('#guest-update').removeClass('disabled');
      $('#guest-edit-form').on("keypress", function (e) {
        if (e.keyCode == 13) {
          $('#guest-update').trigger('click');
        }
      });
    }    
  });
}

function allValidation(){
  signUpValidation();
  editValidation();
}

$(document).on('page:load', allValidation);
$('document').ready(allValidation);