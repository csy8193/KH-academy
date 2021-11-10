// 문자열 관련함수 확인하기
function stringTest(){

    const div1 = document.getElementById('div1');

    // 함수가 호출 될 때 마다 #div1 이전 내용 삭제
    div1.innerHTML = "";

    // 테스트용 문자열
    const str1 = "Hello World!";

    div1.innerHTML += "str1.length : " + str1.length; + "<br>";
    // 자바는 문자열.length() / JS는 문자.length
    
    // 대/소문자 변환
    div1.innerHTML += "<hr>";
    div1.innerHTML += "str1.toUpperCase() : " + str1.toUpperCase() + "<br>";
    div1.innerHTML += "str1.toLowerCase() : " + str1.toLowerCase() + "<br>";
    
    // 문자열에서 특정 인덱스에 위치한 문자 하나 반환하기
    div1.innerHTML += "<hr>";
    // div1.innerHTML += "str1.charAt(0) : " + str1.charAt(0) + "<br>";

    // for문을 이용하여 str1에 저장된 문자 하나씩 모두 출력
    for(let i=0; i<str1.length; i++){
        div1.innerHTML += "str1.charAt(" + i + ") : " + str1.charAt(i) + "<br>";

    }

    // indexOf("문자열")
    // 문자열에서 특정 문자열의 시작 인덱스를 찾아서 반환
    div1.innerHTML += "<hr>";
    div1.innerHTML += "앞에서부터 처음 검색된 W의 인덱스 : " + str1.indexOf('W') + "<br>";
    div1.innerHTML += "앞에서부터 처음 검색된 World의 인덱스 : " + str1.indexOf('World') + "<br>";
    div1.innerHTML += "앞에서부터 처음 검색된 apple의 인덱스 : " + str1.indexOf('apple') + "<br>";
    // -1 == 일치하는 단어가 문자열에 존재하지 않음

    // 반대로 검사를 진행하는 lastIndexOf()도 있음


    // substring(시작인덱스, 종료인덱스)
    // 문자열을 시작인덱스 이상, 종료인덱스 미만까지 잘라서 반환
    div1.innerHTML += "<hr>";
    div1.innerHTML += "str1.substring(0, 5) : " + str1.substring(0, 5) + "<br>";
    div1.innerHTML += "str1.substring(6, 11) : " + str1.substring(6, 11) + "<br>";


    // split("구분자")
    // 문자열을 특정 구분자로 잘라서 배열로 반환
    div1.innerHTML += "<hr>";

    const arr = str1.split(" "); // str1 문자열을 " " 띄어쓰기를 구분자로 하여 잘라서 배열로 반환
    div1.innerHTML += "arr[0] : " + arr[0] + "<br>";
    div1.innerHTML += "arr[1] : " + arr[1] + "<br>";
}

//----------------------------------------------------------------------------------------------------------

// 숫자, 숫자 관련 함수 확인하기
function numberTest(){

    // #div2 요소 얻어와서 div2 변수에 저장하기
    const div2 = document.getElementById("div2");

    // #div2 요소에 작성된 이전 내용 모두 삭제
    div2.innerHTML = "";

    // Infinity 확인
    div2.innerHTML += "무한(Infinity) 확인 -> 5 / 0 = " + (5/0) + "<br>";

    const num1 = 10;
    const num2 = 0;
    if( !isFinite(num1/num2)) {
        div2.innerHTML += "0으로 나눌 수 없습니다. <br>";
    }else{
        div2.innerHTML += (num1/num2) + "<br>";
    }


    // NaN (Not a Number) 확인
    div2.innerHTML += "<hr>";

    // 숫자 * 문자 , round(문자)
    // -> 숫자 관련 연산 시 숫자와 관련없는 값이 포함되면 발생

    div2.innerHTML += "aaa * 10 = " + ('aaa'*10) + "<br>";

    const num3 = 5;

    let num4; // 선언만 해둠 == undefined


    if( !isNaN(num3*num4) ){ // 연산 결과가 숫자인경우
        div2.innerHTML += num3 * num4 + "<br>";

    }else{
        div2.innerHTML += "정상적인 연산이 진행될 수 없습니다. <br>";

    }

    // Java에서는 0으로 나누기, 숫자가 아닌 값들의 연산을 예외 또는 컴파일 에러로 막아두었지만
    // JS는 예외 / 컴파일 에러가 없으므로 별도 처리 방법인
    // Infinity와 NaN이 존재한다.


    // Math 내장 객체
    div2.innerHTML += "<hr>";

                                                    // 0 <= random < 1
    div2.innerHTML += "난수 발생 -> Math.random() : " + Math.random() + "<br>";
    
    // 소숫점 첫째자리에서 올림/내림/반올림/버림
    div2.innerHTML += "올림 -> Math.ceil(10.1) : " + Math.ceil(10.1) + "<br>";
    div2.innerHTML += "내림 -> Math.floor(10.9) : " + Math.floor(10.9) + "<br>";
    div2.innerHTML += "반올림 -> Math.round(10.4) : " + Math.round(10.4) + "<br>";
    div2.innerHTML += "반올림 -> Math.round(10.5) : " + Math.round(10.5) + "<br>";
    div2.innerHTML += "반올림 -> Math.trunc(-10.5) : " + Math.trunc(-10.5) + "<br>";

}

// 문자열 -> 숫자 형변환 확인하기
function castingTest() {

    const div3 = document.getElementById("div3");

    div3.innerHTML = "";

    // 숫자로만 작성된 문자열
    const num1 = "100";
    const num2 = "1.234";

    div3.innerHTML += "parseInt('100') + 10 : " + (parseInt(num1) + 10) + "<br>";
    div3.innerHTML += "parseFloat('100') + 10 : " + (parseFloat(num1) + 10)  + "<br>";
    div3.innerHTML += "Number('100') + 10 : " + (Number(num1) + 10)  + "<br>";
    

    div3.innerHTML += "parseInt('1.234') + 10 : " + (parseInt(num2) + 10) + "<br>";
    div3.innerHTML += "parseFloat('1.234') + 10 : " + (parseFloat(num2) + 10)  + "<br>";
    div3.innerHTML += "Number('1.234') + 10 : " + (Number(num2) + 10)  + "<br>";

}


//----------------------------------------------------------------------------------------



// 동등 / 동일 비교 연산자
console.log(1 == "1"); // true
console.log(1 == true); // c언어에서는 true == 1
console.log(0 == "0"); // true
console.log(0 == false); // true

console.log("----------------------");
console.log(1 === "1"); // false
console.log(1 === true); // false
console.log(0 === "0"); // false
console.log(0 === false); // false
console.log(1 === 1); // true