// focus()

// #focus-blur요소에 포커스가 맞춰졌을 때의 동작
$("#focus-blur").on("focus", function(){
    $(this).css("backgroundColor", "pink");
});


// blur

// #focus-blur 요소가 포커스를 잃은 경우에 동작
$("#focus-blur").on("blur", function(){
    $(this).css("backgroundColor", "initial");
});


// change1

// #change1의 값이 변한 경우에 동작
$("#change1").on("change", function(){

    console.log("change1의 값이 변경되었습니다")
    console.log($(this).prop("checked")); // 체크 상태 : true / 아니면 false
});


// change2
// #change2의 값이 변한 경우에 동작
$("#change2").on("change", function(){
    console.log("change2의 값이 변경되었습니다")
    console.log($(this).val());
})


// select
// #select의 내용에 블럭이 설정된 경우 동작
$("#select").on("select", function(){
    $(this).css("backgroundColor", "lightgreen");
})




///////////////////////////////////////////////////////////


// on() 메소드 추가 사용법
$("#on-test").on("input", function(){
                // 입력과 관련된 모든 동작 발생 시
    setTimeout(()=>{
        console.log( $(this).val() );

    }, 100)
});


$("#input-content").on("input", function(){
    
    // JS
    // document.getElementById("counter").innerText = this.value.length;
    
    // 현재 작성된 글자수를 변수에 저장
    let count = $(this).val().length;

    if(count >= 100 && count < 130){
        // 100글자 이상 작성 시 #counter를 "주황색"으로 출력
        $("#counter").css("color", "orange");

    }else if(count >= 130 && count < 150){
        // 130글자 이상 작성 시 #counter를 "magenta"으로 출력
        $("#counter").css("color", "magenta");

    }else if(count >= 150){
        // 150글자 작성 시 #counter를 "빨간색"으로 출력, 더 이상 글이 작성되지 못하게 함
        $("#counter").css("color", "red");
        
        // 150 글자 초과 시 150글자 까지의 문자열을 잘라내어
        // #input-content의 value로 대입 --> 150 글자 초과 부분이 모두 제거됨

        $(this).val( $(this).val().substr(0,150) );

        // count를 150으로 변경
        count = 150;

    }else{
        // 위 세가지 상황 중 일치하는 경우가 없으면 counter를 "검정색"으로 출력
        $("#counter").css("color", "black");

    }
    
    
    
    


    

    // 글자 수를 출력하는 span
    $("#counter").text( count );
});