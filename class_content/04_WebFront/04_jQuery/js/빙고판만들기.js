$("#btn").on("click", function(){

    const inputNum = Number($("#input-num").val());

    $("#container").children(".wrap").remove();

    const arr = [];

    for(let i=0; i<inputNum*inputNum; i++){
        const random = Math.floor(Math.random() * inputNum * inputNum + 1);

        if(arr.indexOf(random) == -1){
            arr.push(random);
        }else{
            i--;
        }
    }

    let count = 0

    for(let i=0; i<inputNum; i++){
        const wrap = $("<div>").addClass("wrap");

        for(let j= 0; j< inputNum; j++){
            const box = $("<div>").addClass("box").text(arr[count++]);

            box.on("click", function(){
                if($(this).css("backgroundColor") == "rgb(255, 0, 0)"){
                    $(this).css("backgroundColor", "yellow");

                }else{
                    $(this).css("backgroundColor", "red");

                }
            });

            wrap.append(box);

        }
        $("#container").append(wrap);
    }
})