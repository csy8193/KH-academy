// Date
document.getElementById("btn1").addEventListener("click", function(){

    const date1 = new Date();
    
    // GMt
    const date2 = new Date("Mon Nov 08 2021 09:00:00");

    // UTC
    // -> 월 표현법이 1~12가 아닌 0 ~ 11로 표현
    const date3 = new Date(2021, 10, 8, 9, 0, 0);
                        // 년, 월, 일, 시, 분, 초

    console.log(date1);
    console.log(date2);
    console.log(date3);



    // Date 객체에서 년, 월, 일, 시, 분, 초, 요일 얻어오기

    console.log("년도 : " + date1.getFullYear() );
    console.log("월 : " + (date1.getMonth() + 1) );
    console.log("일 : " + date1.getDate() );

    const arr = ["일", "월", "화", "수", "목", "금", "토" ];
    // 일요일 == 0 ~ 토요일 == 6
    console.log("요일 : " + arr[ date1.getDay() ] );

    console.log("시 : " + date1.getHours() );
    console.log("분 : " + date1.getMinutes() );
    console.log("초 : " + date1.getSeconds() );

});


document.getElementById("btn2").addEventListener("click", function(){
    window.setTimeout(function(){
        alert("setTimeout 확인!!!")
    }, 100);
});

document.getElementById("btn3").addEventListener("click", () => {
    setTimeout(() => {
        alert("이동합니다.");
        location.href = "http://naver.com";
    }, 3000);
});


document.getElementById("btn4").addEventListener("click", () => {
    const div1 = document.getElementById("div1");
    setInterval(() => {
        const date1 = new Date();
        div1.innerHTML = date1;
    },1000);
});


// setInterval 문제 해결 방법 1
document.getElementById("btn5").addEventListener("click", function(){
    
    let count = 1;
    setInterval(() => {
        console.log(count++);
    }, 500)

    this.setAttribute("disabled", true);

});

let flag = true;
// setInterval 문제 해결 방법 2
document.getElementById("btn6").addEventListener("click", function(e){

    if(flag){
        flag = false;
        let count = 1;
    
        setInterval(function(){
            // this.innerHTML = count++;
            // ** 일반적인 함수 내에서 this는 window 객체와 묶인다
            e.target.innerHTML = count++;
    
        }, 500);
    }

});


// 시계 만들기
setInterval(function(){

    // 시계가 출력될 요소 선택
    const clock = document.getElementById("clock");
    
    // 현재 시간
    const now = new Date();

    clock.innerText = addZero(now.getHours()) + ":" + addZero(now.getMinutes()) + ":" + addZero(now.getSeconds());

},1000);

// 시계에 출력되는 숫자가 한 자리인 경우 앞에 0 붙이는 함수
function addZero(time){

    if( Number(time) < 10 ) { // 한 자리인 경우
        return "0" + time;
    }else{
        return time;
    }
}


// clearInterval 확인

// * setInterval 저장용 전역 변수
let interval;

// 시작 버튼
document.getElementById("test-btn1").addEventListener("click", function(){
    
    interval = setInterval(function(){
        const random = Math.floor(Math.random() * 26 + 1); // 1 ~ 26

        document.getElementById("test").innerText = addZero(random);
    }, 50);

});


// 종료 버튼
document.getElementById("test-btn2").addEventListener("click", function(){
    clearInterval(interval);
});


console.log(location.href); // location.href를 getter로 사용시 == 현재 주소 얻어옴