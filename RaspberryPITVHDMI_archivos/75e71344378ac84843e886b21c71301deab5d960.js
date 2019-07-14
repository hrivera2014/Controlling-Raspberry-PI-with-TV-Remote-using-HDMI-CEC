
    $(window).scroll(function(){
        if ($(window).scrollTop() > 31) {
           $("body").addClass("docked");
        } else {
           $("body").removeClass("docked");
        }
    });

