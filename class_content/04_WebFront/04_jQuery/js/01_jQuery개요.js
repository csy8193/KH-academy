// JS 코드
document.getElementById("js-btn").addEventListener("click", function(){

    this.style.backgroundColor = "yellow";
});


// jQuery 코드
$("#jQuery-btn").on("click", function(){
    $(this).css("backgroundColor", "yellow");
});


// HTML 해석 순서 확인

// JS - window.onload (문서 로드가 끝났을 떄)
window.onload = function(){
    document.getElementById("test1").style.backgroundColor = "pink";

};

// window.onload 중복 작성
// -> 중복 작성 시 마지막으로 작성된 window.onload만 적용된다
window.onload = function(){
    document.getElementById("test1").style.fontSize = "30px";
};



// jQuery - ready()함수 적용

// 문서의 로딩이 완료되어 준비가 되었다면 기능을 수행
jQuery(document).ready(function(){
    $("#test2").css("backgroundColor", "yellow");

});

// ready() 함수 중복 작성
// -> 이전에 작성된 ready() 함수와 중복 작성이 가능하다
$(document).ready(function(){
    $("#test2").css("fontSize", "30px");
});

$(function(){
    $("#test2").css("color", "red");
});

$(() => {
    $("#test2").css("fontWeight", "bold");
});