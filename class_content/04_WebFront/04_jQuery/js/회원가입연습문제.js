// $("#input-id").on("blur", function(){
//     const regExp = /^[a-z][a-zA-Z\-\_]{6,14}$/;

//     if(regExp.test( $(this).val()) ){
//         $(this).css("backgroundColor", "springgreen");
//     }else{
//         $(this).css("backgroundColor", "red").css("color", "white");
//     }

//     if( $(this).val().trim().length == "" ){
//         $(this).css("backgroundColor", "initial").css("color", "initial");
//     }
// });


// $("#check-pw").on("keyup", function(){

//     if( $("#input-pw").val() == "" ){
//         $(this).val("")
//         alert("비밀번호를 입력해주세요");
//         $("#input-pw").focus();

//     }

//     if( $("#input-pw").val() == $(this).val() ){
//         $(this).parent().next().text("비밀번호가 일치합니다").css("color", "yellowgreen").css("fontSize", "10px");

//     }else{
//         $(this).parent().next().text("비밀번호가 일치하지 않습니다").css("color", "red").css("fontSize", "10px");

//     }
// });


// $("#input-name").on("input", function(){
//     const regExp = /^[가-힣]{2,5}$/;

//     if(regExp.test( $(this).val()) ){
//         $(this).parent().next().text("정상입력").css("color", "springgreen").css("fontSize", "10px");
//     }else{
//         $(this).parent().next().text("한글만 입력하세요").css("color", "red").css("fontSize", "10px");
//     }

//     if( $(this).val().trim().length == "" ){
//         $(this).parent().next().text("");
//     }

// });


// $("#sign-up").on("click", validate);


// function validate(e){

//     if( $("input[name='gender']:checked").prop("checked") == false ){
//         alert("성별을 선택해주세요");
//         e.preventDefault();
//     }

//     const regExp = /^[0][0-9]{1,2}-[0-9]{3,4}-[0-9]{4}/;


//     if( regExp.test($("#input-tel").val()) == false ){
//         alert("전화번호 형식이 올바르지 않습니다");
//         e.preventDefault();
//     }
// }

/////////////////////////////////////////////////////////////////////////////////////////


// document.getElementById("input-id").addEventListener("blur", function(){
//     const regExp = /^[a-z][a-zA-Z\-\_]{6,14}$/;

//     if( regExp.test(this.value) ){
//         this.style.backgroundColor = "springgreen";
//     }else{
//         this.style.backgroundColor = "red";
//         this.style.color = "white";
//     }

//     if( this.value.trim().length == "" ){
//         this.style.backgroundColor = "initial";
//         this.style.color = "initial";
//     }

// });


// document.getElementById("check-pw").addEventListener("keyup", function(){
//     const inputPw = document.getElementById("input-pw");

//     if(inputPw.value.trim().length == 0){
//         this.value = "";
//         alert("비밀번호를 입력해주세요");
//         inputPw.focus();
//     }

//     if( inputPw.value == this.value ){
//         inputPw.parentElement.nextElementSibling.innerHTML = "비밀번호가 일치합니다";
//         inputPw.parentElement.nextElementSibling.style.color = "yellowgreen";
//         inputPw.parentElement.nextElementSibling.style.fontSize = "10px";
//     }else{
//         inputPw.parentElement.nextElementSibling.innerHTML = "비밀번호가 일치하지 않습니다";
//         inputPw.parentElement.nextElementSibling.style.color = "red";
//         inputPw.parentElement.nextElementSibling.style.fontSize = "10px";
//     }

// });

// document.getElementById("input-name").addEventListener("input", function(){
//     const regExp = /^[가-힣]{2,5}$/;
//     const inputNextEl = this.parentElement.nextElementSibling;

//     if( regExp.test(this.value) ){
//         inputNextEl.innerHTML = "정상입력";
//         inputNextEl.style.color = "springgreen";
//         inputNextEl.style.fontSize = "10px";

//     }else{
//         inputNextEl.innerHTML = "한글만 입력하세요";
//         inputNextEl.style.color = "red";
//         inputNextEl.style.fontSize = "10px";
//     }


//     if( this.value.trim().length == "" ){
//         inputNextEl.innerHTML = "";
//     }

// });


document.getElementById("sign-up").addEventListener("click", validate)

function validate(e) {

    const gender = document.querySelectorAll("input[name='gender']:checked");

    if( gender.length == 0 ){
        alert("성별을 선택해주세요");
        e.preventDefault();
    }

    const regExp = /^[0][0-9]{1,2}-[0-9]{3,4}-[0-9]{4}/;
    const inputTel = document.getElementById("input-tel");

    if( regExp.test(inputTel.value) == false){
        alert("전화번호 형식이 올바르지 않습니다");
        e.preventDefault();
    }
}
