function resetCards(){
   var array = []
   $('.product-cards').each(function(i){ array[i] = $(this).css('top'); });
  var u_array = $.unique(array);
  var pos1 = parseInt(u_array[0]);
  var pos2 = parseInt(u_array[1]);
  var cardHeight = parseInt($('.product-cards').first().css('height'));
  var gutter = 30;
  if(pos2 - pos1 < cardHeight){
    for(i in u_array){ 
      $('.product-cards[style*="top: '+u_array[i]+'"]').css('top', i*(cardHeight+gutter)); 
    }
  }
};

$(document).ready(resetCards());