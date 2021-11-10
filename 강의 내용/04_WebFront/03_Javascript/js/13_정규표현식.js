// 정규 표현식 맛보기
document.getElementById("btn1").addEventListener("click", () => {
    
    // 1. 정규 표현식 객체 생성
    const regExp1 = new RegExp("script");
    const regExp2 = /java/;

    console.log( regExp1.test("javascript 너무 어려워......") ); // t
    console.log( regExp1.test("CSS까진 할만했는데 ...") ); // f


    console.log( regExp2.exec("javascript 내일 끝납니다") ); // java
    console.log( regExp2.exec("다음에는 jQuery 할겁니다") ); // null
    
});


// 메타 문자 확인 1
document.getElementById("btn2").addEventListener("click", () => {

    // a : 문자열 내에 a라는 문자가 있는지 검색
    const regExp1 = /a/;
    console.log( regExp1.test("apple")); // true
    console.log( regExp1.test("price")); // false

    // [abcd] : 문자열 내에 a, b, c, d 중 하나라도 일치하는 문자가 있는지 검색
    //          [] == 문자 한개
    const regExp2 = /[abcd]/;

    console.log("/[abcd]/ : " + regExp2.test("qwerty")); // false
    console.log("/[abcd]/ : " + regExp2.test("qwertyd")); // true 
    console.log("/[abcd]/ : " + regExp2.test("qwerty abcd")); // true


    // ^ (캐럿) : 시작
    // ^group : 문자열이 "group"이라는 단어로 시작하는지 검색
    const regExp3 = /^group/;
    console.log("/^group : " + regExp3.test("group1")); // true
    console.log("/^group : " + regExp3.test("2group")); // false


    // $ (달러) : 끝
    // script$ : 문자열이 "script"라는 단어로 끝나는지 검색
    const regExp4 = /script$/;
    console.log("script$ : " + regExp4.test("javascript")); // true
    console.log("script$ : " + regExp4.test("script 언어란?")); // false

});

// 문자열이 j 또는 a로 시작하고, t또는 x로 끝나는지 확인
document.getElementById("btn3").addEventListener("click", (e) => {
    // 화살표 함수는 this를 사용할 수 없다.

    const regExp = /^[^ja][\w\d\sㄱ-힣\_]*[tx]$/;
    const inputValue = e.target.previousElementSibling.value;

    // \w (word, 단어) : 아무 단어, 아무 글자
    // \d (degit) : 0~9 사이 숫자 중 하나
    // \s (space, 공간) : 공백 문자(띄어쓰기, 엔터, tab 등등)
    // * : 0개 이상 (없거나, 여러개가 있을 수 있음)
    // ㄱ-힣 : 한글 모두(자음, 모음, 받침 관계없이 모두)
    // \_ : "_" 문자 자체를 나타내는 이스케이프 문자

    console.log(regExp.test(inputValue));


});