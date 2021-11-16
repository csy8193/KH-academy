$(".tab").on("click", function(){

    const div = $(".div1");
    const index = $(this).index();

    if($(div[index]).css("display") == "none"){
        div.hide();
        $(div[index]).show();

        $(".tab").css("backgroundColor", "grey");
        $(this).css("backgroundColor", "lightgrey");

    }else{
        $(div[index]).hide();
        $(this).css("backgroundColor", "grey");

    }
    
});