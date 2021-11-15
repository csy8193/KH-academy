const stdList = []; // 비어있는 배열 stdList를 전역 변수로 선언

// 입력 버튼 클릭 시 동작
document.getElementById("input-student").addEventListener("click", function(){
    
    // 1) class가 in인 요소들 모두 얻어오기
    const inputArr = document.getElementsByClassName("in");

    // 추가1) Student 객체 생성
    const std = new Student(inputArr[0].value, inputArr[1].value, inputArr[2].value, inputArr[3].value, inputArr[4].value, inputArr[5].value);


    // 3) tr태그 요소 생성
    const tr = document.createElement("tr");


    let sum = 0; // 합계 저장용 변수
    let index = 0; // 일반 for문의 i 역할

    // 2) 각각의 input 태그에 작성된 값(value)만 모두 얻어오기
    for(let input of inputArr){
        // console.log(input.value);
        
        // 8) input 태그에 값이 입력되지 않은 경우
        if(input.value.trim() == ""){
            // 문자열.trim() : 좌우 공백 제거

            // 9) 경고를 띄우고 미입력된 input태그에 focus 옮기기
            alert("값을 모두 입력 해주세요");
            input.focus();

            return; // 현재 함수를 종료하고 호출한 곳으로 돌아감
            // return 반환값; // 현재 함수를 종료하고 호출한 곳으로 반환값을 가지고 돌아감
        }

        // 4) td 태그 요소를 생성하여 textNode로 input 태그의 값을 집어 넣기
        const td = document.createElement("td");
        const text = document.createTextNode(input.value);
        td.appendChild(text);


        // 5) 생성된 td요소를 3)번에서 생성한 tr 요소의 자식으로 추가
        tr.appendChild(td);

        if(index > 1){
            sum += Number(input.value);
        }

        // 7) input 태그에 작성된 값을 없앰
        input.value = "";

        index++;
    }

    // 평균 td 요소, 점수 textNode 생성 후 tr에 추가
    const td = document.createElement("td");
    const textNode = document.createTextNode( (sum/4).toFixed(1) );
    td.appendChild(textNode);
    tr.appendChild(td);

    document.getElementById("view-student").appendChild(tr);


    // 추가2) stdList에 생성된 Student 객체 끝으로 밀어 넣기
    stdList.push(std);
});


// 나이 오름차순 버튼이 클릭 되었을 때의 동작
document.getElementById("age-asc-btn").addEventListener("click", function(){
    
    // 1. 배열 깊은 복사(원본 데이터 유지 용도)
    // 배열명.slice([시작인덱스, 길이]) : 배열을 시작인덱스 부터 길이만큼을 잘라내어 새로운 배열을 만듦
    // 원본 훼손 없이 새로운 배열 생성(깊은 복사)
    // const arr = [1,2,3,4,5];

    // const copy = arr.slice();

    // copy[0] = 9;

    // console.log(arr);
    // console.log(copy);    

    const copyList = stdList.slice(); // stdList 깊은 복사

    copyList.sort(ageAsc); // copyList 나이 오름차순 정렬

    createView(copyList);

});

// 나이 내림차순 버튼
document.getElementById("age-desc-btn").addEventListener("click", function(){
    const copyList = stdList.slice(); // stdList 깊은 복사

    copyList.sort(ageDesc); // copyList 나이 오름차순 정렬

    createView(copyList);

});


// #view-student의 내용을 모두 삭제하고
// 전달 받은 학생 리스트를 이용해서 화면을 만드는 함수
function createView(list){
    const view = document.getElementById("view-student"); // tbody

    // 1) view 내부 내용 모두 삭제
    view.innerHTML = "";

    // 2) 전달 받은 학생 리스트(list)를 반복 접근
    for(std of list){
        
        // 3) tr 요소 생성
        const tr = document.createElement("tr");

        // 4) std(Student 객체)의 속성을 반복 접근

        for(let key in std){
            // console.log( key + " / " + typeof std[key]  );

            if(typeof std[key] != "function"){
    
                // 5) td 요소를 만들어 얻어온 객체 속성을 textNode로 만들어 추가
                const td = document.createElement("td");
                const textNode = document.createTextNode( std[key] );
                td.appendChild(textNode);
    
                // 6) 만들어진 td 요소를 tr에 자식으로 추가
                tr.appendChild(td);
            }

        } // for문 종료


        // 7) td 요소를 만들어 평균을 textNode로 만들어 추가
        const td = document.createElement("td");
        const textNode = document.createTextNode( std.getAvg() );
        td.appendChild(textNode);

        // 8) 만들어진 td 요소를 tr에 자식으로 추가
        tr.appendChild(td);


        // 9) 만들어진 tr요소를 view에 자식으로 추가
        view.appendChild(tr);
    }


}


// 나이 오름차순 정렬 기준
function ageAsc(std1, std2){
    return std1.age - std2.age;
    // 음수, 0은 그대로, 양수면 인접 두 요소의 자리를 바꿈
}

// 나이 내림차순 정렬 기준
function ageDesc(std1, std2){
    return std2.age - std1.age;
    // 음수, 0은 그대로, 양수면 인접 두 요소의 자리를 바꿈
}