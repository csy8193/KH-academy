// 1단계
$("#btn1").on("click", function(){
    $("#div1").css("backgroundColor", $("#input1").val());

});


// 2단계
$("#btn2").on("click", function(){
    const area = $(".area2");
    const input = $(".input-color2");

    for(let i=0; i<area.length; i++){
        $(area[i]).css("backgroundColor", $(input[i]).val());

    }
});


// 3단계
(function(){
    const input3 = $(".input-color3");
    const area3 = $(".area3");
    
    for(let i=0; i<input3.length; i++){
        $(input3[i]).on("input", function(){
            $(area3[i]).css("transition-duration", "2s").css("backgroundColor", $(input3[i]).val());
            $(input3[i]).css("border", "2px solid " + $(input3[i]).val());
        });
    }
})();

