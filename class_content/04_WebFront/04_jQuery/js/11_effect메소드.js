// show() : 요소에 display : none; 제거
$("#show-btn").on("click", function(){
    $("#img1").show(1000);

});


// hide() : 요소에 display : none; 추가
// 너비, 높이를 점점 0으로, 투명도도 0으로 변경
$("#hide-btn").on("click", function(){
    $("#img1").hide(1000);

});


// fadeIn()
$("#fadeIn-btn").on("click", function(){
    $("#img2").fadeIn(1000);

});

// fadeOut()
$("#fadeOut-btn").on("click", function(){
    $("#img2").fadeOut(1000);

});


// slideDown()
$("#slideDown-btn").on("click", function(){
    $("#img3").slideDown(1000);

});

// slideUp()
$("#slideUp-btn").on("click", function(){
    $("#img3").slideUp(1000);

});

$("#toggle").on("click", function(){
    if( $("#img4").css("display") == "none" ){
        $("#img4").slideDown(100);

    }else{
        $("#img4").slideUp(100);

    }
})

$("#toggle2").on("click", function(){
    $("#img4").toggle(1000);
});


$(".title").on("click", function(){
    if($(this).next().css("display") == "none"){
        $(".content").slideUp(100);
        $(this).next().slideDown(100);

    }else{
        $(this).next().slideUp(100);

    }
});